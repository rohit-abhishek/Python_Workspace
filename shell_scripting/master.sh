#!/usr/bin/sh
#
#
# master.sh 
# Description: master script invoked from CLI with following parameters 
#         $ ./master.sh run_number process_type load_indicator report_indicator email_indicator 
#         $ ./master.sh 999999 PROCESS_ID_1 Y Y Y 
#    Based on parameters passed and values set in script.config; operations will be performed 
# 
# 
##################################################################################################################

export LOG=/shell_scripting/Log
export CONFIG=/shell_scripting/script.config

echo " "                                                                    > $LOG

Error_Log_Console()
{
    echo " "                                                                >> $LOG 2>&1
    echo "`basename ${0}` : Usage : [RUN_ID] [PROCESS_NAME] [LOAD FLAG (Y/N)] [REPORT FLAG (Y/N)] [EMAIL FLAG (Y/N)]" >> $LOG 2>&1
    echo " "                                                                >> $LOG 2>&1
    exit 99
}

if [ $# -eq 0 ]                                                             >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : NO INPUT PARAMETERS PASSED"           >> $LOG 2>&1
    Error_Log_Console
fi 

INPUTSTRING=${*}                                                
IFS=' ' read -r RUNID PROCOPTION LOADERIND REPORTIND EMAILIND <<< ${INPUTSTRING^^}

if ! [ -e $CONFIG ]                                                     >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : CONFIG FILE $CONFIG DOES NOT EXIST"   >> $LOG 2>&1
    Error_Log_Console
fi 

NUMCHECK='^[0-9]+$'
if ! [[ $RUNID =~ $NUMCHECK ]]                                                     >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : RUN_ID ($RUNID) NOT NUMERIC"          >> $LOG 2>&1
    Error_Log_Console
fi

if [ -z "${PROCOPTION//}" ]                                                     >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : INVALID PROCESSING OPTION"   >> $LOG 2>&1
    Error_Log_Console
fi 

INDCHECK='^[Y|N]$'
if ! [[ $LOADERIND =~ $INDCHECK ]]                                                     >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : INVALID LOAD INDICATOR ($LOADERIND)"          >> $LOG 2>&1
    Error_Log_Console
fi

if ! [[ $REPORTIND =~ $INDCHECK ]]                                                     >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : INVALID REPORT INDICATOR ($REPORTIND)"          >> $LOG 2>&1
    Error_Log_Console
fi

if ! [[ $EMAILIND =~ $INDCHECK ]]                                                     >> $LOG 2>&1
then 
    echo "`basename ${0}` : Message : INVALID EMAIL INDICATOR ($EMAILIND)"          >> $LOG 2>&1
    Error_Log_Console
fi

# print on console 
echo " "
echo "------------------------------- PARAMETERS RECIEVED BY MASTER SCRIPT -----------------------------"
echo " "
echo "RUN ID                                        : "$RUNID
echo "PROCESSING OPTION                             : "$PROCOPTION
echo "LOADER FLAG                                   : "$LOADERIND
echo "REPORT FLAG                                   : "$REPORTIND
echo "EMAIL FLAG                                    : "$EMAILIND
echo " "
echo "--------------------------------------------------------------------------------------------------"
echo " "

echo "RUN ID                                        : "$RUNID                       >> $LOG 2>&1
echo "PROCESSING OPTION                             : "$PROCOPTION                  >> $LOG 2>&1
echo "LOADER FLAG                                   : "$LOADERIND                   >> $LOG 2>&1
echo "REPORT FLAG                                   : "$REPORTIND                   >> $LOG 2>&1
echo "EMAIL FLAG                                    : "$EMAILIND                    >> $LOG 2>&1

OPTIONFOUND="N"

while IFS='|' read -r TYPE OPTION VAR0 VAR1 VAR2 VAR3 VAR4 VAR5 VAR6 VAR7 VAR8 VAR9 
do 
    if [[ "${TYPE}" =~ "#" ]]
    then 
        continue 
    fi 

    if [[ "${TYPE//}" == "G "]] && [[ "${OPTION//}" == "EMAIL_DL" ]]       >> $LOG 2>&1
    then 
        dlcount=${var0:2:2}
        DL[#dlcount]=${VAR1}
    fi

    if [ "${OPTION//}" == "${PROCOPTION//}" ] && [ "${LOADERIND//}" == "Y" ]   >> $LOG 2>&1
    then 
        OPTIONFOUND="Y"

        case "${TYPE//}" in
            "O ")
                ORACLESTRING=$VAR3'/'$VAR4'@'$VAR0':'$VAR1'/'$VAR2
                ;;
            "L ")
                LOADSCRIPT=${VAR0}
                LOADSCRIPTLOG=${VAR1}
                CALLSTRING=" "
                ;;
            "LI")
                CALLSTRING="$LOADSCRIPT LOAD $RUNID $ORACLESTRING $LOADSCRIPTLOG $VAR1 $VAR2 $VAR3 $VAR4 $VAR5 $VAR6 $VAR7 $VAR8"
                echo $CALLSTRING            >> $LOG 2>&1
                sh ./"$LOADSCRIPT" "LOAD" "$RUNID" "$ORACLESTRING" "$LOADSCRIPTLOG" "$VAR1" "$VAR2" "$VAR3" "$VAR4" "$VAR5" "$VAR6" "$VAR7" "$VAR8"
                ;;
            "LM")
                CALLSTRING="$LOADSCRIPT COPY $RUNID $LOADSCRIPTLOG $VAR1 $VAR2 $VAR3 $VAR4 $VAR5"
                echo $CALLSTRING            >> $LOG 2>&1
                sh ./"$LOADSCRIPT" "LOAD" "$RUNID" "$ORACLESTRING" "$LOADSCRIPTLOG" "$VAR1" "$VAR2" "$VAR3" "$VAR4" "$VAR5"
                ;;
            "LX")
                continue
                ;;
        esac 

        loadret=$?

        if [ ${loadret} -eq 99 ]                    >> $LOG 2>&1
        then 
            echo " "
            echo "`basename ${0}` : Message : INVALID RETIRN FROM $LOADSCRIPT ... TERMINATING ... " >> $LOG 2>&1 
            exit $loadret 
        fi 

    fi 


    if [ "${OPTION//}" == "${PROCOTION//}" ]  && [  "${REPORTIND//}" == "Y" ]
    then
        OPTIONFOUND="Y"
        case "${TYPE//}" in 
                "O ")
                    ORACLESTRING=$VAR3' /' $VAR4'@'$VAR0': '$VAR1' / '$VAR2
                    ;;
                "R ")
                    REPORTCARDSCRIPT=${VAR0}
                    REPORTCARDSCRIPTLOG=${VAR1}
                    CLASSSTRING=" "
                    ;;

                "RE")
                    SQLLOCATION=${VAR1}
                    SQLNAME=${VAR2}
                    OUTREPORTLOCATION=${VAR3}
                    OUTREPORTNAME=${VAR4}
                    OUTREPRTTIME=${VAR5}
                    CALLSTRING="$REPORTSCRIPT $RUNID ORACLECONNECTIONSTRING $REPORTSCRIPTLOG $SQLLOCATION $SQLNAME $OUTREPORTLOCATION $OUTREPORTNAME $OUTREPORTTYPE"
            
                    echo "REPOPRT SCRIPT CALL HAS STARTED "                               >> $LOG 2>&1
                    echo $CALLSTRING                                                      >> $LOG 2>&1
                    echo "  "                                                             >> $LOG 2>&1

                    sh ./"$REPORTSCRIPT"  "RUNID"  "$ORACLESTRING" "$REPORTSCRIPT" "$SQLLOCATION" "$SQLNAME" "$OUTREPORTLOCATION" "$OUTREPORTNAME" "$OUTREPORTTYPE"
                    ;;
                    "RX")
                        continue
                        ;;
        esac

        reportret=$?


        if [ ${reportret} -eq 99]
        then
              
            echo " "                                                          >> $LOG 2>&1
            echo "`basename ${0}` : Message : INVALID RETURNE FROM $REPORTSCRIPT ......TERMINATING ........" >> $LOG 2>&1
            exit $reportret
            
        fi

    fi

    if [ "${OPTION//}" == "${PROCOPTION//}" ] &&  [ "${EMAILIND//}" == "Y"]
    then 
        OPTIONFOUND="Y"
        case  "${TYPE//}" in 
                "O ")
                    ORACLESERVER=$VAR0
                    ;;

                "E ")
                    EMAILSCRIPT=${VAR0}
                    EMAILDL=${DL[${VAR2:2:2}]}
                    CALLSTRING=" "
                    ;;

                "EI")
                    CALLSTRING="$EMAILSCRIPT $RUNID $PROCOPTION $ORACLESERVER $EMAILDL $VAR1 $VAR2 $VAR3 $VAR4 $VAR5"
                    echo "EMAIL SCRIPT HAS STARTED"                     >> $LOG 2>&1
                    echo " "                                            >> $LOG 2>&1

                    sh ./"$EMAILSCRIPT" "$RUNID""|""$PROCOPTION""|""$ORACLESERVER""|""$EMAILDL""|""$VAR1""|""$VAR2""|""$VAR3""|""$VAR4""|""$VAR5"
                    ;;
                    
                "EX")
                    continue
                    ;;
        esac 

        emailret=$?

        if [ ${emailret} -eq 99 ]
        then 
            echo " "                                                >> $LOG 2>&1
            echo "`basename ${0}` : Message : INVALID RETURN FROM EMAIL SCRIPT $EMAILSCRIPT .... TERMINATING ..... " >> $LOG 2>&1
            exit $emailret 
        fi
        
    fi 

done < "$CONFIG"

if [ $OPTIONFOUND = "N" ]
then 
    echo "`basename ${0}` : Message : INVALID SCRIPT OPTION $PROCOPTION PASSED"  >> $LOG 2>&1 
    Error_Log_Console
fi 

exit