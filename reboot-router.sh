#!/bin/sh


function login(){
  data="$1"
  ret=$(curl -i -X POST -sS http://192.168.1.1/cgi-bin/luci -H 'Content-Type: application/x-www-form-urlencoded' -d "$data")
  echo "$ret" | grep -Eo 'sysauth=[^ =;]+' | sed 's/^.*=//g'
}

function get_token(){
  sysauth="$1"

  ret=$(curl -sS "http://192.168.1.1/cgi-bin/luci/" -i -H "Cookie: sysauth=$sysauth")
  echo "$ret" | grep -Eo "data: \{ token: '[^']+" | sed "s/.*'//g"
  
}



function reboot(){
  sysauth="$1"
  token="$2"
  curl -i 'http://192.168.1.1/cgi-bin/luci/admin/reboot' -X POST -H 'Content-type: application/x-www-form-urlencoded' -H "Cookie: sysauth=$sysauth" --data "token=$token"
}

sysauth=$(login "username=useradmin&psd=xxxx")
sleep 0.5
token=$(get_token "$sysauth")
sleep 0.5

reboot "$sysauth" "$token"
