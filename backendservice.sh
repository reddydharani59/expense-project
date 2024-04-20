#!/bin/bash
[Unit]
Description = Backend Service

[Service]
User=expense
Environment=DB_HOST="db.daws-78s.site"
ExecStart=/bin/node /app/index.js
SyslogIdentifier=backend

[Install]
WantedBy=multi-user.target