#!/bin/ksh 
#based on explanations of pmap in http://www.makelinux.co.il/books/lkd2/ch14lev1sec2

#Verify the parameter count
if [ $# -lt 1 ]; then
   echo "Usage: $0  [long|columnar]
   echo " e.g.: $0  columnar
   exit 1
fi

sids=` ps -elf | grep ora_pmon | grep -v grep |awk '{print $15}'| awk -F'_' '{print $3}'| paste -s`
dis=0

for ORACLE_SID in $sids
do
#Set variables
#export ORACLE_SID=$1
output_type=$1

#running calculations...

export pids=`ps -elf|grep oracle$ORACLE_SID|grep -v grep|awk '{print $4}'`

export countcon=`print "$pids"|wc -l`

if [ "$pids" != "" ]; then
	if [ "`uname -a|cut -f1 -d' '`" = "Linux" ]; then
   		export tconprivsz=$(pmap -x `print "$pids"`|grep " rw"|grep -Ev "shmid|deleted"|awk '{total +=$2};END {print total}')
	else
   		export tconprivsz=$(pmap -x `print "$pids"`|grep " rw"|grep -v "shmid"|awk '{total +=$2};END {print total}')
	fi
else
	export tconprivsz=0
fi

export avgcprivsz=`expr $tconprivsz / $countcon`

if [ "`uname -a|cut -f1 -d' '`" = "Linux" ]; then
   export instprivsz=$(pmap -x `ps -elf|grep ora_.*_$ORACLE_SID|grep -v grep|awk '{print $4}'`|grep " rw"|grep -Ev "shmid|deleted"|awk '{total +=$2};END {print total}')
else
   export instprivsz=$(pmap -x `ps -elf|grep ora_.*_$ORACLE_SID|grep -v grep|awk '{print $4}'`|grep " rw"|grep -v "shmid"|awk '{total +=$2};END {print total}')
fi

if [ "`uname -a|cut -f1 -d' '`" = "Linux" ]; then
   export instshmsz=$(pmap -x `ps -elf|grep ora_pmon_$ORACLE_SID|grep -v grep|awk '{print $4}'`|grep -E "shmid|deleted"|awk '{total +=$2};END {print total}')
else
   export instshmsz=$(pmap -x `ps -elf|grep ora_pmon_$ORACLE_SID|grep -v grep|awk '{print $4}'`|grep "shmid"|awk '{total +=$2};END {print total}')
fi

export binlibsz=$(pmap -x `ps -elf|grep ora_pmon_$ORACLE_SID|grep -v grep|awk '{print $4}'`|grep -v " rw"|  awk '{total +=$2};END {print total}')

export sumsz=`expr $tconprivsz + $instprivsz + $instshmsz + $binlibsz`

if [[ "$output_type" = "long" ]]; then
   echo memory used by Oracle instance $ORACLE_SID as of `date`
   echo
   echo "Total shared memory segments for the instance..................: "$instshmsz KB
   echo "Shared binary code of all oracle processes and shared libraries: "$binlibsz KB
   echo "Total private memory usage by dedicated connections............: "$tconprivsz KB
   echo "Total private memory usage by instance processes...............: "$instprivsz KB
   echo "Number of current dedicated connections........................: "$countcon
   echo "Average memory usage by database connection....................: "$avgcprivsz KB
   echo "Grand total memory used by this oracle instance................: "$sumsz KB
   echo
elif [ "$output_type" = "columnar" ]; then
   [ "$dis" -eq "0" ] && printf "%17s %10s %10s %10s %10s %10s %10s %10s %10s\n" "date" "ORACLE_SID" "instshmsz" "binlibsz" "tconprivsz" "instprivsz" "countcon" "avgcprivsz" "sumsz"
   [ "$dis" -eq "0" ] && echo "----------------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------"
   dis=1
   printf "%17s %10s %10s %10s %10s %10s %10s %10s %10s\n" "`date +%y/%m/%d_%H:%M:%S`" $ORACLE_SID $instshmsz $binlibsz $tconprivsz $instprivsz $countcon $avgcprivsz $sumsz
fi;
done
