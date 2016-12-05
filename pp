
#!/bin/bash

#No Arguments Provided. Exit program`
if [ $# -lt 1 ]; then
    echo "ERROR: No Arguments Provided. Terminating..."
    exit 1
fi

TEMP=`getopt -q -o o: --long obs: --  "$@"`

if [ $? != 0 ] ; then echo "ERROR: Bad Option Passed. Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

#Begin Parsing Command Line Arguments
while [ $# -gt 0 ] ; do
    case "$1" in
        -o | --obs) 
            case $2 in
                ''|*[!0-9]*) 
                    echo "ERROR: Option -o|--obs value '$2' is not  numeric. Terminating..." ; exit 1 ;;
                *) OBS=$2 ; echo "$OBS" ; shift 2 ;;
            esac ;;
        --) shift ; break ;; #End flags
        *) echo "ERROR: Internal error! Terminating..." ; exit 1 ;;
    esac
done


if [ $# -gt 1 ]; then
    echo "ERROR: Too Many Arguments. Expecting a file. Terminating"
    exit 1
fi

for arg do file=$arg ; done

##Check if File exists
if [ -f $file ]; then 
    #Make sure its a SAS File
    if [ ${file##*.} != 'sas7bdat' ]; then
        echo " ERROR: '$file' is not a SAS File "
        exit 1
    fi
    inputFile=${file%.*}
    sasDS=${inputFile##*/}
    lib=$(dirname "${file}")
else
    #If file does not exist exit program
    echo "ERROR: File '$file' does not exist"
    exit 1
fi

if [ -z "$OBS" ]; then
    sasinit="%let DS=$sasDS; %let obsval=none; %let lib=$lib;"
else
    sasinit="%let DS=$sasDS; %let obsval=$OBS; %let lib=$lib;" 
fi

#finally after so much work we can actually execute SAS
sas -stdio -nolog -initstmt "$sasinit" /home/grievesc/sasmacros/pp.sas 
#echo $inputFile
#echo $sasDS
