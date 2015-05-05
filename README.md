# AACC-ChatConnector
Custom JAVA connector for the Avaya Aura Contact Center (AACC) that includes webchat and integration with Avaya Messaging Service

## How it works
This connector is the public facing portion of AACC.  You can point a website to this connector (http://IP:8080/chat/chat.cfm) or proxy it behiend your existing website.  It currently includes a fully featured Web Chat and SMS module that works with Avaya Messaging Service.

## Requirements
 - Apache Tomcat 7 or 8.  http://tomcat.apache.org
 - Avaya AACC with Multimedia 6.4.2 or later
 - A database server (MySQL, MSSQL, Postgres, etc)
 - Avaya DevConnect Account (free).  http://devconnect.avaya.com
 
## Optional Components
 - Avaya Messaging Service phone number

## Installation Instructions
 - Download and install Apache Tomcat verion 7 or 8.  Core Binary distribtion is fine.
 - Downlaod and install a database server, if you don't have an existing one installed.  MySQL is fine (http://www.mysql.com)
 - Login to your Database server and create a new Database (Schema).  Optionally, create a new DB user that only has rights to this database (you must allow create/insert/read/update/delete/drop support).  Note the login/password and name of the database.
 - Create a new table in this database named "sms", with the colums "sms_id", "phoneNumber", and "AuthToken" (both Strings).  
 - Edit the computer's hostfile (C:\Windows\System32\Drivers\etc\hosts or /etc/hosts) to include an entry pointing avaya-aacc.telecom.msu.edu to your AACC's server IP address (this would be the virtual IP if you are in HA mode).
     `123.132.123.123      avaya-aacc     avaya-aacc.telecom.msu.edu`
 - Create a new directory in Tomcat's Webapps directory.  Call it CHAT. This should be {tomcat-install}\webapps\
 - Clone this repository into this new "chat" directory.
 - Start Tomcat by using the {tomcat-install}\bin\startup.bat  file.  You may need to set the JAVA_HOME enviroment variable first.
 - After a few seconds, you should see a bunch of log entries in the Tomcat window.  This means the application is deploying.
 - Launch a web browser to http://localhost:8080/chat/lucee/admin/server.cfm
 - Set a password and login to the Lucee administrative portal.  Under services, click on Datasource.
 - Create a new datasource named `sms`.  You will need to point this to the database that you created earlier.  You really only need to worry about the server hostname, username, password and database name.  It is fine to accept the rest of the defaults.  Save the datasource and make sure it verifys properly.
 - Go to http://localhost:8080/chat/chat.cfm     This will finish any installation items that still remain.
 
## Setting up the connector
 - All the basic configuration should be able to be accomplished via the database tables.
   - Table sms maps Avaya Messaging Service incoming phone numbers to AMS auth tokens.
   - Table smsinfo maps Phone numbers, app names, and AACC skill numbers.  
   - Table smssessions is a temporary table and is used to keep track of sessions in a loadbalanced/ha server setup. Should normally be empty.
   - Table smsmessages is a temporary table and is used to keep track of messages in a loadbalanced/ha server setup. Should normally be empty.
   - Table aaccskills is used by the chatting page and hold AACC skill numbers to prompts associations.
 - Customization can be done within the .cfm and .cfc documents in the chat directory
   - Most CFCs define the tables used in hibernate, with the exception of chatAvailable.cfc
   - chat.cfm is the main entry point of the app for web chat.  You can pass in the URL variable of skill to define the skill number that you want pre-populated (this skill must exist in the aaccskills db table first)
   - avayasms.cfm is the main entry point of the app for avaya messaging.  You would need to poin the Avaya messaging app to this page.  Make sure the phone number is defined in the smsinfo and sms db tables.
   
## AACC Upgrades or host changes
 - In webapps/chat/WEB-INF/lib there is a file called AACCServiceConnector.jar   This holds the WSDL and WebService service connector files.
 - If you do an upgrade to AACC and this application breaks, you will need to update this file.  It was created using Apache AXIS tool within Eclipse.   Unfortunately, when you use this tool it also bakes in the hostname to your server.
 - This file also includes the object structs.  (in the nortelLib/CIDataTypes.jar).  This file can be found within the sample AACC Chat application on the DevConnect site.  Generally, all you would need to do is find the file that corropsondes with the version of AACC you are using, drop it into this JAR file and you should be good to go.

 
 
   


 
 
