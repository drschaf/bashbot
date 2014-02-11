#!/bin/bash

fdir=$FIFODIR

echo "Starting writer..."
{ while :; do
	cat $fdir/OUTFIFO;
done } | bash ./caller.sh > $fdir/INFIFO
