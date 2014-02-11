#!/bin/bash

fdir=$FIFODIR
server=$IRCHOST
port=$IRCPORT

echo "Starting listener..."
{ while :; do
	cat $fdir/INFIFO;
done } | nc $server $port > $fdir/OUTFIFO
