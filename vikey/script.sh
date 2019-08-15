#!/bin/bash
namedfile=`cat /etc/named.conf| grep -i .db | grep -v "#" | awk -F '["]' {'print $2'}  | grep -v "cache" | sort -u`
varfile=`ls /var/named/ | grep .db`

varray=$namedfile
  for v in ${varray[@]}
  do
    if ! [[ "$varfile" =~ "$v" ]]; then
       echo "These Files are not present in /var/named directory but present in named.conf configuration please check and try again. -- $v"
       exit 0
    fi
  done
barray=$varfile
  for b in ${barray[@]}
  do
    if ! [[ "$namedfile" =~ "$b" ]]; then
       echo "These files are not present named.conf configuration file but present in /var/named directory please check and try again.  -- $b"
       exit 0
    fi
  done

re='[a-zA-Z]'
read -p "Enter the Old Ship Code that needs to be replaced like (kp,gp,ip): " code
echo $code
if ! [[ "$code" =~ $re ]]; then
        {
        echo "It is a Numeric Value Please enter a String"
        exit 0
        }
fi
read -p "Enter the Current Ship Code tlike (kp,gp,ip): " newcode
if ! [[ "$newcode" =~ $re ]]; then
        {
        echo "It is a Numeric Value Please enter a String"
        exit 0
        }
else
        {
        cd /var/named/
        sed -i "s/\b$code\b/$newcode/g" *.db
        sed -i "s/\b$code\b/$newcode/g" /etc/named.conf
        }
fi
echo "All the old value "$code" is now replaced by "$newcode" in all DB files inside /var/named directory and named.conf configuration file "

read -p "Enter the Old Ship Name like (emerald,crown,coral): " string
echo $string
if ! [[ "$string" =~ $re ]]; then
        {
        echo "It is a Numeric Value Please enter a String"
        exit 0
        }
fi
read -p "Enter the New Ship Name like (emerald,crown,coral): " newstring
if ! [[ "$newstring" =~ $re ]]; then
        {
        echo "It is a Numeric Value Please enter a String"
        exit 0
        }
 else
        {
        cd /var/named/
        sed -i "s/\b$string\b/$newstring/g" *.db
        }
fi
echo "All the old Ship name "$string" is now replaced by $newstring in all DB files inside /var/named directory"
systemctl restart named
