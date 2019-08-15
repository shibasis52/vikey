read -p "enter the old ip address that needs to be replace in /etc/named.conf file:" old
IP=`echo $old`
read -p "enter new ship ip address:" new
newip=`echo $new`
read -p "Entered IP adrress in oldship is $IP can we proceed further(y|n)? " pro
#if [ "$pro" = "y" ]; then
if [ "$pro" = "y" ] || [ "$pro" = "Y" ]; then
  echo "Glad to hear it is replacing now $IP with $newip in /etc/named.conf file"
  #sed -i "s/$IP/$newip/i" /etc/named.conf
   #sed -e "/listen-on port 53 {/s$IP/$newip/i" /etc/named.conf
   sed  -i "13s/.*/listen-on port 53 {$newip; 127.0.0.1;}/" /etc/named.conf
else
  echo "Please provide the correct ip addree"
fi
