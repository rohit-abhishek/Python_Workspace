#!/usr/bin/sh 
#
#
# email_report.sh 
# Description: email generated report
# 
##################################################################################################################

export LOG=/shell_scripting/Log

Error_Log_Console()
{
    echo " "                                                                >> $LOG 2>&1
    echo "`basename ${0}` : Usage : [RUN_ID]|[PROCESS OPTION]|[EMAIL DL COMMA SEPARATED]|[REPORT LOCATION]|[REPORT NAME W/O EXTENSION]" >> $LOG 2>&1
    echo " "                                                                >> $LOG 2>&1
    exit 99
}

echo " " 

if [ $# -eq 0 ]                                                             >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : NO INPUT PARAMETERS PASSED"           >> $LOG 2>&1
    Error_Log_Console
fi 

INPUTSTRING=${*}                                                
IFS='|' read -r RUNID PROCOPTION SERVERNAME EMAILDL REPORTLOCATION REPORT1 REPORT2 REPORT3 REPORT4 <<< ${INPUTSTRING}

NUMCHECK='^[0-9]+$'

if ! [[ $RUNID =~ $NUMCHECK ]]                                              >> $LOG 2>&1 
then 
    echo "`basename ${0}` : Message : RUNID IS NOT NUMERIC"                 >> $LOG 2>&1
    Error_Log_Console
fi 

if [ -z "${SERVERNAME//}" ]
then 
    echo "`basename ${0}` : Message : NO SERVER DETAILS"                 >> $LOG 2>&1
    Error_Log_Console
fi 

if [ -z "${EMAILDL//}" ]
then 
    echo "`basename ${0}` : Message : NO EMAIL DL"                 >> $LOG 2>&1
    Error_Log_Console
fi 
EMAILDL=${EMAILDL//}

if [ -z "${PROCOPTION//}" ]
then 
    echo "`basename ${0}` : Message : NO REPORT TYPE"                 >> $LOG 2>&1
    Error_Log_Console
fi 

if [ -z "${REPORTLOCATION//}" ]
then 
    echo "`basename ${0}` : Message : NO REPORT LOCATION "                 >> $LOG 2>&1
    Error_Log_Console
fi 
REPORTLOCATION=${REPORTLOCATION//}

if [ -z "${REPORT1//}" ] && [ -z "${REPORT2//}" ] && [ -z "${REPORT3//}" ] && [ -z "${REPORT4//}" ] 
then 
    echo "`basename ${0}` : Message : ALL REPORTS CANNOT BE EMPTY"                 >> $LOG 2>&1
    Error_Log_Console
fi 

REPORT1=${REPORT1//}
REPORT2=${REPORT2//}
REPORT3=${REPORT3//}
REPORT4=${REPORT4//}

count=0 

revpath=`expr ${REPORTLOCATION} | rev` 
IFS='/' read -r revtype revpath <<< $revpath 
type=`expr ${revtype^^} | rev` 

echo $type 

rm -f $REPORTLOCATION/zipped/logfiles.zip 
rm -f $REPORTLOCATION/zipped/reportfiles.zip

export logzip=${REPORTLOCATION}/zipped/logfiles.zip 
export reportzip=${REPORTLOCATION}/zipped/reportfiles.zip 

if ! [ -z "${REPORT1//}" ] && ls $REPORTLOCATION/$REPORT1.* 
then 
    for filename in $REPORTLOCATION/$REPORT1.* 
    do 
        if [ ${type} = "LOGS" ]
        then 
            zip -r -j -e --password cvt $logzip $filename 
        else 
            zip -r -j -e --password cvt $reportzip $filename 
        fi 
    done 
fi 

if ! [ -z "${REPORT1//}" ] && ls $REPORTLOCATION/${REPORT1^^}.*
then 
    for filename in $REPORTLOCATION/${REPORT^^}.* 
    do 
        if [ ${type} = "LOGS" ]
        then 
            zip -r -j -e --password cvt $logzip $filename 
        else 
            zip -r -j -e --password cvt $reportzip $filename 
        fi 
    done 
fi 

if ! [ -z "${REPORT2//}" ] && ls $REPORTLOCATION/$REPORT2.* 
then 
    for filename in $REPORTLOCATION/$REPORT2.* 
    do 
        if [ ${type} = "LOGS" ]
        then 
            zip -r -j -e --password cvt $logzip $filename 
        else 
            zip -r -j -e --password cvt $reportzip $filename 
        fi 
    done 
fi 

if ! [ -z "${REPORT2//}" ] && ls $REPORTLOCATION/${REPORT2^^}.*
then 
    for filename in $REPORTLOCATION/${REPORT^^}.* 
    do 
        if [ ${type} = "LOGS" ]
        then 
            zip -r -j -e --password cvt $logzip $filename 
        else 
            zip -r -j -e --password cvt $reportzip $filename 
        fi 
    done 
fi 

if ! [ -z "${REPORT3//}" ] && ls $REPORTLOCATION/$REPORT3.* 
then 
    for filename in $REPORTLOCATION/$REPORT1.* 
    do 
        if [ ${type} = "LOGS" ]
        then 
            zip -r -j -e --password cvt $logzip $filename 
        else 
            zip -r -j -e --password cvt $reportzip $filename 
        fi 
    done 
fi 

if ! [ -z "${REPORT3//}" ] && ls $REPORTLOCATION/${REPORT3^^}.*
then 
    for filename in $REPORTLOCATION/${REPORT^^}.* 
    do 
        if [ ${type} = "LOGS" ]
        then 
            zip -r -j -e --password cvt $logzip $filename 
        else 
            zip -r -j -e --password cvt $reportzip $filename 
        fi 
    done 
fi 

if ! [ -z "${REPORT4//}" ] && ls $REPORTLOCATION/$REPORT4.* 
then 
    for filename in $REPORTLOCATION/$REPORT1.* 
    do 
        if [ ${type} = "LOGS" ]
        then 
            zip -r -j -e --password cvt $logzip $filename 
        else 
            zip -r -j -e --password cvt $reportzip $filename 
        fi 
    done 
fi 

if ! [ -z "${REPORT4//}" ] && ls $REPORTLOCATION/${REPORT4^^}.*
then 
    for filename in $REPORTLOCATION/${REPORT^^}.* 
    do 
        if [ ${type} = "LOGS" ]
        then 
            zip -r -j -e --password cvt $logzip $filename 
        else 
            zip -r -j -e --password cvt $reportzip $filename 
        fi 
    done 
fi 

if [ ${type} = 'LOGS' ] 
then 
    ATTACHMENT[0]="  -a $logzip"
else
    ATTACHMENT[0]="  -a $reportzip"
fi 

echo -e "\nHere is the $PROCOPTION Report Run ID $RUNID \n\n\n from $SERVERNAME" | mailx -s "$PROCOPTION Report attached for Run ID: $RUNID"   -r "automtion_report@$SERVERNAME"  ${ATTACHMENT[*]} $EMAILDL  >> $LOG 2>&1
echo " "
