#!/usr/bin/expect -f
set user birdben
set host 127.0.0.1
set port 50022
set password 123456
set timeout -1

spawn ssh $user@$host -p $port
expect "password:"
send "$password\r"
interact