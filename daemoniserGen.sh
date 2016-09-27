# !/bin/ksh 

displayUsage()
{
         echo -e "\t+------------------------------------------------------------------------------------------------------------------------- +"
         echo -e "\t|                                                                                                                          |"
         echo -e "\t| USAGE  :: DaemoniserGen -p <ProcName> -a <START/STOP> -s <SLEEP_INTERVAL>  -c <CONFIG_FILE>   -n <NUM_OF_INSTANCES>      |"
         echo -e "\t|           where                                                                                                          |"
         echo -e "\t|                ProcName        -  the process to be daemonised . It's an executable which will be                        |"
         echo -e "\t|                                   be run in loop by DaemoiserGen with specified parameters                               |"
         echo -e "\t|                                   If <ProcName> is not placed in a directory from PATH , give full path                  |"
         echo -e "\t|                START/STOP      -  parameter indicating if the script should start of stop the process                    |"
         echo -e "\t|                                   being daemonised by DaemoinserGen                                                      |"
         echo -e "\t|                SLEEP INTERVAL  -  if any sleep interval to be implemented while running <ProcName> in                    |"
         echo -e "\t|                [Optional]         in loop.                                                                               |"
         echo -e "\t|                                   It might be useful if the <procName> doesnt provide any relevant                       |"
         echo -e "\t|                                   looping logic                                                                          |"
         echo -e "\t|                CONFIG_FILE      - If there are specific parameters that <procName> requires , that                       |"
         echo -e "\t|                [Optional]         can be set in <CONFIG_FILE> . DaemoiserGen will source it to shell                     |"
         echo -e "\t|                                   environment and make it available for <ProcName>                                       |"
         echo -e "\t|                                   It can also be used to overwrite common variables for DaemoniserGen                    |"
         echo -e "\t|                                   such as WORK_DIR , LOG_DIR etc .Do this only if you know                               |"
         echo -e "\t|                                   DaemoniserGen thorougly                                                                |"
         echo -e "\t|                NUM_OF_INSTANCES - WHEN multiple parallel instances of the daemon are to be run                           |"
         echo -e "\t|                                   Please use this only when <ProcName> is intelligent enough to handle parallelism       |"
         echo -e "\t|                                   Also advised to use config file when you use this option to have variables required    |"
         echo -e "\t|                                   to support parrallel instances                                                         |"
         echo -e "\t|                                                                                                                          |"
         echo -e "\t|                                                                                                                          |"
         echo -e "\t|                                                                                                                          |"
         echo -e "\t+--------------------------------------------------------------------------------------------------------------------------+"
         echo -e ""
         echo -e "\t+--------------------------------------------------------------------------------------------------------------------+"
         echo -e "\t|Note: If you have copied this script , please change initialize section to set directories for your environment     |"
         echo -e "\t+--------------------------------------------------------------------------------------------------------------------+"

}


initialize()
{
     echo -e "\n \033[36m .....Intialising ! \033[0m \n"
     if [ $# -lt 4 ]      
     then      
             displayUsage
             exit 0
     fi
    
     #(1) Read Command Line Parameters       
     configFile=""
     numOfInstances=1
     while [ "$1" != "" ]; do
         case $1 in
             -p | --process )        shift
                                     procName=$1
                                     ;;
             -a | --action )         shift
                                     action=$1
                                     ;;
             -s | --sleep )          shift
                                     sleepInterval=$1
                                     ;;
             -c | --configuration )  shift
                                     configFile=$1
                                     ;;
             -n | --instances )      shift
                                     numOfInstances=$1
                                     if [ "$numOfInstances" == "" ]
                                     then
                                          numOfInstances=1 
                                     fi
                                     ;;                                                                      
             -h | --help )           displayUsage
                                     exit 0
                                     ;;
             * )                     displayUsage
                                     exit 0
         esac
         shift
     done
      
      

     #(2) Set a work directory
     WORK_DIR="$( pwd )/work"
     if [ ! -d ${WORK_DIR} ]
     then
         mkdir $WORK_DIR
         if [ $? -ne 0 ]
         then
              WORK_DIR=$( pwd )
         fi
     fi

     #(3) All the directories where tuxedo logs are located
     LOG_DIR="${WORK_DIR}/log"
     if [ ! -d ${LOG_DIR} ]
     then
         mkdir $LOG_DIR
         if [ $? -ne 0 ]
         then
              LOG_DIR=$( pwd )
         fi
     fi  
      
    #(4) If Config file is supplied source it .
        if [[ "${configFile}" != "" &&  -s ${configFile} ]]
        then
           . ${configFile}     
        fi
     
        #(5) Set Flag Names for START/STOP
        START_FLAG=${WORK_DIR}/${procName}.started
        STOP_FLAG=${WORK_DIR}/${procName}.stopIt
}

daemonise()
{
    touch ${START_FLAG}.${1}
    ( daemonMode ${procName} ${START_FLAG}.${1} ${sleepInterval}) &
    echo -e "\n \033[36m ..... ${procName} Initiated with pid $!  ! \033[0m \n"     

}


daemonMode()
{
        processNameOnly=$( basename ${1} )
        InstanceNum=$( basename $2 | awk -F"." '{print $NF}' )
        logFile=${LOG_DIR}/${processNameOnly}.$$.${InstanceNum}.out.log
        errorFile=${LOG_DIR}/${processNameOnly}.$$.${InstanceNum}.error.log
        while [ -e ${2} ]
        do
              ${1} 1>>${logFile} 2>>${errorFile}
              echo -e "\n \033[36m ..... Sleeping for ${3} seconds ! \033[0m \n" >>${logFile} 
              sleep ${3}s       
        done
               
}

startIt()
{
    echo -e "\n \033[36m .....Attempting Start for daemon ${procName} ! \033[0m \n"

    if [ -e ${STOP_FLAG} ]
    then
        rm -f ${STOP_FLAG}
    fi
     
        if [ $numOfInstances -eq 1 ]
        then
            if [ -e ${START_FLAG} ]
            then
                echo " .................Seems Daemon is already Started (flag exists). Checking for daemon ! "
                for pid in $( ps -efl | grep -v grep | grep ${procName} | awk -F" " '{print $4}' )
                do
                    echo "${procName} is running with pid ${pid}"
                done
                else
                    daemonise 0
            fi
     else
            bootedNumOfInstances=0
            while [ ${bootedNumOfInstances} -lt ${numOfInstances} ]
            do
               daemonise ${bootedNumOfInstances}
               bootedNumOfInstances=$( expr $bootedNumOfInstances + 1 )
            done
        fi


}


stopIt()
{
    echo -e "\n \033[36m .....Setting flags to stop ${procName} ! \033[0m \n"
    touch ${STOP_FLAG}
    rm -f ${START_FLAG}.[0-9]*
    echo -e "\n \033[36m ..... Signalled daemon to stop \033[0m \n" 
   
}

main()
{
    initialize $*

    if [ "${action}" == "START" ]
    then
        startIt
    else
       if [ "${action}" == "STOP" ]
       then
            stopIt
       else
            echo -e "\n \033[36m ..... Invalid ACTION \033[0m \n"
            displayUsage
            exit -99
       fi
    fi
     
    exit 0
}


main $*
