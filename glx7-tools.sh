#!/bin/bash
function hostnamechanger {
    oldhn=$(hostname)
    sleep 1
    echo "Changing hostname..." 
    read -p "Nedd FWDN hostname?(y/n)" var
    case "$var" in
        "y")  
            read -p "Enter FQDN hostname:" fqdnhostname
            fqdncheck=$(tr -dc '.' <<<"$fqdnhostname" | awk '{ print length; }')

            if [ "$fqdncheck" -eq 2 ]
            then
                echo fqdn ok
                hostnamectl set-hostname "$fqdnhostname"
                echo -n OK, hostname changed: 
                hostname
                fixhosts "$oldhn"
            else   
                echo fqdn error, hostname not changed
            fi
        ;;
        "n")
            read -p "Enter new hostname:" newhostname
            hostnamectl set-hostname "$newhostname"
            echo -n OK, hostname changed: 
            hostname
            fixhosts "$oldhn"
        ;;
        * )  echo "invalid option"     ;;
    esac
} # меняет hostname на обычный либо fqdn (с проверкой) 
# добавить fix /etc/hosts

function fixhosts () {
    oldhn=$1
    echo "$oldhn"
    newhn=$(hostname)
    echo "$newhn"
    fqdncheck=$(tr -dc '.' <<<"$newhn" | awk '{ print length; }')
    if [ "$fqdncheck" -eq 2 ]
            then
                
                sed -i "s/$oldhn/$newhn/gi" /etc/hosts
            else   
                sed -i "s/$oldhn/$newhn/gi" /etc/hosts
            fi
    
    echo hosts fixed
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
    sleep 3
done





