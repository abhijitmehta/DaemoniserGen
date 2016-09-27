# DaemoniserGen
Script to daemonise any single threaded non-daemon process . 

##Options
	+------------------------------------------------------------------------------------------------------------------------- +
	|                                                                                                                          |
	| USAGE  :: DaemoniserGen -p <ProcName> -a <START/STOP> -s <SLEEP_INTERVAL>  -c <CONFIG_FILE>   -n <NUM_OF_INSTANCES>      |
	|           where                                                                                                          |
	|                ProcName        -  the process to be daemonised . It's an executable which will be                        |
	|                                   be run in loop by DaemoiserGen with specified parameters                               |
	|                                   If <ProcName> is not placed in a directory from PATH , give full path                  |
	|                START/STOP      -  parameter indicating if the script should start of stop the process                    |
	|                                   being daemonised by DaemoinserGen                                                      |
	|                SLEEP INTERVAL  -  if any sleep interval to be implemented while running <ProcName> in                    |
	|                [Optional]         in loop.                                                                               |
	|                                   It might be useful if the <procName> doesnt provide any relevant                       |
	|                                   looping logic                                                                          |
	|                CONFIG_FILE      - If there are specific parameters that <procName> requires , that                       |
	|                [Optional]         can be set in <CONFIG_FILE> . DaemoiserGen will source it to shell                     |
	|                                   environment and make it available for <ProcName>                                       |
	|                                   It can also be used to overwrite common variables for DaemoniserGen                    |
	|                                   such as WORK_DIR , LOG_DIR etc .Do this only if you know                               |
	|                                   DaemoniserGen thorougly                                                                |
	|                NUM_OF_INSTANCES - WHEN multiple parallel instances of the daemon are to be run                           |
	|                                   Please use this only when <ProcName> is intelligent enough to handle parallelism       |
	|                                   Also advised to use config file when you use this option to have variables required    |
	|                                   to support parrallel instances                                                         |
	|                                                                                                                          |
	|                                                                                                                          |
	|                                                                                                                          |
	+--------------------------------------------------------------------------------------------------------------------------+


## Example Usages 
daemonise an executable namely "process2" with sleep interval of 30 seconds and in 5 parallel instances . Also pass parameters stored in daemon.cfg file 
>>./daemoniserGen.sh  -p process2 -a START  -s 30  -c daemon.cfg -n 5

![alt tag](https://github.com/abhijitmehta/DaemoniserGen/blob/master/Screen%20Shot%202016-09-28%20at%2012.26.18%20AM.png)


Stopping above daemon of process2
>>./daemoniserGen.sh  -p process2 -a  STOP -c daemon.cfg 

![alt tag](https://github.com/abhijitmehta/DaemoniserGen/blob/master/Screen%20Shot%202016-09-28%20at%2012.34.06%20AM.png)
