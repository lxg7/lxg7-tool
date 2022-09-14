#!/bin/bash

echo #         _      ______     _              _ 
echo #        | |    |___  /    | |            | |
echo #    __ _| |_  __  / /_____| |_ ___   ___ | |
echo #   / _` | \ \/ / / /______| __/ _ \ / _ \| |
echo #  | (_| | |>  <./ /       | || (_) | (_) | |
echo #   \__, |_/_/\_\_/         \__\___/ \___/|_|
echo #    __/ |                                   
echo #   |___/                                    
     #============================================
while :
do
    clear
    cat<<EOF
    #============================================
    Astra Linux managment tool
    #--------------------------------------------
    Please enter your choice:

    (1) Network (new static iface)
    (2) Hostname
    (3) Change /etc/hosts file
    (4) 
    Option (3)
           (Q)uit
    #--------------------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1")  echo "you chose choice 1" ;;
    "2")  echo "you chose choice 2" ;;
    "3")  echo "you chose choice 3" ;;
    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
