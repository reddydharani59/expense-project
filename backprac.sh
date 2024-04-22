#!/bin/bash

USER=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=$SCRIPTNAME.$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
D="\e[90m"
if [ $USER -ne 0 ]
then 
   echo -e " $R Get super user access"
   exit 1
else 
    echo -e $Y" you are super user proceed"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 .....$R Failed"
        exit 1
    else 
        echo -e "$2 .....$G success"
    fi
}

dnf module disable nodejs:18 -y &>>$LOGFILE
VALIDATE $? "disabling nodejs:18"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabling nodejs:20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then  
    useradd expense
else
    echo "user already exists"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Making directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading the code "

cd /app

rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extraced backend code"

cd /app

npm install &>>$LOGFILE
VALIDATE $? "Installing npm"

cp /home/ec2-user/expense-project/backendservice.sh /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon reloading"

systemctl start backend.service &>>$LOGFILE
VALIDATE $? "starting backend service"

systemctl enable backend.service &>>$LOGFILE
VALIDATE $? "enabling backend service"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql"

mysql -h db.daws-78s.site -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend"














