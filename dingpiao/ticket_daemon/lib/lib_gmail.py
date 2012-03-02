#!/usr/bin/python2.6
# -*- coding: utf-8 -*-
from email.mime.text import MIMEText
import smtplib 

class Gamil (object ):
    def __init__ (self ,account,password):
        """ 
        Gamil("wcmilan","xxxx") 
        """ 
        self.account = account
        self.password = password

    def send (self ,to,title,content):
        """ 
        send('wcmilan@gmail.com,wcmilan@gmail.com") 
        """ 
        server = smtplib.SMTP('smtp.gmail.com' )
        server.docmd("EHLO server" )
        server.starttls()
        server.login(self .account,self .password)

        msg = MIMEText(content)
        msg['Content-Type' ]='text/plain; charset="utf-8"' 
        msg['Subject' ] = title
        msg['From' ] = self .account
        msg['To' ] = to
        server.sendmail(self .account, to ,msg.as_string())
        server.close()

if __name__=="__main__" :
    gmail=Gamil('wuchang@umeng.com', 'password' )
    gmail.send("wcmilan@gmail.com" ,"hello, test" ,"shkfskdfk" )
