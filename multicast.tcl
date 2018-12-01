set ns [new Simulator -multicast on] 

set trace [open test19.tr w]
$ns trace-all $trace
set namtrace [open test19.nam w]
$ns namtrace-all $namtrace

set group [Node allocaddr] 

set node0 [$ns node] 
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]
set node4 [$ns node]

$ns duplex-link $node0 $node1 1.5Mb 10ms DropTail
$ns duplex-link $node0 $node2 1.5Mb 10ms DropTail
$ns duplex-link $node0 $node3 1.5Mb 10ms DropTail
$ns duplex-link $node0 $node4 1.5Mb 10ms DropTail

set mproto DM 
set mrthandle [$ns mrtproto $mproto] 

set udp [new Agent/UDP]
$ns attach-agent $node0 $udp
set src [new Application/Traffic/CBR]
$src attach-agent $udp
$udp set dst_addr_ $group
$udp set dst_port_ 0

set rcvr [new Agent/LossMonitor] 
$ns attach-agent $node1 $rcvr
$ns at 0.3 "$node1 join-group $rcvr $group" 

set rcvr2 [new Agent/LossMonitor]
$ns attach-agent $node2 $rcvr2
$ns at 0.3 "$node2 join-group $rcvr2 $group" 

set rcvr3 [new Agent/LossMonitor] 
$ns attach-agent $node2 $rcvr2
$ns at 0.3 "$node3 join-group $rcvr3 $group" 

set rcvr4 [new Agent/LossMonitor] 
$ns attach-agent $node2 $rcvr2
$ns at 0.3 "$node4 join-group $rcvr4 $group" 


$ns at 3.3 "$node2 leave-group $rcvr2 $group" 
$ns at 3.0 "$node3 leave-group $rcvr3 $group" 

$ns at 2.0 "$src start"
$ns at 5.0 "$src stop"

proc finish {} {
global ns namtrace trace
$ns flush-trace
close $namtrace ; close $trace
exec nam test19.nam &
exit 0
}

$ns at 5.5 "finish"
$ns run
