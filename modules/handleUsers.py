# *-* coding:utf-8 *-*
import bottle
from bottle import route, get, post, run, template, error, static_file, request, abort, response, app
from validate_email import validate_email
import MySQLdb
import hashlib


'''*********Validation*********'''
def validate_Username(email, cursor):
    '''check that the email do not already exist in DB'''
    sql = "SELECT * FROM qw_users WHERE mail = %s"
    cursor.execute(sql, (email,))
    mighty_db_says = cursor.fetchall()

    if mighty_db_says:
        return True

def update_validate_Username(email, cursor):
    sql = "SELECT * FROM qw_users WHERE mail = %s"
    cursor.execute(sql, (email,))
    mighty_db_says = cursor.fetchall()
    if mighty_db_says and mighty_db_says[0][3] != email:
        return True

def validate_id(user, cursor):
    sql = "SELECT * FROM qw_users WHERE id = %s"
    cursor.execute(sql, (user,))
    mighty_db_says = cursor.fetchall()
    if mighty_db_says:
        return True

def validate_password(cursor, user, password):
    sql = "SELECT password FROM qw_users WHERE id =%s"
    password = hashlib.sha256(password).hexdigest()
    cursor.execute(sql, (user,))
    mighty_db_says = cursor.fetchall()
    if mighty_db_says[0][0] == password:
        return True
    else:
        return False

def ajax_new_user_validation(cursor):
	email = request.forms.get('email')
	if email == None or len(email) == 0 or validate_email.validate_email(email) == False:
		return {'result': False, 'error':'Bad input'}
	elif validate_Username(email, cursor) == True:
		return {'result': False, 'error':'User exists'}
	else:
		return {'result': True}

def get_user_from_email(email, cursor):
    sql = "SELECT id, autho_level, mail FROM qw_users WHERE mail = %s"
    cursor.execute(sql, (email,))
    mighty_db_says = cursor.fetchall()
    if mighty_db_says:
        return mighty_db_says[0]
    else:
        return False



'''*********Funktions*********'''
def add_new_user(password, user_level, email, first_name, last_name, cursor):
    '''Creates a new user based on userinput'''
    password = hashlib.sha256(password).hexdigest()
    sql = "INSERT INTO qw_users(password, autho_level, mail, firstname, lastname) \
       VALUES (%s, %s, %s, %s, %s )"

    cursor.execute(sql, (password, user_level, email, first_name, last_name,))
    mighty_db_says =cursor.lastrowid
    return mighty_db_says


def add_new_employer(new_user_id, phone, cursor):
    '''Instance of User - Creates an employer in the DB'''
    sql = "INSERT INTO qw_employers(id, phone) \
       VALUES ((select id from qw_users where id = %s), %s )"
    cursor.execute(sql, (new_user_id, phone,))

def update_user(user, first_name, last_name, email, phone, cursor):
    user = int(user)

    sql="UPDATE qw_users SET firstname = %s, lastname = %s, mail = %s WHERE id = %s"
    cursor.execute(sql, (first_name, last_name, email, user,))

    sql="UPDATE qw_employers SET phone = %s WHERE id = %s"
    cursor.execute(sql, (phone, user,))

def update_user_and_password(user, first_name, last_name, email, password, phone, cursor):
    password = hashlib.sha256(password).hexdigest()
    sql="UPDATE qw_users SET firstname = %s, lastname = %s, mail = %s, password = %s WHERE id = %s"
    cursor.execute(sql, (first_name, last_name, email, password, user,))

    sql="UPDATE qw_employers SET phone = %s WHERE id = %s"
    cursor.execute(sql, (phone, user,))


def get_profile_info(cursor, user):
    sql ="SELECT qw_users.*, qw_employers.phone FROM qw_employers JOIN qw_users\
    ON qw_employers.id = qw_users.id WHERE qw_users.id = %s"
    cursor.execute(sql, (user,))
    mighty_db_says = cursor.fetchall()
    return mighty_db_says[0]


'''*********Main - Functions*********'''
def create_new_user(cursor):
    '''Prepare the information before creating an employer-profile'''
    first_name = request.forms.get('first_name')
    last_name = request.forms.get('last_name')
    email = request.forms.get('email')
    phone = request.forms.get('phone')
    password = request.forms.get('password')
    user_inputs=[first_name,last_name,email,password, phone]
    for user_input in user_inputs:
        if user_input == None or len(user_input) == 0:
            return {'result':False, 'error': 'Inget fält får vara tomt!'}

    if validate_Username(email, cursor) == True:
        return {'result':False, 'error':'Tyvärr - en användare med samma email finns redan!'}

    elif validate_email.validate_email(email) == False:
        return {'result':False, 'error':'Du måste ange en riktig email!'}

    else:
        user_level = 2
        new_user_id = add_new_user(password, user_level, email, first_name, last_name, cursor)
        add_new_employer(new_user_id, phone, cursor)
        return {'result':True, 'email':email, 'password':password}


def save_update_profile(cursor, user):
    first_name = request.forms.get('firstname')
    last_name = request.forms.get('lastname')
    email = request.forms.get('email')
    phone = request.forms.get('phone')
    current_password = request.forms.get('current_password')
    new_password_one = request.forms.get('new_password_one')
    new_password_two = request.forms.get('new_password_two')
    user_inputs=[first_name,last_name, email, phone]
    for user_input in user_inputs:
        if user_input == None or len(user_input) == 0:
            return {'result':False, 'error': 'Du måste ange förnman, efternamn, email och tele'}

    if update_validate_Username(email, cursor) == True:
        return {'result':False, 'error':'Tyvärr - en användare med samma email finns redan!'}

    elif validate_email.validate_email(email) == False:
        return {'result':False, 'error':'Du måste ange en riktig email!'}

    if current_password or new_password_one or new_password_two:
        update_password = [current_password,new_password_one,email, new_password_two]
        for password in update_password:
            if password == None or len(password) == 0:
                return {'result':False, 'error': 'För att byta lösenord måste alla fälten vara ifylda'}

        if new_password_one == new_password_two:
            if validate_password(cursor, user, current_password) == True:
                update_user_and_password(user, first_name, last_name, email, new_password_one, phone, cursor)
                return {'result':True}
            else:
                return {'result':False, 'error': 'Fel lösenord'}
        else:
            return {'result':False, 'error': 'Lösenorden måste matcha'}

    else:
        update_user(user, first_name, last_name, email, phone, cursor)
        return {'result':True}

def update_password(cursor, url):

    print url
    sql="SELECT qw_users.* FROM qw_reset_password JOIN \
    qw_users ON qw_reset_password.email = qw_users.mail WHERE qw_reset_password.url = %s"
    cursor.execute(sql, (url,))
    mighty_db_says = cursor.fetchall()

    password_one = request.forms.get('password_one')
    password_two = request.forms.get('password_two')
    if password_one == password_two:
        new_password = hashlib.sha256(password_one).hexdigest()
        sql = "UPDATE qw_users SET password = %s WHERE id = %s"
        cursor.execute(sql,(new_password, mighty_db_says[0][0],))

        sql = 'DELETE FROM qw_reset_password WHERE url = %s'
        cursor.execute(sql,(url,))
        
        return {'result':True}

    else:
        return {'result':False, 'error':'Passwords must match'}

'''*********Admin - Functions*********'''
def get_all_users(cursor):
    '''Selects all users from DB'''
    sql = "SELECT qw_users.id, firstname, lastname, mail, phone, COUNT(qw_ads.id) FROM qw_ads \
        RIGHT OUTER JOIN qw_users ON qw_ads.creator_id = qw_users.id \
        JOIN qw_employers ON qw_users.id = qw_employers.id \
        WHERE autho_level = 2 GROUP BY qw_users.id"
    cursor.execute(sql,)
    mighty_db_says = cursor.fetchall()

    if mighty_db_says:
        return mighty_db_says

def get_idvid_user(cursor, user):
    try:
        int(user)
    except ValueError:
        return {'result':False, 'error':'Något har blivit fel!'}

    sql = "SELECT qw_users.id, firstname, lastname, mail, phone, link, company_name, url_logo, url_cover, about  FROM qw_employers \
        RIGHT OUTER JOIN qw_users ON qw_users.id = qw_employers.id \
        WHERE qw_users.id = %s AND autho_level = 2"
    cursor.execute(sql, (user,))
    mighty_db_says = cursor.fetchall()
    if len(mighty_db_says) == 1:
        return {'result':True, 'data':mighty_db_says}
    else:
        return {'result':False, 'error':'Användare finns inte'}



def admin_update_user(cursor, user):
    first_name = request.forms.get('firstname')
    last_name = request.forms.get('lastname')
    email = request.forms.get('email')
    phone = request.forms.get('phone')

    user_inputs=[first_name,last_name,email, phone]
    try:
        int(user)
    except ValueError:
        return {'result':False, 'error': 'Användaren finns inte'}

    for user_input in user_inputs:
        if user_input == None or len(user_input) == 0:
            return {'result':False, 'error': 'Inget fält får vara tomt!'}
    if update_validate_Username(email, cursor) == True:
        return {'result':False, 'error':'Tyvärr - en användare med samma email finns redan!'}

    elif validate_email.validate_email(email) == False:
        return {'result':False, 'error':'Du måste ange en riktig email!'}

    else:
        update_user(user, first_name, last_name, email, phone, cursor)
        return {'result':True}


def delete_user(cursor, user):
    sql = "DELETE FROM qw_users WHERE id = %s"
    cursor.execute(sql, (user,))
