#!/usr/bin/sh 
#
#
# load_table.sh 
# Description: load script for oracle table. call with list of parameters. 
# 
##################################################################################################################

export ORACLE_HOME=/apps/ORACLE/instaclient
export LOG=/shell_scripting/Log

Error_Log_Console()
{
    echo " "                                                                >> $LOG 2>&1
    echo "`basename ${0}` : Usage : [LOAD] [RUN_ID] [ORACLE_STRING] [LOAD LOG)] [INPUT LOCATION] [INPUT FILE] [CONTROL LOCATION] [CONTROL FILE] [LOAD NEEDED (Y/N)] [UPDATE RUN_ID (Y/N)] [HEADER PRESENT (Y/N)]" >> $LOG 2>&1
    echo " "                                                                >> $LOG 2>&1
    echo "                           OR                                 "   >> $LOG 2>&1 
    echo "`basename ${0}` : Usage : [COPY] [RUN_ID] [ORACLE_STRING] [LOAD LOG)] [INPUT LOCATION] [INPUT FILE] [OUTPUT LOCATION] [OUTPUT FILE] [RUN_ID PRESENT (Y/N)]" >> $LOG 2>&1
    echo " "
    exit 99
}

echo " "                                                                    >> $LOG 2>&1 

if [ $# -eq 0 ]                                                             >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : NO INPUT PARAMETERS PASSED"           >> $LOG 2>&1
    Error_Log_Console
fi 

INPUTSTRING=${*}                                                
IFS=' ' read -r OPTION RUNID ORACLESTRING LOADLOG INPUTLOCATION INPUTFILE VAR0 VAR1 VAR2 VAR3 VAR4 VAR5 <<< ${INPUTSTRING}

FLAGCHECK="^[LOAD|COPY]$"
NUMCHECK="^[0-9]+$"
INDCHECK="^[Y|N]$"


if [[ ${OPTION//} != "LOAD" ]] && [[ ${OPTION//} != "COPY" ]]               >> $LOG 2>&1 
then 
    echo "`basename ${0}` : Message : CONFIG FILE $CONFIG DOES NOT EXIST"   >> $LOG 2>&1
    Error_Log_Console
fi 

OPTION=${OPTION^^}

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

if [ -z "${LOADLOG//}" ]
then 
    echo "`basename ${0}` : Message : LOAD LOG LOCATION EMPTY"              >> $LOG 2>&1
    Error_Log_Console
fi 

if ! [ -d "${LOADLOG//}" ]
then 
    echo "`basename ${0}` : Message : LOAD LOCATION IS NOT A DIRECTORY"     >> $LOG 2>&1
    Error_Log_Console
fi 
LOADLOG=${LOADLOG//}

if [ -z "${INPUTLOCATION//}" ]
then 
    echo "`basename ${0}` : Message : INPUT LOCATION EMPTY"              >> $LOG 2>&1
    Error_Log_Console
fi 

if ! [ -d "${INPUTLOCATION//}" ]
then 
    echo "`basename ${0}` : Message : INPUT LOCATION IS NOT A DIRECTORY"     >> $LOG 2>&1
    Error_Log_Console
fi 
INPUTLOCATION=${INPUTLOCATION//}

if [ -z "${INPUTFILE//}" ]
then 
    echo "`basename ${0}` : Message : INPUT FILE CANNOT BE EMPTY"              >> $LOG 2>&1
    Error_Log_Console
fi 
INPUTFILE=${INPUTFILE//}

if [[ ${OPTION} = "LOAD" ]]                                                   >> $LOG 2>&1
then 

    if [ -z "${VAR0//}" ]                                                     >> $LOG 2>&1
    then 
        echo "`basename ${0}` : Message : CONTROL CARD LOCATION IS EMPTY"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    CONTROLLOCATION=${VAR0//}

    if ! [ -d ${CONTROLLOCATION} ]
    then 
        echo "`basename ${0}` : Message : CONTROL LOCATION $CONTROLLOCATION IS NOT DIRECTORY"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    
    if [ -z "${VAR1//}" ]                                                     >> $LOG 2>&1
    then 
        echo "`basename ${0}` : Message : CONTROL CARD FILE IS EMPTY"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    CONTROLNAME=${VAR1//}

    if ! [ -e ${CONTROLLOCATION}/${CONTROLNAME} ]
    then 
        echo "`basename ${0}` : Message : CONTROL CARD $CONTROLLOCATION/$CONTROLNAME IS NOT DIRECTORY"     >> $LOG 2>&1 
        Error_Log_Console
    fi 

    if ! [[ ${VAR2^^} =~ $INDCHECK ]]                                       >> $LOG 2>&1 
    then 
        echo "`basename ${0}` : Message : LOAD INDICATOR $VAR2 INVALID"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    LOADIND=${VAR2^^}
    LOADIND=${LOADIND//}

    if ! [[ ${VAR3^^} =~ $INDCHECK ]]                                       >> $LOG 2>&1 
    then 
        echo "`basename ${0}` : Message : UPDATE RUN ID INDICATOR $VAR3 INVALID"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    RUNIDUPDIND=${VAR3^^}
    RUNIDUPDIND=${RUNIDUPDIND//}

    if ! [[ ${VAR4^^} =~ $INDCHECK ]]                                       >> $LOG 2>&1 
    then 
        echo "`basename ${0}` : Message : HEADER INDICATOR $VAR4 INVALID"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    HEADERIND=${VAR4^^}
    HEADERIND=${HEADERIND//}

    if ! [[ ${VAR5^^} =~ $INDCHECK ]]                                       >> $LOG 2>&1 
    then 
        echo "`basename ${0}` : Message : LOAD RESUME/REPLACE INDICATOR $VAR5 INVALID"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    RESUMEOPT=${VAR5^^}
    RESUMEOPT=${RESUMEOPT//}

    TABLENAME="$(cut -d'.' -f1 <<< ${CONTROLNAME^^})"
    TEMPEX="$(cut -d'.' -f2 <<< ${INPUTFILE})"
    MERGEDFILE=$TABLENAME'.'${TEMPEX^^}

fi 

if [[ ${OPTION} = "COPY" ]]                                                   >> $LOG 2>&1
then 

    if [ -z "${VAR0//}" ]                                                     >> $LOG 2>&1
    then 
        echo "`basename ${0}` : Message : OUTPUT LOCATION IS EMPTY"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    OUTPUTLOCATION=${VAR0//}

    if ! [ -d ${OUTPUTLOCATION//} ]                                     >> $LOG 2>&1 
    then 
        echo "`basename ${0}` : Message : OUTPUT LOCATION IS NOT DIRECTORY"     >> $LOG 2>&1 
        Error_Log_Console
    fi 

    if [ -z "${VAR1//}" ]                                                     >> $LOG 2>&1
    then 
        echo "`basename ${0}` : Message : OUTPUT FILE IS EMPTY"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    OUTPUTFILENAME=${VAR1//}


    if [ -z "${VAR2//}" ]                                                     >> $LOG 2>&1
    then 
        echo "`basename ${0}` : Message : RUN ID PRESENT INDICATOR IS EMPTY"     >> $LOG 2>&1 
        Error_Log_Console
    fi 
    RUNIDPRESENT=${VAR2//}
    RUNIDPRESENT=${RUNIDPRESENT^^}
    
    if ! [[ ${RUNIDPRESENT} =~ $INDCHECK ]]                                 >> $LOG 2>&1 
    then 
        echo "`basename ${0}` : Message : RUN ID FLAG $RUNIDPRESENT INVALID"     >> $LOG 2>&1 
        Error_Log_Console
    fi 

    rm -f $OUTPUTLOCATION/$OUTPUTFILENAME                                   >> $LOG 2>&1 

    if [ $RUNIDPRESENT = "Y" ]                                              >> $LOG 2>&1
    then 
        TEMPFL="$(cut -d'*' -f1 <<< $INPUTFILE)"                            >> $LOG 2>&1
        TEMPEX="$(cut -d'.' -f1 <<< $INPUTFILE)"                            >> $LOG 2>&1
        INPUTFILE=$TEMPFL'_'$RUNID'*.'$TEMPEX
    fi 

    if ls $INPUTLOCATION/$INPUTFILE                                         >> $LOG 2>&1
    then 
        cat $INPUTLOCATION/$INPUTFILE       >   $OUTPUTLOCATION/$OUTPUTFILENAME 
    else
        echo " "                                                            >> $LOG 2>&1
        echo "`basename ${0}` : Message : INPUT FILE $INPUTLOCATION/$INPUTFILE NOT FOUND ... TERMINATING ... "     >> $LOG 2>&1 
        echo " "                                                            >> $LOG 2>&1
        exit 99 
    fi 

    if [ -d $INPUTLOCATION/old_files ]                                      >> $LOG 2>&1
    then    
        cp $INPUTLOCATION/$INPUTFILE        $INPUTLOCATION/old_files        >> $LOG 2>&1
    fi 

    rm -f $INPUTLOCATION/$INPUTFILE                                         >> $LOG 2>&1
    exit 

fi 

if [ $RUNIDUPDIND = "Y" ]                                                   >> $LOG 2>&1
then 
    TEMPFL="$(cut -d'*' -f1 <<< $INPUTFILE)"                                >> $LOG 2>&1
    TEMPEX="$(cut -d'.' -f2 <<< $INPUTFILE)"                                >> $LOG 2>&1
    INPUTFILE=$TEMPFL'_'$RUNID'*.'$TEMPEX
fi 

rm -f $INPUTLOCATION/$MERGEDFILE                                            >> $LOG 2>&1

if ls $INPUTLOCATION/$INPUTFILE                                             >> $LOG 2>&1
then 

    if [ -d $INPUTLOCATION/old_files ]                                      >> $LOG 2>&1
    then
        cp $INPUTLOCATION/$INPUTFILE            $INPUTLOCATION/old_files    >> $LOG 2>&1 
    fi 

    if [[ ${HEADERIND} = "Y" ]]                                             >> $LOG 2>&1 
    then 
        for filename in $INPUTLOCATION/$INPUTFILE
        do 
            sed -i '' -e '1d' $filename
        done
    fi 

    cat $INPUTLOCATION/$INPUTFILE           > $INPUTLOCATION/$MERGEDFILE 
    rm -f $INPUTLOCATION/$INPUTFILE 

else 
    
    echo " " 
    echo "`basename ${0}` : Message : INPUT FILE $INPUTLOCATION/$INPUTFILE NOT FOUND" >> $LOG 2>&1
    echo " "
    exit 99 
fi 

if [[ ${RUNIDUPDIND} = "Y" ]]
then

    if [ ! -d $CONTROLLOCATION/temp ]                
    then
        mkdir $CONTROLLOCATION/temp 
    else 
        rm $CONTROLLOCATION/temp/$CONTROLNAME
    fi 

    sed "s/RUN_ID_VAL/$RUNID/g" $CONTROLLOCATION/$CONTROLNAME > $CONTROLLOCATION/temp/$CONTROLNAME
    control=$CONTROLLOCATION/temp/$CONTROLNAME

else

    control=$CONTROLLOCATION/$CONTROLNAME 
fi 


bad=$LOADLOG/$TABLENAME.bad
if [ -e $bad ]
then
    rm $bad 
fi 

loaderlog=$LOADLOG/$TABLENAME.log
if [ -e $loaderlog ]
then 
    rm $loaderlog
fi 

data=$INPUTLOCATION/$MERGEDFILE

if [ "${RUNUPDIND}" = "Y" ]
then 

    count=`$ORACLE_HOME\sqlplus -s $ORACLESTRING <<-EOF
    set heading off
    set feedback off
    select count(*) from $TABLENAME where run_id = $RUNID;
    exit 
    EOF` 

    count=$(echo "${count}" | sed -e 's/^ *//g;s/ *$//g')

    ret=$?

    if [ $ret -ne 0 ]
    then 
        echo "`basename ${0}` : Message : INVALID RETURN CODE FROM ORACLE DURING SELECT RUN ID OPERATION ... TERMINATING ... "   >> $LOG 2>&1  
        exit 99 
    fi 

    echo " "                                                            >> $LOG 2>&1        
    echo "`basename ${0}` : Message : TABLE NAME $TABLENAME WITH GIVE RUN ID $RUNID. CURRENT NUMER OF ROWS $count "   >> $LOG 2>&1 

    if [ "${RESUMEOPT}" = "N" ] 
    then 
        echo "`basename ${0}` : Message : INVALID RETURN CODE FROM ORACLE DURING SELECT RUN ID OPERATION ... TERMINATING ... "   >> $LOG 2>&1  
        echo " " 
        $ORACLE_HOME/sqlplus -s /nolog              <<-EOF                           >> $LOG 2>&1 
        connect $ORACLESTRING 
        delete $TABLENAME where RUN_ID = $RUNID ; 
        exit
EOF

        ret=$?
        if [ $ret -ne 0 ]
        then 
            echo "`basename ${0}` : Message : INVALID RETURN FROM ORACLE DURING DELETE ... TERMINATING ... "   >> $LOG 2>&1  
            exit 99 
        fi 
    fi 
fi 

echo "`basename ${0}` : Message : PREPAREING TO LOAD TABLE $TABLENAME WITH RUN_ID $RUNID"   >> $LOG 2>&1  
echo " "

$ORACLE_HOME/sqlldr USERID=$ORACLESTRING SILENT=ALL DATA=$data CONTROL=$control LOG=$loaderlog BAD=$bad errors=9999999   >> $LOG 2>&1

ret=$?

if [ $ret -ne 0 ]
then
    echo "`basename ${0}` : Message : INVALID RETURN FROM ORACLE DURING LOAD $ret ... SCRIPT WILL CONTINUE .... "   >> $LOG 2>&1 
fi 

if [ "${RUNIDUPDIND}" = "Y" ]
then 
    count=`ORACLE_HOME/sqplus -s $ORACLESTRING     <<-EOF
    set heading off
    set feedback off
    select count(*) from $TABLENAME where run_id=$RUNID ; 
    exit 
    EOF` 

    count=$(echo "${count}" | sed -e 's/^ *//g;s/ *$//g')
    echo "`basename ${0}` : Message : POST LOAD ... TABLE NAME $TABLENAME AND RUN_ID $RUNID. NUMBER OF ROWS $count "   >> $LOG 2>&1
    echo " " 

else 
    
    echo " "
    echo "`basename ${0}` : Message : PLEASE CHECK $loaderlog AND $bad TO CONFIRM LOAD OPERATION COMPLETED SUCCESSFULLY "   >> $LOG 2>&1  
    echo " "
fi 

exit 0
