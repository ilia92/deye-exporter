#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"

#if [ -z "$STY" ]; then
if [ "$1" = "--screen" ]; then
printf "Translator+webserver started in background\n"
screen -S stats_to_prom -X quit > /dev/null
exec screen -dm -S stats_to_prom /bin/bash $0
fi

source $DIR/translator.conf

export request=
export result=

handle_http(){

html_header='HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Server: netcat!

'

result="$html_header"
request=`printf "$request" | grep -o "GET /.* "`

#printf "Request1: $request"

case "$request" in
	("GET /test ") result+="Test PASS!" ;;
#        ("GET /metrics ") result+=`$DIR/stats_scripts/*` ;;
        ("GET /metrics ") for f in $DIR/stats_scripts/*.sh; do result+=`bash "$f" ; echo "\n"` ; done ;;
        ("GET / ") result+="empty2"  ;;
	(*) result+="Unknown command!" ;;
esac
#printf "Result1: $result"

}

#get_stats array_to_prom result+="$advertised_data"

while [ 1 ]
do

coproc (nc -l $server_port 2>&1)

{
    read request
#    declare "$( sed -e 's/^Connection from \([^ ]*\).*$/client="\1"/' -e 'q' )"
#    date >> entries.html
    handle_http >/dev/null 2>&1
    printf "$result" && sleep 0.1
} <&${COPROC[0]} >&${COPROC[1]}

kill "$COPROC_PID"

printf "REQUEST: $request\n"
printf "RESPONSE: $result\n\n"
sleep 0.1
done
