#!/bin/bash
function hostnamechanger {
    oldhn=$(hostname)
        sleep 1
        echo "Changing hostname..." 
        echo -e -n "Nedd FWDN hostname?(y/n)"
        read var
        case "$var" in
            "y")  
                echo -n Enter FQDN hostname:
                read fqdnhostname
                fqdncheck=$(tr -dc '.' <<<"$fqdnhostname" | awk '{ print length; }')

                if [ "$fqdncheck" -eq 2 ]
                then
                    echo fqdn ok
                    hostnamectl set-hostname "$fqdnhostname"
                    echo -n OK, hostname changed: 
                    hostname
                else   
                    echo fqdn error, hostname not changed
                fi
            ;;
            "n")  
                echo Enter new hostname:
                read newhostname
                hostnamectl set-hostname "$newhostname"
                echo -n OK, hostname changed: 
                hostname
            ;;
            * )  echo "invalid option"     ;;
            esac
            sleep 1
} # меняет hostname на обычный либо fqdn (с проверкой) 
# добавить fix /etc/hosts

function fixhosts (oldhn){

}


echo "         _      ______     _              _" 
echo "        | |    |___  /    | |            | |"
echo "    __ _| |_  __  / /_____| |_ ___   ___ | |"
echo "   / _  | \ \/ / / /______| __/ _ \ / _ \| |"
echo "  | (_| | |>  <./ /       | || (_) | (_) | |"
echo "   \__, |_/_/\_\_/         \__\___/ \___/|_|"
echo "    __/ |                                   "
echo "   |___/                                    "

while :
do
    #clear
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
    "1")  echo todo                 ;;
    "2")  hostnamechanger           ;;
    "3")  echo todo                 ;;
    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 5
done





