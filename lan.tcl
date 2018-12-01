set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set tf [open lan.tr w]
set nf [open lan.nam w]
$ns trace-all $tf
$ns namtrace-all $nf


proc finish {} {
	global ns tf nf 
	$ns flush-trace
	close $tf
	close $nf
	#exec nam lan.nam &
	exit 0
}


#declare the nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#connect the connections

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.6Mb 100ms DropTail

set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail MAC//802_3 Channel]

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

#set queue limit and position
$ns queue-limit $n2 $n3 20
$ns duplex-link-op $n2 $n3 queuePos 0.5

#set loss and error model

set loss_module [new ErrorModel]
$loss_module set rate_ [lindex $argv 0]
$loss_module ranvar [new RandomVariable/Uniform]
$loss_module drop-target [new Agent/Null]
$ns lossmodel $loss_module $n2 $n3


#set the ftp connections

set tcp0 [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink/DelAck]
$ns attach-agent $n5 $sink0
set ftp0 [new Application/FTP] ;
$ftp0 attach-agent $tcp0
$ns connect $tcp0 $sink0
#$tcp0 set window_ 8000
$tcp0 set fid_ 1
$ftp0 set type_ FTP

set udp0 [new Agent/UDP] ;
$ns attach-agent $n1 $udp0 ;
set cbr0 [new Application/Traffic/CBR] ;
$cbr0 attach-agent $udp0 ;
$udp0 set fid_ 2 ;
set null0 [new Agent/Null] ;
$ns attach-agent $n4 $null0 ;
$ns connect $udp0 $null0

set file1 [open lan_cwnd.tr w]
$tcp0 attach $file1

$tcp0 trace cwnd_



#event start and stop timings
$ns at 0.1 "$ftp0 start"
$ns at 5.0 "$cbr0 start"
$ns at 25.0 "$ftp0 stop"
$ns at 25.1 "$cbr0 stop"

$ns at 25.2 "finish"
$ns run













