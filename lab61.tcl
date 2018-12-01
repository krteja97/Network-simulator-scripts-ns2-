set ns [new Simulator]

#Use colors to differentiate the traffic
$ns color 1 Red
$ns color 2 Blue

#Open trace and NAM trace file
set ntrace [open out.tr w]
$ns trace-all $ntrace
set namfile [open out.nam w]
$ns namtrace-all $namfile

set winFile0 [open WinFile0 w]
set winFile1 [open WinFile1 w]

#Finish Procedure
proc Finish {} {
global ns ntrace namfile

#Dump all trace data and close the files
$ns flush-trace
close $ntrace
close $namfile
exec nam out.nam &
exec xgraph WinFile0 WinFile1 &
exit 0
}

proc PlotWindow {tcpSource file} {
	global ns
	set time 0.1
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "PlotWindow $tcpSource $file"
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns simplex-link $n2 $n3 0.3Mb 100ms DropTail
$ns simplex-link $n3 $n2 0.3Mb 100ms DropTail


set lan [$ns newLan "$n3 $n4 $n5" 0.3Mb 50ms LL Queue/DropTail MAC/802_3 Channel]

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns simplex-link-op $n2 $n3 orient right

$ns queue-limit $n2 $n3 20
$ns simplex-link-op $n2 $n3 queuePos 0.5

set loss_module [new ErrorModel]
$loss_module set  rate_ [expr [lindex $argv 0]]
$loss_module ranvar [new RandomVariable/Uniform]
$loss_module drop-target [new Agent/Null]
$ns lossmodel $loss_module $n1 $n2


set tcp0 [new Agent/TCP/Newreno]
$tcp0 set fid_ 1
$tcp0 set window_ 8000
$tcp0 set packetSize_ 552
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink/DelAck]
$ns attach-agent $n4 $sink0
$ns connect $tcp0 $sink0

#Apply FTP Application over TCP
set ftp0 [new Application/FTP]
$ftp0 set type_ FTP
$ftp0 attach-agent $tcp0

set tcp1 [new Agent/TCP/Newreno]
$tcp1 set fid_ 2
$tcp1 set window_ 8000
$tcp1 set packetSize_ 552
$ns attach-agent $n5 $tcp1
set sink1 [new Agent/TCPSink/DelAck]
$ns attach-agent $n1 $sink1
$ns connect $tcp1 $sink1

#Apply FTP Application over TCP
set ftp1 [new Application/FTP]
$ftp1 set type_ FTP
$ftp1 attach-agent $tcp1

$ns at 0.1 "$ftp0 start"
$ns at 0.1 "PlotWindow $tcp0 $winFile0"
$ns at 0.5 "$ftp1 start"
#$ns at 0.5 "PlotWindow $tcp1 $winFile1"
$ns at 25.0 "$ftp0 stop"
$ns at 25.1 "$ftp1 stop"
$ns at 25.2 "Finish"

$ns run




