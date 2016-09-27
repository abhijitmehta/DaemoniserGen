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
```bash
./daemoniserGen.sh  -p process2 -a START  -s 30  -c daemon.cfg -n 5
```
![alt tag](https://github.com/abhijitmehta/DaemoniserGen/blob/master/Screen%20Shot%202016-09-28%20at%2012.26.18%20AM.png)


Stopping above daemon of process2
```bash
./daemoniserGen.sh  -p process2 -a  STOP -c daemon.cfg 
```
![alt tag](https://github.com/abhijitmehta/DaemoniserGen/blob/master/Screen%20Shot%202016-09-28%20at%2012.34.06%20AM.png)

##Logs
Logs and flags for standard output and error are created in path specified in the config files. 
Example :
```bash
-rw-r--r--  1 amehta  410487729        0 Sep 28 00:33 process2.stopIt
-rw-r--r--  1 amehta  410487729  3048345 Sep 28 00:33 process2.4343.4.out.log
-rw-r--r--  1 amehta  410487729  3928978 Sep 28 00:33 process2.4343.4.error.log
-rw-r--r--  1 amehta  410487729  3049830 Sep 28 00:33 process2.4343.3.out.log
-rw-r--r--  1 amehta  410487729  3930892 Sep 28 00:33 process2.4343.3.error.log
-rw-r--r--  1 amehta  410487729  3061800 Sep 28 00:33 process2.4343.2.out.log
-rw-r--r--  1 amehta  410487729  3946320 Sep 28 00:33 process2.4343.2.error.log
-rw-r--r--  1 amehta  410487729  3058335 Sep 28 00:33 process2.4343.1.out.log
-rw-r--r--  1 amehta  410487729  3941854 Sep 28 00:33 process2.4343.1.error.log
-rw-r--r--  1 amehta  410487729  3071430 Sep 28 00:33 process2.4343.0.out.log
-rw-r--r--  1 amehta  410487729  3958732 Sep 28 00:33 process2.4343.0.error.log
```
