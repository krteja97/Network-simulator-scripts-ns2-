set ns [new Simulator]

$ns color 0 Blue
$ns color 1 Red

set tf [open lab42.tr w]
set nf [open lab42.nam w]
$ns trace-all $tf
$ns namtrace-all $nf

proc finish {} {
	global ns tf nf retrans
	$ns flush-trace
	close $tf
	close $nf
	puts "$retrans"
    #exec nam lab42.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#now preparing links

# set ap 100.0
# set ax [lindex $argv 0]
# set arg [expr $ax/$ap]
# puts "$arg"

$ns duplex-link $n0 $n2 5Mb 1ms DropTail
$ns duplex-link $n1 $n2 0.5Mb 1ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 1ms RED

$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n2 $n3 20


#queue monitoring
# set file1 [open qm.out w]
# set qmon [$ns monitor-queue $n2 $n3 $file1 0.1]
# [$ns link $n2 $n3 ] queue-sample-timeout

#red queue monitoring
# set redq [[$ns link $n2 $n3] queue]
# set tchan_ [open all.q w]
# $redq trace curq_
# $redq trace ave_
# $redq attach $tchan_




#error model
# set loss_module [new ErrorModel]
# $loss_module set rate_ 
# $loss_module ranvar [new RandomVariable/Uniform]
# $loss_module drop-target [new Agent/Null]
# $ns lossmodel $loss_module $n2 $n3

#lan connection
#set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail MAC//802_3 Channel]


#set the tcp connections

set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp0
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0



set retrans [$tcp0 set nrexmitbytes_]

# set tcp1 [new Agent/TCP]
# set sink1 [new Agent/TCPSink]
# $ns attach-agent $n1 $tcp1
# $ns attach-agent $n3 $sink1
# $ns connect $tcp1 $sink1
# set ftp1 [new Application/FTP]
# $ftp1 attach-agent $tcp1

# $tcp0 set fid_ 0
# $tcp1 set fid_ 1

#tracing of congestion windows
# set cwnd0 [open lab42_cwnd0.tr w]
# $tcp0 attach $cwnd0
# $tcp0 trace cwnd_

# set cwnd1 [open lab42_cwnd1.tr w]
# $tcp1 attach $cwnd1
# $tcp1 trace cwnd_

# $ns at 0.5 "$ftp1 start"
# $ns at 4.5 "$ftp1 stop"
$ns at 0.9 "$ftp0 start"
$ns at 4.9 "$ftp0 stop"
$ns at 5.0 "finish"

$ns run




