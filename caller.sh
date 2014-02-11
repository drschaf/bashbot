#!/bin/bash

nick=$NICK
user="$IDENT 0 0 $USER"
channel=$CHANNEL

init=

trap close INT

function close {
	send "QUIT Pressed CTRL+C"
	exit 0
}

function handler {
	name=$1
	command=$2
	shift 2
	list=$@

	case "$command" in
		"PRIVMSG")
			channel=$(echo $list | cut -d' ' -f1)
			message=$(echo $list | cut -d':' -f2-)
			debug "PRIVMSG: $list"
		;;
	esac
}
function debug {
	echo "$@" >&2
}
function send {
	ret="$@"
	if [ "$ret" ]; then
		debug "SEND $ret"
		echo "$ret" >&1
	fi
}

debug "Starting caller..."

line=0

while read LINE; do
	let line=line+1

	if [ $line -eq 3 ]; then
		send "NICK $nick"
		send "USER $user"
	fi

	debug "RECV  $LINE"

	pre=$(echo "$LINE" | cut -d: -f1 | sed -e 's/^ *//g' -e 's/ *$//g')
	debug "$pre"
	case "$pre" in
#	"NOTICE"|"NOTICE AUTH")
#		a=$(echo "$LINE" | cut -d' ' -f4)
#		if [ "$a" == "No" ]; then
#			send "NICK $nick"
#			send "USER $user"
#		fi
#		;;
	"PING")
		p=$(echo "$LINE" | cut -d: -f2)
		send "PONG $p"
		;;
	"")
		cmd=$(echo "$LINE" | cut -d' ' -f2)
		debug "c: $cmd"
		if [ -z "$init" ]; then
			if [ "$cmd" == "376" ]; then
				init=1
				send "JOIN $channel"
			fi
		else
			handler $(echo "$LINE" | cut -d':' -f2-)
		fi
		;;
	esac
done
