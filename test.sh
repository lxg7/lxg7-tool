ping -c 1 ya.ru 

if [ $? -ge 0 ] 
then 
	echo ok 
else 
	echo error 
fi
