# *-* coding:utf-8 *-*
#!/usr/bin/python
'''
*******Creator*******
Se varje funktion
'''
import bottle
from modules import log
from modules import handleUsers
from modules import addmod
from bottle import route, get, post, run, template, error, static_file, request, redirect, abort, response, app
from beaker.middleware import SessionMiddleware
import MySQLdb

db = None
cursor = None

def call_database():
	global db
	global cursor
	db = MySQLdb.connect(host="127.0.0.1", port=8889, user="root", passwd="root", db="questway")
	cursor = db.cursor()
	return cursor

def hang_up_on_database():
	global db
	db = db.close()

'''*********Routes*********'''

@route('/')
def startPage():
	cursor = call_database()
	ads = addmod.get_all_approved_ads(cursor)
	job_types = addmod.get_job_types(cursor)
	tags = addmod.get_all_tags(cursor)
	if log.is_user_logged_in() == True:
		lvl = log.get_user_level(cursor)
	else:
		lvl = 0
	hang_up_on_database()
	return template('index.tpl', pageTitle = 'Questway', user_lvl = lvl, ads = ads, job_types = job_types, tags = tags)



'''*********Login*********'''

@route('/login')
def login():
	if log.is_user_logged_in() == True:
		redirect('/admin')
	else:
		return template('login', pageTitle='Logga in')


@route('/ajax', method="POST")
def ajax_validation():
	cursor = call_database()
	result = log.ajax_validation(cursor)
	hang_up_on_database()
	if result == False:
		return 'error'
	else:
		return 'ok'

@route('/do_login', method='POST')
def do_login():
	cursor = call_database()
	response = log.login(cursor)
	hang_up_on_database()
	if response == True:
		redirect('/admin')
	else:
		redirect('error/2')
		return return_error('Tyvärr - användaren finns inte!')


@route('/log_out')
def log_out():
	log.log_out()
	redirect('/login')

@route('/admin')
def admin():
	log.validate_autho() #kontrollerar om användaren är inloggad
	cursor = call_database()
	userid = log.get_user_id_logged_in() #hämtar användarens id
	user_level = log.get_user_level(cursor) #(returnerar 1 eller 2)

	if user_level == 1:
		ads_to_approve = addmod.get_new_ads(cursor)
		hang_up_on_database()
		return template('admin_start', user_id=userid, level="admin", pageTitle = 'Start', ads = ads_to_approve)

	elif user_level == 2:
		ads = addmod.get_all_ads(cursor, userid)
		user_info = handleUsers.get_idvid_user(cursor, userid)
		job_types = addmod.get_job_types(cursor)
		hang_up_on_database()
		return template('employer_start', user_id=userid,  level="employer", pageTitle = 'Start', ads = ads, user_info = user_info['data'][0], job_types = job_types)

	else:
		return return_error('Ej behörighet!')


@route('/about_us')
def about_us_page():
	if log.is_user_logged_in() == False:
		return template('about_us', pageTitle = 'Om Questway', user_autho = "0")
	else:
		cursor = call_database()
		username = log.get_user_name(cursor) #hämtar användarens namn från DB (returnerar en sträng)
		userid = log.get_user_id_logged_in() #hämtar användarens id
		user_level = log.get_user_level(cursor) #(returnerar 1 eller 2)
		hang_up_on_database()
		return template('about_us', pageTitle = 'Om Questway', user=username, user_autho=user_level, user_id=userid)

@route('/help')
def help_page():
	if log.is_user_logged_in() == False:
		return template('help.tpl', pageTitle = 'Hjälp - Questway', user_autho = "0")
	else:
		cursor = call_database()
		username = log.get_user_name(cursor) #hämtar användarens namn från DB (returnerar en sträng)
		userid = log.get_user_id_logged_in() #hämtar användarens id
		user_level = log.get_user_level(cursor) #(returnerar 1 eller 2)
		hang_up_on_database()
		return template('help.tpl', pageTitle = 'Hjälp - Questway', user = username, \
		user_autho=user_level, user_id = userid)

'''********Create-user********'''
@route('/create_employer')
def create_employer():
	if log.is_user_logged_in()==False:
		return template('create_employer', pageTitle='Skapa profil')
	else:
		redirect('/admin')

@route('/ajax_create_user', method="POST")
def ajax_create_validation():
	cursor = call_database()
	result = handleUsers.ajax_new_user_validation(cursor)
	hang_up_on_database()
	if result['result'] == False and result['error'] == 'Bad input':
		return 'Bad input'
	elif result['result'] == False and result['error'] == 'User exists':
		return 'User exists'
	else:
		return 'ok'

@route('/do_create_user', method = 'POST')
def do_create_user():
	global db
	cursor = call_database()
	if log.is_user_logged_in()==False or log.validate_admin(cursor) == True:
		response = handleUsers.create_new_user(cursor)
		db.commit()
		if response['result'] == True:
			if log.is_user_logged_in()==False:
				log.log_in_new_user(response['email'], response['password'], cursor)
				hang_up_on_database()
				redirect('/admin')
			else:
				hang_up_on_database()
				redirect('/handle_users')
		else:
			hang_up_on_database()
			return return_error(response['error'])
	else:
		hang_up_on_database()
		redirect('/admin')


@route('/edith_profile')
def edith_profile():
	log.validate_autho()
	user = log.get_user_id_logged_in()
	cursor = call_database()
	if log.get_user_level(cursor) == 2:
		user_info = handleUsers.get_idvid_user(cursor, user)
		hang_up_on_database()
		if user_info['result'] == True:
			return template('edith_profile', pageTitle = 'Profil', user_info = user_info['data'][0])
		else:
			return return_error(user_info['error'])
	else:
		hang_up_on_database()
		return ('Du måste vara inloggad på rätt konto')

@route('/save_edith_profile', method="POST")
def edith_profile():
	log.validate_autho()
	user = log.get_user_id_logged_in()
	cursor = call_database()
	global db
	if log.get_user_level(cursor) == 2:
		user_info = handleUsers.get_profile_info(cursor, user)
		update = handleUsers.save_update_profile(cursor, user)
		db.commit()
		hang_up_on_database()
		if update['result'] == True:
			redirect('/edith_profile')
		else:
			return return_error(update['error'])

	else:
		hang_up_on_database()
		return ('Du måste vara inloggad på rätt konto')




@route('/edit_mission/<user>/<ad_id>', method="POST")
def edit_mission(user,ad_id):
	global db
	try:
		int(user)
		int(ad_id)
	except:
		return return_error('Något har blciti fel!')
	log.validate_autho()
	if int(log.get_user_id_logged_in()) == int(user):
		cursor = call_database()
		addmod.edit_mission(ad_id, cursor)
		db.commit()
		hang_up_on_database()
		redirect('/profiles/' + str(user))
	return return_error('Ej behörighet!')

'''********Admin********'''
@route('/handle_users')
def handle_users():
	validate_if_admin()
	cursor = call_database()
	users = handleUsers.get_all_users(cursor)
	username = log.get_user_name(cursor)
	hang_up_on_database()
	return template('handle_users.tpl',user=username, pageTitle = 'Användare', users = users)


@route('/admin_ads/<user>')
def handle_spec_users(user):
	validate_if_admin()
	cursor = call_database()
	try:
		user = int(user)
	except:
		return return_error('Användaren finns inte')
	if handleUsers.validate_id(user, cursor) == True:
		user_info = handleUsers.get_idvid_user(cursor, user)
		if user_info['result'] == True:
			username = log.get_user_name(cursor)
			job_types = addmod.get_job_types(cursor)
			ads = addmod.get_all_ads(cursor, user)
			hang_up_on_database()
			return template('admin_ads.tpl',user=username, pageTitle = 'Användare', user_info = user_info['data'][0], job_types = job_types, ads = ads)
		else:
			hang_up_on_database()
			return return_error(response['error'])
	else:
		hang_up_on_database()
		return return_error(response['error'])

@route('/admin_user/<user>')
def handle_spec_users(user):
	validate_if_admin()
	cursor = call_database()
	try:
		user = int(user)
	except:
		return return_error('Användaren finns inte')
	if handleUsers.validate_id(user, cursor) == True:
		user_info = handleUsers.get_idvid_user(cursor, user)
		if user_info['result'] == True:
			username = log.get_user_name(cursor)
			hang_up_on_database()
			return template('admin_user.tpl',user=username, pageTitle = 'Användare', user_info = user_info['data'][0])
		else:
			hang_up_on_database()
			return return_error(response['error'])
	else:
		hang_up_on_database()
		return return_error(response['error'])

@route('/update_user/<user>', method="POST")
def update_user(user):
	global db
	validate_if_admin()
	cursor = call_database()
	try:
		user = int(user)

	except ValueError:
		return return_error('Användaren finns inte')

	if handleUsers.validate_id(user, cursor) == True:
		response = handleUsers.admin_update_user(cursor, user)
		if response['result'] == True:
			db.commit()
			hang_up_on_database()
			redirect('/admin_user/'+str(user))
		else:
			hang_up_on_database()
			return return_error(response['error'])

@route('/delete_user')
def delete_user():
	global db
	cursor = call_database()
	log.validate_autho()
	user = log.get_user_id_logged_in()
	if log.get_user_level(cursor) == 2:
		response = handleUsers.delete_user(cursor, user)
		db.commit()
		hang_up_on_database()
		log.log_out()
		redirect('/')
	else:
		return return_error('Du måste vara inne på rätt konto')


@route('/admin_delete_user/<user>')
def delete_user(user):
	validate_if_admin()
	global db
	try:
		user = int(user)
	except ValueError:
		return return_error('Användaren finns inte')
	cursor = call_database()
	if handleUsers.validate_id(user, cursor) == True:
		handleUsers.delete_user(cursor, user)
		db.commit()
		save_path = "static/img/uploads/user_" + str(user)
		hang_up_on_database()
		redirect('/handle_users')
	else:
		hang_up_on_database()
		return return_error('Användaren finns inte')


@route('/admin_make_ad/<user>', method="POST")
def ad_done(user):
	'''Admin creates a new ad in the DB'''
	validate_if_admin()
	try:
		user = int(user)
	except ValueError:
		return return_error('Användaren finns inte')

	global db
	cursor = call_database()
	if handleUsers.validate_id(user, cursor) == True:
		response=addmod.do_ad(cursor, user)
		db.commit()
		hang_up_on_database()
		if response['result']==True:
			redirect('/admin_ads/'+str(user))

		else:
			return return_error(response['error'])

	else:
		hang_up_on_database()
		return return_error('Användaren finns inte')

@route('/admin_delete_ad/<user>/<ad_nr>')
def delete_ad(user, ad_nr):
	validate_if_admin()
	try:
		ad_nr = int(ad_nr)
		user = int(user)
	except ValueError:
		return return_error('Annonsen eller användaren finns inte')
	cursor = call_database()
	global db
	addmod.erase_ad(cursor, user, ad_nr)
	db.commit()
	hang_up_on_database()
	redirect('/admin_ads/'+str(user))

@route('/admin_denie_ad/<user>/<ad_nr>')
def delete_ad(user, ad_nr):
	validate_if_admin()
	try:
		ad_nr = int(ad_nr)
		user = int(user)
	except ValueError:
		return return_error('Annonsen eller användaren finns inte')
	cursor = call_database()
	global db
	addmod.erase_ad(cursor, user, ad_nr)
	db.commit()
	hang_up_on_database()
	redirect('/admin')


@route('/admin_approve_ad/<user>/<ad_nr>')
def approve_ad(user, ad_nr):
	validate_if_admin()
	try:
		ad_nr = int(ad_nr)
		user = int(user)
	except ValueError:
		return return_error('Annonsen eller användaren finns inte')
	cursor = call_database()
	global db
	addmod.approve_new_ad(cursor, user, ad_nr)
	db.commit()
	hang_up_on_database()
	redirect('/admin')

'''********Ad-management********'''

@route('/job/<ad_nr>')
def spec_ad(ad_nr):
	try:
		ad_nr = int(ad_nr)
	except ValueError:
		return return_error('Annonsen finns inte')

	cursor = call_database()
	ad_info = addmod.get_spec_ads(cursor, ad_nr)
	tags = addmod.get_spec_tags(cursor, ad_nr)
	if ad_info:
		if log.is_user_logged_in() == True:
			lvl = log.get_user_level(cursor)
			return template('ad.tpl', pageTitle = ad_info[0][3], user_lvl = lvl, ad_info = ad_info[0], tags = tags)
		elif ad_info[0][6] == 1:
			lvl = 0
			return template('ad.tpl', pageTitle = ad_info[0][3], user_lvl = lvl, ad_info = ad_info[0], tags = tags)
		else:
			redirect('/')
	else:
		return return_error('Annonsen finns inte')


@route('/post_job', method="POST")
def post_job():
	'''Creates a new ad in the DB'''
	global db
	cursor = call_database()
	log.validate_autho()
	user = log.get_user_id_logged_in()
	if log.get_user_level(cursor) == 2:
		response=addmod.do_ad(cursor, user)
		db.commit()
		hang_up_on_database()
		if response['result']==True:
			redirect('/admin')
		else:
			return return_error(response['error'])
	else:
		hang_up_on_database()
		return return_error('Du måste vara inloggad på rätt konto.')


@route('/make_ad')
def no_get():
	redirect('/admin')


@route('/apply_in_job/<job_nr>', method="POST")
def application(job_nr):
	try:
		job_nr = int(job_nr)
		print job_nr
		print type(job_nr)
	except ValueError:
		return 'error'

	cursor = call_database()
	global db
	result = addmod.apply(cursor, job_nr)
	db.commit()
	hang_up_on_database()
	if result['result'] == True:
		return 'ok'
	else:
		return 'error'


@route('/job/applications/<ad_nr>')
def applications(ad_nr):
	try:
		ad_nr = int(ad_nr)
	except ValueError:
		return return_error('Annonsen finns inte')
	cursor = call_database()
	log.validate_autho()
	user = log.get_user_id_logged_in()
	lvl = log.get_user_level(cursor)
	if lvl == 2:
		if addmod.validate_ad_creator(cursor, user, ad_nr) == False:
			hang_up_on_database()
			return return_error('Behörighet saknas')

	ad_info = addmod.get_spec_ads(cursor, ad_nr)
	applications = addmod.get_job_applications(cursor, ad_nr)
	applicants = addmod.get_job_applicants(cursor, ad_nr)
	labels = addmod.get_labels(cursor, ad_nr)
	got_labels = addmod.get_added_labels(cursor, ad_nr)
	hang_up_on_database()
	return template('applicants.tpl', pageTitle = 'Annsökningar | '+ ad_info[0][3], user_lvl = lvl, ad_info = ad_info[0], applications = applications, applicants = applicants, labels = labels, got_labels = got_labels)


@route('/update_label/<ad_nr>/<application_nr>/<label_nr>', method="post")
def update_label(ad_nr, application_nr, label_nr):
	try:
		application_nr = int(application_nr)
		label_nr = int(label_nr)
		ad_nr = int(ad_nr)
	except ValueError:
		return 'Fel'
	if log.is_user_logged_in() == True:
		cursor = call_database()
		user = log.get_user_id_logged_in()
		lvl = log.get_user_level(cursor)
		if lvl == 2:
			if addmod.validate_ad_creator(cursor, user, ad_nr) == False:
				hang_up_on_database()
				return 'Fel'

		global db
		addmod.update_label_status(cursor, label_nr, application_nr)
		db.commit()
		hang_up_on_database()
		return 'Ok'

	else:
		return 'Fel'

@route('/update_label_text/<label_nr>', method="post")
def update_label_text(label_nr):
	try:
		label_nr = int(label_nr)
	except ValueError:
		return 'Fel'

	if log.is_user_logged_in() == True:
		cursor = call_database()
		user = log.get_user_id_logged_in()
		lvl = log.get_user_level(cursor)
		if lvl == 2:
			if addmod.validate_label_nr_creator(cursor, user, label_nr) == False:
				hang_up_on_database()
				return 'Fel'

		global db
		addmod.update_label_text(cursor, label_nr)
		db.commit()
		hang_up_on_database()
		return 'Ok'

	else:
		return 'Fel'

@route('/admin_remove_application/<ad_nr>/<application_nr>')
def remove_application(ad_nr, application_nr):
	try:
		application_nr = int(application_nr)
	except ValueError:
		return return_error('Annonsen finns inte')
	validate_if_admin()
	cursor = call_database()
	global db
	addmod.remove_application(cursor, application_nr)
	db.commit()
	hang_up_on_database()
	redirect('/job/applications/'+ad_nr)



'''*****Delete ad*****'''

@route('/delete_ad/<ad_nr>')
def delete_ad(ad_nr):
	'''Deletes a specifik ad in the DB'''
	try:
		ad_nr = int(ad_nr)
	except ValueError:
		return return_error('Annonsen finns inte')

	global db
	cursor = call_database()
	log.validate_autho()
	user = log.get_user_id_logged_in()
	if log.get_user_level(cursor) == 2:
		if addmod.validate_ad_creator(cursor, user, ad_nr) == True:
			addmod.erase_ad(cursor, user, ad_nr)
			db.commit()
			hang_up_on_database()
			redirect('/admin')
		else:
			hang_up_on_database()
			return return_error('Du saknar behörighet')
	else:
		hang_up_on_database()
		return return_error('Du måste vara inloggad på rätt konto.')


'''****All the ads and their applications listed***'''

@route('/allMissions')
def list_applied_students():
	'''lists all ads with their specific application status'''
	cursor = call_database()
	log.validate_autho()
	if log.get_user_level(cursor) == 2:
		user_id=log.get_user_id_logged_in()
		username=log.get_user_name(cursor)
		relevant_adds=addmod.get_my_ads(user_id, cursor)
		students_application = addmod.students_that_applied(user_id, cursor)
		feedback_info = addmod.get_given_feedback_for_employers(user_id, cursor)
		hang_up_on_database()
		return template('adds.tpl',user_id=user_id, user=username, adds=relevant_adds, \
		students=students_application, pageTitle='Alla uppdrag', feedback = feedback_info)
	else:
		hang_up_on_database()
		return return_error('Behörighet saknas')


def validate_if_admin():
	cursor = call_database()
	if log.validate_admin(cursor) == True:
		hang_up_on_database()
		return True
	else:
		hang_up_on_database()
		abort(401, "Behörighet saknas")

@route('/error/<error_nr>')
def error_page(error_nr):
	try:
		error_nr = int(error_nr)
	except ValueError:
		 return 'Något har blivit fel'

	if error_nr == 1:
		error_message = 'Du saknar behörighet'

	elif error_nr == 2:
		error_message = 'Tyvärr - användaren finns inte!'

	else:
		error_message = 'Något har blivit fel'

	return error_message

def return_error(error_message):
	return error_message


'''********Övriga Routes********'''

@error(404)
def error404(error):
    return template('pagenotfound', pageTitle = 'Fel!' )


@route('/static/<filename:path>')
def server_static(filename):
    return static_file(filename, root="static")


app = SessionMiddleware(app(), log.session_opts)
run(host= '0.0.0.0', port=8080 , app=app)
