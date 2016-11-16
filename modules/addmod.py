# *-* coding:utf-8 *-*
from bottle import request, response
import log
import os.path
import random, string
from PIL import Image
import tinify
import cStringIO
import json
from validate_email import validate_email

fileIn = open('keys.json', 'r')
dataRead = json.load(fileIn)
fileIn.close()
tinify.key = dataRead[0]['key']

'''*********Ad validators*********'''

def validate_ad_main_input(ad_info):
    '''Last point of validation to check that it exists a title'''
    for item in ad_info:
        if item.isspace() == True or item == '':
            return False
    return True

def validate_tags(ad_tags):
    tags = []
    for tag in ad_tags:
        if tag != None and len(tag) != 0 and tag.isspace() == False:
            tags.append(tag.lower())

    tags = list(set(tags))
    return tags

def validate_ad_creator(cursor, user, ad_nr):
    ad = get_spec_ads(cursor, ad_nr)
    if ad:
        if ad[0][1] == user:
            return True
        else:
            return False
    else:
        return False

def validate_if_ad(cursor, ad_nr):
    sql = "SELECT * FROM qw_ads WHERE id = %s AND display = 1"
    cursor.execute(sql, (ad_nr,))
    mighty_db_says = cursor.fetchall()
    if mighty_db_says:
        return True
    else:
        return False

def validate_label_nr_creator(cursor, user, label_nr):
    sql = "SELECT qw_ads.creator_id FROM qw_filter JOIN qw_ads ON qw_filter.ad_id = qw_ads.id WHERE qw_filter.id=%s"
    cursor.execute(sql, (label_nr,))
    mighty_db_says = cursor.fetchall()
    if mighty_db_says[0][0] == user:
        return True
    else:
        return False


'''*********General ad info*********'''

def get_ad_creator_id(cursor, ad_nr):
    ''' Return id of ads creator'''
    sql= "SELECT creator_id FROM ads WHERE id=%s"
    cursor.execute(sql, (ad_nr,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says[0][0]

def get_job_types(cursor):
    sql = "SELECT * FROM qw_main_type"
    cursor.execute(sql)
    mighty_db_says = cursor.fetchall()
    return mighty_db_says


'''*********Create/remove AD*********'''
def do_ad(cursor, user):
    '''Get data from user and create an ad'''
    img_logo = request.files.get('img_logo')
    img_cover = request.files.get('img_cover')
    company_name = request.forms.get('company_name')
    about_company = request.forms.get('about_company')
    company_link = request.forms.get('company_link')
    ad_title = request.forms.get('ad_title')
    about_job = request.forms.get('about_job')
    ad_type = int(request.forms.get('ad_type'))
    ad_tags = request.POST.getall('add_key_tag')

    validated_main_input=validate_ad_main_input([ad_title, about_job])
    if validated_main_input == True:
        tags = None
        if ad_tags:
            tags = validate_tags(ad_tags)

        #Sets ad status - If creator is admin it can be displayed dirr.
        if log.get_user_level(cursor) == 1:
            display = True
        else:
            display = False

        #Get data about company
        sql = "SELECT * FROM qw_employers WHERE id = %s"
        cursor.execute(sql, (user,))
        company_info = cursor.fetchall()

        #Handeling logo
        if img_logo:
            img_result = img_handeling(2, img_logo, 125, 125, user)
            if img_result['result'] == True:
                logo_file_path = img_result['path']
            else:
                return img_result
        else:
            logo_file_path = company_info[0][4]

        #Handeling logo
        if img_cover:
            img_result = img_handeling(5, img_cover, 800, 500, user)
            if img_result['result'] == True:
                cover_file_path = img_result['path']
            else:
                return img_result
        else:
            cover_file_path = company_info[0][5]


        #SQL som skapar annons
        sql = "INSERT INTO qw_ads(creator_id, main_type, title, main_info, creatriondate, display, link, company_name, \
        url_logo, url_cover, about) VALUES ((SELECT id from qw_users WHERE id = %s), (SELECT id FROM qw_main_type WHERE id = %s), %s, %s, CURDATE(), %s, %s, %s, %s, %s, %s)"
        cursor.execute(sql, (user, ad_type, ad_title, about_job, display, company_link, company_name, logo_file_path, cover_file_path, about_company,))
        mighty_db_says = cursor.lastrowid

        #SQL som lägger in taggar
        if tags and len(tags) > 0:
            tags = zip(tags)
            sql = "INSERT INTO qw_spec_tags (name) VALUES (%s) \
            ON DUPLICATE KEY UPDATE name = name;"
            cursor.executemany(sql, tags)

            new_tags = []
            for tag in tags:
                tag = list(tag)
                tag.append(int(mighty_db_says))
                new_tags.append(tuple(tag))
            print new_tags
            sql = "INSERT INTO qw_spec_types (spec_tag, ad_id) \
            VALUES ((select name from qw_spec_tags where name = %s), (select id from qw_ads where id = %s))"
            cursor.executemany(sql, new_tags)

        #SQL som uppdaterar företagsprofilen
        sql = "UPDATE qw_employers SET link = %s, company_name = %s, url_logo = %s, url_cover = %s, about = %s WHERE id = %s"
        cursor.execute(sql, (company_link, company_name, logo_file_path, cover_file_path, about_company, user,))

        #SQL som sätter in labels till filtreringen
        labels = []
        colors = ['#2CBD66', '#FFF028', '#FF8528', '#B42F35', '#2BCAD9','#AD1FCA']
        label_text = ['Very good', 'Maybe', 'Need more info', 'Not good', 'Interview', 'Contacted']
        for idx, color in enumerate(colors, start=0):
            new_item = tuple((mighty_db_says, label_text[idx], color))
            labels.append(new_item)

        sql = "INSERT INTO qw_filter (ad_id, name, color) VALUES ((SELECT id FROM qw_ads WHERE id = %s), %s, %s)"
        cursor.executemany(sql, labels)

        return {'result':True, 'error':'None'}

    else:
        return {'result':False, 'error': "Ett fel uppstod - Kontrollera att du gav annonsen en titel, berskivning av jobbet och typ av jobb."}



def erase_ad(cursor, user, ad_nr):
    sql = "DELETE FROM qw_ads WHERE id = %s AND creator_id = %s"
    cursor.execute(sql, (ad_nr, user,))



'''*********AD listing*********'''
def get_all_ads(cursor, user):
    '''Returns all ads from a specific user'''
    sql = "SELECT qw_ads.*, COUNT(qw_application.id) FROM qw_application \
    RIGHT OUTER JOIN qw_ads ON qw_application.ad_id = qw_ads.id \
    WHERE creator_id = %s GROUP BY qw_ads.id"
    cursor.execute(sql,(user,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def get_all_approved_ads(cursor):
    '''Returns all ads from a specific user'''
    sql = "SELECT * FROM qw_ads WHERE display = 1"
    cursor.execute(sql)
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def get_all_tags(cursor):
    sql = "SELECT qw_spec_types.* FROM qw_spec_types \
    JOIN qw_ads ON qw_spec_types.ad_id = qw_ads.id \
    WHERE qw_ads.display = 1"
    cursor.execute(sql)
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def get_spec_ads(cursor, ad_nr):
    '''Returns a specific ad from a specific user'''
    sql = "SELECT * FROM qw_ads WHERE id = %s"
    cursor.execute(sql, (ad_nr,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def get_spec_tags(cursor, ad_nr):
    sql = "SELECT spec_tag FROM qw_spec_types WHERE ad_id = %s"
    cursor.execute(sql, (ad_nr,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def get_new_ads(cursor):
    sql = "SELECT * FROM qw_ads WHERE display = 0"
    cursor.execute(sql)
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def approve_new_ad(cursor, user, ad_nr):
    sql = "UPDATE qw_ads SET display = 1 WHERE creator_id = %s AND id = %s"
    cursor.execute(sql, (user, ad_nr,))


'''******Application manegment*****'''

def apply(cursor, job_nr):
    if validate_if_ad(cursor, job_nr) == True:
        name = request.forms.get('name')
        phone = request.forms.get('phone')
        email = request.forms.get('email')
        message = request.forms.get('message')
        main_app_info = [name, phone, email]

        #Validates main application
        for info in main_app_info:
            if info == None or len(info) == 0:
                return {'result':False, 'error': 'Du måste uppge namn, tele och mejl'}
        if validate_email.validate_email(email) == False:
            return {'result':False, 'error':'Du måste ange en riktig email!'}

        if len(phone) < 8:
            return {'result':False, 'error':'Phonenumber is too short!'}

        #Validates applicants
        additional_names = request.POST.getall('additional_name')
        additional_phones = request.POST.getall('additional_phone')
        additional_email = request.POST.getall('additional_email')
        for idx, ad_name in enumerate(additional_names):
            if ad_name == None or len(ad_name) == 0:
                if (additional_phones[idx] == None or len(additional_phones[idx]) == 0) and (additional_email[idx] == None or len(additional_email[idx]) == 0):
                    additional_names.pop(idx)
                    additional_phones.pop(idx)
                    additional_email.pop(idx)
                else:
                    return {'result':False, 'error': 'Du måste uppge namn på alla i gruppen!'}

        #Creates application
        sql = "INSERT INTO qw_application (ad_id, application_text)\
        VALUES ((SELECT id FROM qw_ads WHERE id = %s), %s)"
        cursor.execute(sql, (job_nr, message,))
        application_id = cursor.lastrowid

        #Prepare applicants
        first_member = tuple((application_id, name, phone, email))
        members = [first_member]
        for idx, ad_name in enumerate(additional_names):
            member = tuple((application_id, ad_name, additional_phones[idx], additional_email[idx]))
            members.append(member)

        #Inserts all members
        sql = "INSERT INTO qw_person (application_id, name, phone, mail) \
        VALUES ((select id from qw_application where id = %s), %s, %s, %s)"
        cursor.executemany(sql, members)


        ad_labels = get_labels(cursor, job_nr)
        labels = []
        for label in ad_labels:
            new_label = tuple((int(label[0]), int(application_id), False))
            labels.append(new_label)
        print labels

        #Inserts all labels on an application
        sql = "INSERT INTO qw_get_filter (filter_id, application_id, got_it)\
        VALUES ((SELECT id FROM qw_filter WHERE id = %s), (SELECT id FROM qw_application WHERE id = %s), %s)"
        cursor.executemany(sql, labels)

        return {'result':True}

    else:
        return {'result':False, 'error':'Annonsen finns inte!'}


def get_job_applications(cursor, ad_nr):
    sql = "SELECT * FROM qw_application WHERE ad_id = %s"
    cursor.execute(sql, (ad_nr,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says


def get_job_applicants(cursor, ad_nr):
    sql = "SELECT qw_person.* FROM qw_application \
    JOIN qw_person ON qw_application.id = qw_person.application_id WHERE qw_application.ad_id = %s"
    cursor.execute(sql, (ad_nr,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def get_labels(cursor, ad_nr):
    sql="SELECT * FROM qw_filter WHERE ad_id = %s"
    cursor.execute(sql, (ad_nr,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def get_added_labels(cursor, ad_nr):
    sql = "SELECT qw_get_filter.*, qw_filter.color, qw_filter.name  FROM qw_filter \
    JOIN qw_get_filter ON qw_get_filter.filter_id = qw_filter.id \
    WHERE qw_filter.ad_id = %s"
    cursor.execute(sql, (ad_nr,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says

def update_label_status(cursor, label_nr, application_nr):
    sql = "UPDATE qw_get_filter SET got_it = NOT got_it WHERE filter_id= %s AND application_id=%s"
    cursor.execute(sql, (label_nr, application_nr,))

def update_label_text(cursor, label_nr):
    name = request.forms.get('label_text')
    sql="UPDATE qw_filter SET name=%s WHERE id = %s"
    cursor.execute(sql, (name, label_nr,))


def remove_application(cursor, application_nr):
    sql = "DELETE FROM qw_application WHERE id = %s"
    cursor.execute(sql, (application_nr,))

'''**************Image handeling**************'''

def img_handeling(max_mem, img, width, heigth, user):

    MAX_SIZE = max_mem * 1024 * 1024 # 2MB
    BUF_SIZE = 8192
    data_blocks = []
    byte_count = 0
    buf = img.file.read(BUF_SIZE)
    while buf:
        byte_count += len(buf)
        if byte_count > MAX_SIZE:
            return {'result':False, 'error': "Filen är för stor!"}
        data_blocks.append(buf)
        buf = img.file.read(BUF_SIZE)
    data = ''.join(data_blocks)

    try:
        i=Image.open(img.file)
        print i.format
    except IOError:
        return {'result':False, 'error': "Det är något fel med filen!"}

    name, ext = os.path.splitext(img.filename)
    if ext.lower() not in ('.png','.jpg','.jpeg', '.PNG'):
        return {'result':False, 'error': "Filformatet stöds inte"}

    if i.format.lower() not in ('png','jpg','jpeg', 'PNG'):
        return {'result':False, 'error': "Filformatet stöds inte"}

    save_path = "static/img/uploads/user_" + str(user)
    if not os.path.exists(save_path):
        os.makedirs(save_path)
    img.filename = str(''.join(random.choice(string.lowercase + string.digits) for i in range(16)))+str(ext)
    while os.path.isfile('static/img/uploads/user_'+ str(user) + '/' + img.filename) == True:
        img.filename = str(''.join(random.choice(string.lowercase + string.digits) for i in range(16)))+str(ext)
    file_path = "{path}/{file}".format(path=save_path, file=img.filename)

    size = width, heigth
    im = Image.open(img.file)
    width, height = im.size
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(file_path)

    with open(file_path, 'rb') as source:
        source_data = source.read()
        result_data = tinify.from_buffer(source_data).to_buffer()
    im = Image.open(cStringIO.StringIO(result_data))
    im.save(file_path)

    return {'result':True, 'path': file_path}
