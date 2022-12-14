#!/bin/bash

lastcheck1=0
lastcheck2=0
lastcheck3=0
lastcheck4=0
lastcheck5=0
lastcheck6=0
lastcheck7=0

echo -e '\n---Security level check'

modeswcheck=$(astra-modeswitch get)

if [ "$modeswcheck" = "2" ]
then
	echo astra-modeswitch is correct
	lastcheck1=1
else
	echo astra-modeswitch error
fi


echo -e '\n---FQDN check'

echo Enter FQDN hostname:
read fqdnhostname
hostnamectl set-hostname "$fqdnhostname"
fqdncheck=$(tr -dc '.' <<<"$fqdnhostname" | awk '{ print length; }')

if [ "$fqdncheck" -eq 2 ]
then
    echo fqdn ok
    lastcheck2=1
fi


echo -e '\n---hosts file fix'

echo "Correct the hosts file to match:"
echo "127.0.0.1 localhost.localdomain localhost"
echo "<IP-адрес_сервера> <имя_сервера>.<домен> <имя_сервера>"
echo "127.0.1.1 <имя_сервера>"
echo Open hosts file?
read ok
nano /etc/hosts

if ping -c 1 "$fqdnhostname" &> /dev/null
then
	echo "hosts is ok"
	lastcheck3=1
else
	echo "hosts is incorrect"
	echo 0
fi

echo -e '\n---Internet repos check'
# ping -c 3 download.astralinux.ru > /dev/null && echo "repo is ok" && lastcheck4=1 || echo "repo is unreachable" && exit 1
if ping -c 3 download.astralinux.ru &> /dev/null
then
	echo "repo is ok"
	lastcheck4=1
else
	cho "repo is unreachable"
	echo 0
fi


echo -e '\n---sources.list fix'
mv /etc/apt/sources.list /etc/apt/sources.list.BAK
echo -e "deb http://download.astralinux.ru/astra/frozen/1.7_x86-64/1.7.1/repository-base 1.7_x86-64 main non-free contrib" | sudo tee /etc/apt/sources.list
echo -e "deb http://download.astralinux.ru/astra/frozen/1.7_x86-64/1.7.1/repository-extended 1.7_x86-64 main contrib non-free" | sudo tee -a /etc/apt/sources.list

apt update

echo Installing ALD Pro repos
echo -e "deb https://download.astralinux.ru/aldpro/stable/repository-main/ 1.0.0 main" | sudo tee /etc/apt/sources.list.d/aldpro.list
echo -e "deb https://download.astralinux.ru/aldpro/stable/repository-extended/ generic main" | sudo tee -a /etc/apt/sources.list.d/aldpro.list

echo -e "Package: *\nPin: release n=generic\nPin-Priority: 900" > /etc/apt/preferences.d/aldpro
lastcheck5=1

echo -e '\n---Astra-version check'
echo "Current: $(cat /etc/astra_version)"
echo Version should match 1.7.1 or later

echo 'Perform upgrade?(y / n)'
read upgrvar

case "$upgrvar" in

 "y" )
 apt install -y astra-update
 apt update && astra-update -A -r -n
 lastcheck6=1
 ;;

 "n" )
 echo Skipping update
 ;;

 * )
 exit 1
 ;;
esac

echo -e '\n---Net port configuration'

echo 'Какой порт?'
read iface
echo 'Какой адрес?'
read addr
echo 'Какая маска?'
read mask
echo 'Какой адрес по умолчанию(gateway)?'
read defgw
echo 'Какой dns?'
read dns
echo 'Какой поисковый домен?'
read dom
echo -e "\n\nauto $iface\niface $iface inet static\naddress $addr\nnetmask $mask\ngateway $defgw\ndns-nameservers $dns\ndns-search $dom" >> /etc/network/interfaces

echo -e '\n---Turning off NetManager'
sudo systemctl stop network-manager
sudo systemctl disable network-manager
lastcheck7=1

echo "nameserver $addr" > /etc/resolv.conf
echo "search $dom" >> /etc/resolv.conf
echo -e "\n\n"
cat /etc/resolv.conf
echo -e "\n\n"

echo "Global check:"
if [ $lastcheck1 -eq 1 ]; then echo "1. Security level ok!"; else echo "Security level ERROR!"; fi 
echo 
if [ $lastcheck2 -eq 1 ]; then echo "2. FQDN ok!"; else echo "FQDN ERROR!"; fi
echo 
if [ $lastcheck3 -eq 1 ]; then echo "3. hosts fix ok!"; else echo "hosts fix ERROR!"; fi
echo 
if [ $lastcheck4 -eq 1 ]; then echo "4. Repos ok!"; else echo "Repos ERROR!"; fi
echo 
if [ $lastcheck5 -eq 1 ]; then echo "5. ALD Pro repos ok!"; else echo "ALD Pro repos ERROR!"; fi
echo 
if [ $lastcheck6 -eq 1 ]; then echo "6. Astra version ok!"; else echo "Astra version ERROR!"; fi
echo 
if [ $lastcheck7 -eq 1 ]; then echo "7. Network and resolv ok!"; else echo "Network ERROR!"; fi

echo "Start installing ald pro?(y / n)" 
read installgo
if [ "$installgo" = "y" ]
then 
	sudo systemctl start network-manager
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -q -y aldpro-mp
	echo "Enter hostname (dc for dc.domain.test)"
	read domain
	echo Enter password
	read aldpass
	echo 'Enter static ip for domain'
	echo -e "Domain: $dom\nDomains hostname: $domain\nDomain static addr: $addr"
	sudo /opt/rbta/aldpro/mp/bin/aldpro-server-install.sh -d "$dom" -n "$domain" -p "$aldpass" --ip "$addr" --no-reboot
fi
echo finished installing