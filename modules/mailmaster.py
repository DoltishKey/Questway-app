# *-* coding:utf-8 *-*
#!/usr/bin/python
import time
import random, string


def send_new_password_email(email, id, cursor):
    # 1. Generera en random lång url_logo
    # 2. Spara url + användare + tid i db
    # 3. Skicka mail till email med url

    url_wildcard = str(''.join(random.choice(string.lowercase + string.digits) for i in range(64)))
    url = 'new_password/'+url_wildcard

    sql = "INSERT INTO qw_reset_password(email, url, request_time) VALUES (%s, %s, NOW())"
    cursor.execute(sql, (email, url_wildcard,))

    #send_email(email, message, url)
    return True

def validate_url(cursor, url):
    sql="SELECT * FROM qw_reset_password WHERE url = %s AND request_time > NOW() - INTERVAL 60 MINUTE"
    cursor.execute(sql,(url,))
    mighty_db_says = cursor.fetchall()
    if mighty_db_says:
        return True
    else:
        return False

def send_email(email, message, url):
    pass
