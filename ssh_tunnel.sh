#!/usr/bin/bash

#-Find process if run on port 9092 and kill it before start
test=$(netstat -tulpn | grep 9092 | cut -d "/" -f 1 | cut -d "N" -f 2 )
kill -9 $test;

#-Main tunnel
python socks5_tunnel.py &
sleep 3

#-Auto login with password
#sshpass -p [SERVER_SSH_PASSWORD] ssh -C -o "ProxyCommand=nc -X CONNECT -x 127.0.0.1:9092 %h %p" [SERVER_USERNAME]@[SERVER_PUBLIC_IP] -p 443 -v -CND 1080 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null

#-Manual login
#ssh -C -o "ProxyCommand=nc -X CONNECT -x 127.0.0.1:9092 %h %p" [SERVER_USERNAME]@[SERVER_PUBLIC_IP] -p 443 -CND 1080 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
