#!/bin/bash

S3_BUCKET="terraform-root-file-bucket-uat"
S3_PATH=".platform/hooks/predeploy/replace_tomcat.sh"
TOMCAT_CONF="/usr/share/tomcat/conf"

aws s3 cp s3://$S3_BUCKET/$S3_PATH/server.xml $TOMCAT_CONF/server.xml
aws s3 cp s3://$S3_BUCKET/$S3_PATH/context.xml $TOMCAT_CONF/context.xml

chown tomcat:tomcat $TOMCAT_CONF/server.xml
chown tomcat:tomcat $TOMCAT_CONF/context.xml
chmod 640 $TOMCAT_CONF/server.xml
chmod 640 $TOMCAT_CONF/context.xml