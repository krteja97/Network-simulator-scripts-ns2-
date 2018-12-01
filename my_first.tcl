set ns [new Simulator]

#create the files

$ns color 0 Blue
$ns color 1 Red

set trace_file [open my_first.tr w]
set namtrace_file [open my_first.nam w]
$ns trace-all $trace_file
$ns namtrace-all $namtrace_file

#create the finish procedure

proc finish {} {
	global ns trace_file namtrace_file y
	$ns flush-trace
	#puts "Simulation completed"
	close $trace_file
	close $namtrace_file
	#set y [exec grep -c "^d" my_first.tr ]
	#puts "$y"
	#exec nam my_first.nam &
	exit 0
}

#setup nodes

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

#setup connections

$ns duplex-link $n0 $n2 1Mb 5ms DropTail
$ns duplex-link $n1 $n2 [lindex $argv 0]Mb 1ms DropTail
$ns duplex-link $n2 $n3 2Mb 3ms DropTail
$ns duplex-link $n2 $n4 3Mb 1ms DropTail

$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10

#setup protocols
#udp between n1 and n4

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0 
set null0 [new Agent/Null]
$ns attach-agent $n4 $null0 
$ns connect $udp0 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0


#tcp protocol between n0 and n3

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0 
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0 

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns connect $tcp0 $sink0

#here attaching file to tcp for congestion window

set file1 [open file1.tr w]
$tcp0 attach $file1

$tcp0 trace cwnd_




$tcp0 set fid_ 0
$udp0 set fid_ 1

#start up the process

$ns at 0.5 "$ftp0 start"
$ns at 7.0 "$ftp0 stop"
$ns at 1.0 "$cbr0 start"
$ns at 6.5 "$cbr0 stop"

$ns at 7.3 "finish"
$ns run





