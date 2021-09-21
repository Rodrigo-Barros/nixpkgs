#!/usr/bin/env bash
interval=60
host=10.0.0.106
port=3240
bus=1-1.1.3
printer_online=false
while [ $printer_online = false ]
do
  nc -z $host $port
  if [ $? = 0 ];then
    printer_online=true
    sudo usbip attach -r $host -b $bus
    echo "Executado com sucesso"
  fi
  sleep $interval
  echo "a impressora não foi encontrada"
done
