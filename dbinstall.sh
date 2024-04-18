#!/bin/bash

USER=$(id -u)
R="\e[31m"
Y="\e[32m"
B="\e[36m"
SCRIPTNAME=$(echo $0 | CUT -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
if [ $USER -ne 0 ]
then 
  echo "you are not super user"
  exit 1
else
  echo "you are super user, $B you can proceed"
fi

VALIDATE()
{
    if [ $1 -ne 0]
    then 
      echo "$2 ...$Rfailure"
      exit 1
    else
      echo "$2 ... $G success"
    fi 
      
}


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Intialization of mysql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql-server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysql-server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting up root password"