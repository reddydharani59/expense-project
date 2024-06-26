#!/bin/bash
USER=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d ".' -f1)
LOGFILE=/tmp/$SCRIPTNAME.$TIMESTAMP.log
echo "enter mysql-password"
read -s mysql_root_password
R="\e[31m"
G="\e[32m"
Y="\e[33m"
if [ $USER -ne 0 ]
then 
echo -e "$R Get super user access"
   exit 1
else 
echo -e "$Y you are super user proceed"
fi
VALIDATE(){

    if [ $1 -eq 0 ]
    then
      echo -e "$2 .....is $Y success"
    else 
      echo -e "$2 ....$R is failure"
      exit 1
    fi

}
dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing Mysql-Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql-server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql-server"

mysql-h db.daws-78s.site -uroot -p${mysql-passwd} &>>$LOGFILE
# if [ $? ne 0 ]
#then 
 #    mysql_secure_installation --set-root-pass ${mysql-passwd} &>>$LOGFILE
  #   VALIDATE $? "Setting up password"
 #else
  #   echo "Already you set mysql password read to go"
 # fi
 if [ $? -ne 0 ]
  then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
 else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
 fi
