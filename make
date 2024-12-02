#!/bin/bash
# Arkdrenaline build script by sdhEmily
if [ $# -eq 0 ]; then
  echo "Building in 2 seconds..."
  sleep 2
else
  IP=$1
  if [[ $1 == "ask" ]]; then # i think this is bad but idk
    clear
    printf 'Enter the IP address of your Vita. > '
    read IP
  fi
  if ! [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "$IP isnt a valid IP address."
    exit;
  fi
  if [[ $2 = "-i" ]]; then
    install=true
    echo "Building & installing to $IP in 2 seconds..."
    sleep 2
  else
    echo "Building & sending to $IP in 2 seconds..."
    sleep 2
  fi
fi



cd cef
make
cd ..
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
if [ $? -ne 0 ]; then
  echo "An error occurred during building. Exiting..."
  exit;
fi

install() { 
  ping -c 1 $IP > /dev/null
  if [ $? -ne  0 ]; then
    echo "$IP is not reachable. Is your Vita asleep? Did you enter the wrong IP?"
    read -p "Press enter to retry..."
    install
  fi

  if ! [[ $install ]]; then
    mkdir ./build/vpk
    cd ./build/vpk
    unzip ../bubble/Adrenaline.vpk

    send () {
    for f in "."/*.*
    do
      curl --ftp-method nocwd -T $f ftp://$IP:1337/ux0:/app/PSPEMUCFW/$1/ # yeah this probably sucks
    done
    }

    # This is probably the worst way to do this. ¯\_(ツ)_/¯
    echo destroy | nc $IP 1338
    send
    cd sce_module
    send sce_module
    cd ../sce_sys
    send sce_sys
    cd ./livearea/contents
    send sce_sys/livearea/contents

    cd ../../../../ # this looks terrible but it works
    rm -r ./vpk
  else
    curl --ftp-method nocwd -T ./build/bubble/Adrenaline.vpk ftp://$IP:1337/ux0:/
    echo destroy | nc $IP 1338
    echo vpk ux0:Adrenaline.vpk | nc $IP 1338
  fi

  sleep 1 # without the sleep it doesnt launch the app
  echo launch PSPEMUCFW | nc $IP 1338
  exit;
}

if [ $# -ne 0 ]; then
  install
fi