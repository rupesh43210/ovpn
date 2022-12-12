#!/bin/bash

#chcek is a user is root
checksudo(){
            if [[ $EUID -ne 0 ]]; then
           echo "This script must be run as root" 
           echo " You need to run this script as root - run the command sudo su"
           exit 1
        fi
 }

REQUIRED_PKG="openvpn"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
   sudo apt-get --yes install $REQUIRED_PKG
   fi

read -p " do you want to connect or disconnect from VPN (C/D)  " choice

if [[ $choice == "C" || $choice == "c" ]]; then
     currentdirectory=$(pwd)
     echo "your current working dorectory is " $currentdirectory
    read -p " Provide path to ovpn file  " location

    sudo openvpn $location &
    ip a | grep tun0
    echo "successfully connected"
    exit 

elif [[ $choice == "d" || $choice == "D" ]]; then

    sudo killall openvpn
    sleep 20
    echo "Successfully disconnected"

else
echo "not a right option"
fi

