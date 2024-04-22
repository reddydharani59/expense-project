#!/bin/bash
USER=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SRIPTNAME=$(echo $0 |cut -d "." -f1)
LOGFILE=$TIMESTAMP.$SCRIPTNAME.log
R="\e[31m"
Y="\e[32m"
B="\e[34m"
D="\e[90m"

if [ $USER -ne 0 ]
then
    echo -e "$y get super user access"
    exit 1
else 
    echo -e "$B you are super user proceed"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then    
        echo -e "$R failed"
        exit 1
    else
      echo -e "$2.....$B success"
    fi
}

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "starting nginx"



curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing existing content"


 cd /usr/share/nginx/html/
 unzip /tmp/frontend.zip &>>$LOGFILE
 VALIDATE $? "Extracting code frontend code"

 cp /home/ec2-user/expense-project/nginxcong.sh /etc/nginx/default.d/expense.conf &>>$LOGFILE
 VALIDATE $? "Copying code"

 systemctl restart nginx &>>$LOGFILE
 VALIDATE $? " Restarting nginx"



