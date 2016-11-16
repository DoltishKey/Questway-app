# *-* coding:utf-8 *-*
#!/usr/bin/python
import time
import random, string
import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText


def send_new_password_email(email, id, cursor):
    # 1. Generera en random lång url_logo
    # 2. Spara url + användare + tid i db
    # 3. Skicka mail till email med url

    url_wildcard = str(''.join(random.choice(string.lowercase + string.digits) for i in range(64)))
    message = 'new_password/'+url_wildcard

    sql = "INSERT INTO qw_reset_password(email, url, request_time) VALUES (%s, %s, NOW())"
    cursor.execute(sql, (email, url_wildcard,))

    send_email(email, message)
    return True

def validate_url(cursor, url):
    sql="SELECT * FROM qw_reset_password WHERE url = %s AND request_time > NOW() - INTERVAL 60 MINUTE"
    cursor.execute(sql,(url,))
    mighty_db_says = cursor.fetchall()
    if mighty_db_says:
        return True
    else:
        return False

def send_email(email, message):
    fromaddr = "jacob.pettersson@questway.se"
    toaddr = email
    msg = MIMEMultipart()
    msg['From'] = fromaddr
    msg['To'] = toaddr
    msg['Subject'] = "Reset password"

    body = """\
    <html>
      <head></head>
      <body>
        <p>Hello from Questway!<br>
           Follow the link to reset your password:<br>
           <a href='http://questway.se/"""+message+"""'>http://questway.se"""+message+"""</a>
        </p>
      </body>
    </html>
    """

    msg.attach(MIMEText(body, 'html'))

    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login(fromaddr, "petterson")
    server.sendmail(fromaddr, toaddr, msg.as_string())
    server.quit()
