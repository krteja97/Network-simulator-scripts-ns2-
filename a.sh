#!/bin/sh

i=1
d=0
throughput=0
x=10
while [ $i -lt 30 ]
do
    `exec ns lab42.tcl $x`
	throughput=`exec awk -f throughput.awk lab42.tr`
	d=`exec awk -f dropped.awk lab42.tr`
	echo "throughput is $throughput"
	echo "dropped packets are $d"
	echo "$i $throughput" >> throughput.dat
	echo "$i $d"  >> dropped.dat
	i=`expr $i + 1`
	x=`expr $x + 20` 
	#x=$x+0.2|bc
	echo "$x"
done