#!/bin/bash

export IRCHOST=
export IRCPORT=
export CHANNEL=

export IDENT=
export NICK=
export USER=

while getopts "h:p:u:i:c:n:" opt; do
	case $opt in
	h)
		IRCHOST=$OPTARG
		;;
	p)
		IRCPORT=$OPTARG
		;;
	n)
		NICK=$OPTARG
		;;
	i)
		IDENT=$OPTARG
		;;
	c)
		CHANNEL=$OPTARG
		;;
	u)
		USER="$OPTARG"
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	:)
		echo "Option -$OPTARG requires an argument." >&2
		exit 1
		;;
	esac
done

if [ -z "$IRCHOST" ]; then
	echo "Please give me a host with -h <host>">&2
	exit 1
fi
if [ -z "$CHANNEL" ]; then
	echo "Please give me a channel with -c <channel>">&2
	exit 1
fi
if [ -z "$NICK" ]; then
	echo "Please give me a nick name with -n <nick>">&2
	exit 1
fi
[ -z "$IRCPORT" ] && IRCPORT=6667
[ -z "$IDENT" ] && IDENT="bashbot"
[ -z "$USER" ] && USER="bash rocks!"

mkdir /tmp/bashbot-$$
export FIFODIR=/tmp/bashbot-$$

mkfifo $FIFODIR/INFIFO
mkfifo $FIFODIR/OUTFIFO
chmod 777 $FIFODIR
chmod 777 $FIFODIR/{IN,OUT}FIFO

bash ./listener.sh &
bash ./writer.sh &
