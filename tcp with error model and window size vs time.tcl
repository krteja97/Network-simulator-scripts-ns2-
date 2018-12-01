set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nf [open out.nam w]
$ns namtrace-all $nf

set tf [open out.tr w]
$ns trace-all $tf
set windowvstime [open windowvstime w]


proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $nf
	close $tf
	exec nam out.nam & 
    exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]		



$ns at 0.1 "$n1 label \"CBR\""
$ns at 1.0 "$n0 label \"FTP\""

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns simplex-link $n2 $n3 0.07Mb 20ms DropTail
$ns simplex-link $n3 $n2 0.07Mb 20ms DropTail

$ns queue-limit $n2 $n3 10
$ns simplex-link-op $n2 $n3 queuePos 0.5


set loss_module [new ErrorModel]
$loss_module set rate_ 0.2
$loss_module ranvar [new RandomVariable/Uniform]
$loss_module drop-target [new Agent/Null]
$ns lossmodel $loss_module $n2 $n3



set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n3 $sink
set ftp [new Application/FTP] ;
$ftp attach-agent $tcp
$ns connect $tcp $sink
$tcp set fid_ 1
$ftp set type_ FTP



$ns at 1.0 "$ftp start"
$ns at 624.0 "$ftp stop"



proc plot { tcpsource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpsource set cwnd_ ]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plot $tcpsource $file"
}

$ns at 1.1 "plot $tcp $windowvstime"

set qmon [$ns monitor-queue $n2 $n3 [open qm.out w] 0.1]
[$ns link $n2 $n3] queue-sample-timeout 

$ns at 625.0 "finish"
$ns run
