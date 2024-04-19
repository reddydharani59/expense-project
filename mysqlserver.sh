#!/bin/bash
USER=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $? | cut -d ".' -f1)
LOGFILE=/tmp/$SCRIPTNAME.$TIMESTAMP.log
echo "enter mysql-password"
read -s mysql-passwd
R="/e[31m"
y="/e[32m"
B="/e[33m"
if [ $USER ne 0]
then 
echo -e "$R Get super user access"
else 
echo -e "$Y you are super user proceed"
VALIDATE()
{
    if [ $1 eq 0 ]
    then
      echo -e "$2 .....is $B success"
    else 
      echo -e "$2 ....$R is failure"
    fi

}
dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing Mysql-Server"
systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql-server"
systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql-server "

mysql-h db.daws-78s.site -uroot -p${mysql-passwd} &>>$LOGFILE
if [ $? ne 0 ]
then 
     mysql_secure_installation --set-root-pass ${mysql-passwd} &>>$LOGFILE
 else
     echo -e "Already you set mysql password $Y read to go"
 fi
