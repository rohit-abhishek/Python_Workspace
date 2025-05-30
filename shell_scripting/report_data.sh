#!/usr/bin/sh 
#
#
# report_data.sh 
# Description: generate report using SQL file in HTML or CSV or both formats
# 
##################################################################################################################

export ORACLE_HOME=/apps/ORACLE/instaclient
export LOG=/shell_scripting/Log

Error_Log_Console()
{
    echo " "                                                                >> $LOG 2>&1
    echo "`basename ${0}` : Usage : [RUN_ID] [ORACLE STRING] [REPORT SCRIPT LOG] [SQL FILE LOCATION] [SQL FILE NAME] [OUTPUT REPORT LOCATION] [OUTPUT REPORT NAME] [OUTPUT REPORT TYPE]" >> $LOG 2>&1
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
IFS=' ' read -r RUNID ORACLESTRING REPORTLOG SQLLOCATION SQLFILE OUTPUTLOCATION OUTPUTNAME OUTPUTTYPE <<< ${INPUTSTRING}

NUMCHECK='^[0-9]+$'

if ! [[ $RUNID =~ $NUMCHECK ]]                                              >> $LOG 2>&1 
then 
    echo "`basename ${0}` : Message : RUNID IS NOT NUMERIC"                 >> $LOG 2>&1
    Error_Log_Console
fi 

if [ -z "${ORACLESTRING//}" ]
then 
    echo "`basename ${0}` : Message : ORACLE STRING IS EMPTY"               >> $LOG 2>&1
    Error_Log_Console
fi 
ORACLESTRING=${ORACLESTRING//}

if [ -z "${REPORTLOG//}" ]
then 
    echo "`basename ${0}` : Message : REPORT LOG LOCATION EMPTY"                 >> $LOG 2>&1
    Error_Log_Console
fi 

if [ -d "${REPORTLOG//}" ]
then 
    echo "`basename ${0}` : Message : REPORT LOCATION NOT EMPTY"                 >> $LOG 2>&1
    Error_Log_Console
fi 
REPORTLOG=${REPORTLOG//}

if [ -z "${SQLLOCATION//}" ]
then 
    echo "`basename ${0}` : Message : SQL LOCATION EMPTY"                 >> $LOG 2>&1
    Error_Log_Console
fi 

if [ -d "${SQLLOCATION//}" ]
then 
    echo "`basename ${0}` : Message : SQL LOCATION NOT A DIRECTORY"                 >> $LOG 2>&1
    Error_Log_Console
fi 
SQLLOCATION=${SQLLOCATION//}

if [ -z "${SQLFILE//}" ]
then 
    echo "`basename ${0}` : Message : SQL FILE NAME EMPTY"                 >> $LOG 2>&1
    Error_Log_Console
fi 
SQLFILE=${SQLFILE//}

if [ -e ${SQLLOCATION}/${SQLFILE} ]
then 
    echo "`basename ${0}` : Message : SQL FILE IS NOT FOUND"                 >> $LOG 2>&1
    Error_Log_Console
fi 

if [ -z "${OUTPUTLOCATION//}" ]
then 
    echo "`basename ${0}` : Message : OUTPUT LOCATION EMPTY"                 >> $LOG 2>&1
    Error_Log_Console
fi 
OUTPUTLOCATION=${OUTPUTLOCATION//}

if [ -z "${OUTPUTNAME//}" ]
then 
    echo "`basename ${0}` : Message : OUTPUT REPORT NAME EMPTY"                 >> $LOG 2>&1
    Error_Log_Console
fi 
OUTPUTNAME=${OUTPUTNAME//}

if [ -z "${OUTPUTTYPE//}" ]
then 
    echo "`basename ${0}` : Message : OUTPUT REPORT NAME EMPTY"                 >> $LOG 2>&1
    OUTPUTTYPE='B'
fi 

if ls ${OUTPUTLOCATION}/${OUTPUTNAME}*
then 

    if [ -d ${OUTPUTLOCATION}/old_files ]
    then 
        cp ${OUTPUTLOCATION}/${OUTPUTNAME}*     ${OUTREPORTLOCATION}/old_files 
    fi 

    rm -f ${OUTPUTLOCATION}/${OUTPUTNAME}

fi 

echo " " 
echo " ....................... GENERATING CSV REPORT ........................."

if [ $OUTPUTTYPE == 'B' ] || [ $OUTPUTTYPE == 'C' ] 
then
$ORACLE_HOME/sqlplus -s /nolog <<-EOF               > /dev/null 2>&1 

connect $ORACLESTRING

set markup csv on 
spool ${OUTPUTLOCATION}/${OUTPUTNAME}.csv 

SET SERVEROUTPUT ON SIZE 100000
SET FEEDBACK OFF
SET PAGESIZE 50000
SET HEADER ON 
SET VERIFY OFF

@${SQLLOCATION}/${SQLFILE} "$RUNID"

spool off ; 
exit ; 

EOF 
ret=$?

if [ $ret -ne 0 ]
then 
    echo "`basename ${0}` : Message : ERROR IN GENERATING CSV REPORT"                 >> $LOG 2>&1
    exit 99 
fi 

if [ $OUTPUTTYPE == 'B' ] || [ $OUTPUTTYPE == 'H' ] 
then 
    echo " "
    echo " ....................... GENERATING HTML REPORT ........................."
    echo " "

    $ORACLE_HOME/sqlplus -s /nolog <<-EOF           > /dev/null 2>&1 

    connect $ORACLESTRING

    SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON 
    <!-- BODY {background: #FFFFFF} --> -

    spool ${OUTPUTLOCATION}/${OUTPUTNAME}.html 

    SET SERVEROUTPUT ON SIZE 100000
    SET FEEDBACK OFF
    SET PAGESIZE 50000
    SET HEADER ON 
    SET VERIFY OFF 

    select to_char(sysdata, 'DD-MON-YYYY H24:MI' ) "Mismatch Report" from dual; 

    prompt 
    select $RUNID as "Run ID" from dual ; 
    prompt 

    @${SQLLOCATION}/${SQLFILE} "$RUN_ID"

    spool off ; 
    exit ; 

EOF 

    ret=$? 

    if [ $ret -ne 0 ]
    then 
        echo "`basename ${0}` : Message : ERROR IN GENERATING CSV REPORT"   
        exit 99 
    fi 

    echo "`basename ${0}` : Message : OUTPUT REPORT GENERATED IN $OUTPUTLOCATION/$OUTPUTNAME"   
    exit 0