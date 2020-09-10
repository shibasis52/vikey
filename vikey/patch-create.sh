#!/bin/bash
#Here $1=label name $2=file name inside which you will keep your all files,$3=Environment for which you will create patch Creation
if [ $# -ne 3 ]
then
        echo "Usage: you have to provide some label name,file name and the environment name to which you will label"
        exit
fi
#rm -rf /cm_data/direcpc/ubb/build/Evn_specific_file/*
mkdir -p /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn
mkdir -p /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"
HNS=./usr/lib64/perl5/HNS
touch /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file
touch /cm_data/direcpc/ubb/build/Evn_specific_file/nonenvnfile
#> /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file
#> /cm_data/direcpc/ubb/build/Evn_specific_file/nonenvnfile
echo "Enter the list of files for which you will create patch.Press ctrl^D for saving:"
echo "*********************************************************************************"
cat >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$2"
for i in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$2"`;do
#cleartool find /cm_data/direcpc/ubb/ -name "$i" -print | tr -d '@' 
#cleartool find /cm_data/direcpc/ubb/ -name "$i" -print  | tr -d '@' | grep -iE ''$3'|configuration|modules|SiteCreator|Miscellaneous|Documentation|CGI|JavaScript|MultiProcessFramework|Audit|PythonScripts|ShellScripts|HTML|Lib|StyleSheets|Images'
cleartool find /cm_data/direcpc/ubb/ -name "$i" -print  | tr -d '@' | grep -i "$3" >> /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file
cleartool find /cm_data/direcpc/ubb/ -name "$i" -print  | tr -d '@' | grep -vw "EvnSpecificFiles" >> /cm_data/direcpc/ubb/build/Evn_specific_file/nonenvnfile
done 

############################Tested this Much Sucessfully for today 16/07/2020################################################
#cleartool -nm mklbtype $1    ###########Have to provide from outside #########################
for j in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/nonenvnfile`;do
#cleartool -nm mklbtype $1
cd $(echo "$j" | sed -e 's/'`basename $j`'//gi')
#cleartool mklbtype $1
cleartool mklabel $1 $j
#cp -pf $j /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/
done
#for k in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/nonenvn`;do
#cleartool -nm mklbtype $1
#done

########################For All Non Environment Specific Files ##################################
mkdir -p /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp
cat /cm_data/direcpc/ubb/build/*.sh |egrep "^[[:space:]]*cp|^cp" | awk '{print $3}' | grep -v '^\/cm_data' > nonenvn_without
cat /cm_data/direcpc/ubb/build/*.sh |egrep "^[[:space:]]*cp|^cp" | awk '{print $3 "  " $4}' | grep -w '^\/cm_data' | awk '{print $2}' > nonenvn_with
cat nonenvn_without | grep -i tman | sed 's/\.//g' | sed 'a \.\/var\/tomcat4\/webapps\/tsm\/'  |sed 's/^\///' | sed -e 'N;s/\(.*\)\n\(.*\)/\2\1/' > withtman
cat nonenvn_without | grep -i Templatepath | sed 's/\$TemplatePath/\.\/var\/local\/Template\/Default\/602/g' > withtemplate
cat nonenvn_without |  grep -i libpath | sed 's/\$LibPath/\.\/usr\/lib64\/perl5/g' > withlibpath
cat nonenvn_without |  grep -i HNS | sed 's/\$HNS/\.\/usr\/lib64\/perl5\/HNS/g' > withhns
cat /cm_data/direcpc/ubb/build/*.sh |egrep "^[[:space:]]*cp|^cp" > copyfile

#################Filtering for Directory as per Server Structure.##############################
cat nonenvn_without nonenvn_with | egrep -v 'TemplatePath|LibPath|HNS|tman' > withouttemphnslib
cat withtemplate >> withouttemphnslib
rm -f withtemplate
cat withtman >> withouttemphnslib
rm -f withtman
cat withlibpath >> withouttemphnslib
rm -f withlibpath
cat withhns >> withouttemphnslib
rm -f withhns
cat copyfile | grep -i Templatepath | sed 's/\$TemplatePath/\.\/var\/local\/Template\/Default\/602/g' > withtemplate
cat copyfile | grep -i libpath | sed 's/\$LibPath/\.\/usr\/lib64\/perl5/g' > withlibpath
cat copyfile | grep -i HNS | sed 's/\$HNS/\.\/usr\/lib64\/perl5\/HNS/g' > withhns
cat copyfile | grep -i tman | sed 's/\.//g' | sed 'a \.\/var\/tomcat4\/webapps\/tsm\/'  |sed 's/^\///' | sed -e 'N;s/\(.*\)\n\(.*\)/\2\1/' > withtman
cat copyfile | egrep -v 'TemplatePath|LibPath|HNS|tman' > copyfile1
cat withtemplate >> copyfile1
rm -f withtemplate
cat withtman >> copyfile1
rm -f withtman
cat withlibpath >> copyfile1
rm -f withlibpath
cat withhns >> copyfile1
rm -f withhns
for  i in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/nonenvnfile`;do basename $i;done > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/basename

for  i in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/nonenvnfile`;do basename $i;done > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/basename
grep -i -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/basename /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/copyfile1 > copy_nonenvn1
cat copy_nonenvn1 | egrep -v '^cp -f|cp -rf' > withoutcp
cat copy_nonenvn1 |egrep -i '^cp -f|cp -rf' > withcp
#cat withoutcp >> withcp
echo "grep -i -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/basename /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/withcp | awk '{print \$4}' > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/dir" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh

echo "grep -i -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/basename /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/withoutcp | awk '{print \$3}' > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/dir1" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh
echo "cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/dir1 >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/dir" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh
echo "cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/dir | sed -e '/^$/d' > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/dir2" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh
echo "while read dir;do mkdir -p "\$dir";done < /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/Temp/dir2" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh
cat withoutcp >> withcp
cat withcp >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh
chmod 755 /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh
sh /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh
rm -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/nonenvn1.sh

#################Remove All extra files ################################
rm -f copyfile1
rm -f copyfile
rm -f withoutcp withcp dir dir1 dir2 basename withouttemphnslib nonenvn_without nonenvn_with
tar cfpP $1_nonenvn.tar usr var etc
mv $1_nonenvn.tar /cm_data/direcpc/ubb/build
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"_nonenvn/
chmod 755 ./Temp
rm -rf ./Temp


###################################Starting for Environment Specific files######################
for k in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file`;do
cd $(echo "$k" | sed -e 's/'`basename $k`'//gi')
cleartool mklabel $1 $k
done
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"
mkdir -p ./AD
mkdir -p ./EMS_API
mkdir -p ./UI
mkdir -p ./Common
mkdir -p ./Nginx
mkdir -p  ./Temp
##############Put the logic for is the file is coming from Common folder put them in Common folder only  similarly for others###############

MAX_UI_INSTANCE=`ls -ld  /cm_data/direcpc/ubb/build/EvnSpecificFiles/"$3"/UI/* | wc -l` 
MAX_AD_INSTANCE=`ls -ld  /cm_data/direcpc/ubb/build/EvnSpecificFiles/"$3"/AD/* | wc -l`   
MAX_EMSAPI_INSTANCE=`ls -ld  /cm_data/direcpc/ubb/build/EvnSpecificFiles/"$3"/EmsAPI/* | wc -l`

cat /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file | grep -w AD > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Ad
cat /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file | grep -w EmsAPI > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/EmsApi
cat /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file | grep -w UI > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Ui
cat /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file | grep -w Common > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/common
cat /cm_data/direcpc/ubb/build/Evn_specific_file/envn_file | grep -w Nginx > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/nginx
cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/EmsApi | grep -i EmsApiParam.pm | grep -v Common > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/emsapi
cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/EmsApi | grep -i perserverconfig.pm > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/perserverconfig


###################Creating for Common folder related to Environment Specific files ############################
echo "#!/bin/bash" > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
echo "BaseEnv=/cm_data/direcpc/ubb/build/EvnSpecificFiles/"$3"" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
echo "mkdir -p /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
echo "cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
for common in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/common`; do basename $common; done > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/for
cat /cm_data/direcpc/ubb/build/SITEnvSpecificFiles.sh /cm_data/direcpc/ubb/build/PRODEnvSpecificFiles.sh /cm_data/direcpc/ubb/build/DEVEnvSpecificFiles.sh /cm_data/direcpc/ubb/build/BETAEnvSpecificFiles.sh |egrep "^[[:space:]]*cp|^cp|cp -f" > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/test
cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/test | grep -w Common | grep -i HNS | sed 's/\$HNS/\.\/usr\/lib64\/perl5\/HNS/g' > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/replaceHNS
cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/test | grep -w Common | grep -v '$\HNS' > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/withoutHNS
cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/withoutHNS >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/replaceHNS
echo "grep -i -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/for /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/replaceHNS | grep -w Common |awk '{print \$3}' > /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/dir" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
echo "while read dir;do mkdir -p "\$dir";done < /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/dir" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
echo "for d in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/dir`;do chmod 755 $d/*;done" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
echo "for dir in `cat /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/dir`;do dos2unix $dir/*;done" >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh

grep -i -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/for /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/replaceHNS | grep -w Common >> /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
chmod 755 /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
sh /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh

#########Remove All Extra files ####################
rm -rf /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/final_script.sh
rm -rf /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/withoutHNS
rm -rf /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/test
rm -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/dir
rm -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/replaceHNS
rm -f /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/for
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp

tar cfpP Common.tar usr var
mv Common.tar /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Common
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/
chmod 755 ./Temp
rm -rf ./Temp

################Similarly do for EMSAPI ##################################
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"
mkdir -p ./Temp
counter=1
while [ $counter -le $MAX_EMSAPI_INSTANCE ];do
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp
mkdir -p ./var/local
mkdir -p $HNS
while read emsapi;do
cp -pf $emsapi $HNS
done < /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/emsapi
while read perserver;do
cp -pf $perserver ./var/local
done < /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/perserverconfig
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp
dos2unix ./var/local/*
chmod 755 ./var/local/*
dos2unix $HNS/*
chmod 755 $HNS/*
tar cfpP $counter.tar var usr
mv $counter.tar /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/EMS_API/
counter=`expr $counter + 1`
chmod -R 755 ./var ./usr
rm -rf ./var ./usr
rm -rf *.tar
done

cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/
chmod -R 755 ./Temp
rm -rf ./Temp

###########################For AD################################
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"
mkdir -p ./Temp
counter=1
while [ $counter -le $MAX_AD_INSTANCE ];do
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp
mkdir -p ./var/local
while read ad;do
cp -pf $ad ./var/local
done < /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Ad
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp
dos2unix ./var/local/*
chmod 755 ./var/local/*
tar cfpP $counter.tar var
mv $counter.tar /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/AD/
counter=`expr $counter + 1`
#cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/
chmod -R 755 ./var
rm -rf ./var
rm -rf *.tar
done
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/
chmod -R 755 ./Temp
rm -rf ./Temp

#############################For UI ###################################
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"
mkdir -p ./Temp
counter=1
while [ $counter -le $MAX_UI_INSTANCE ];do
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp
mkdir -p ./var/local
while read ui;do
cp -pf $ui ./var/local
done < /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Ui
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp
dos2unix ./var/local/*
chmod 755 ./var/local/*
tar cfpP $counter.tar var
mv $counter.tar /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/UI/
counter=`expr $counter + 1`
#cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/
chmod -R 755 ./var
rm -rf ./var
rm -rf *.tar
done
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/
chmod -R 755 ./Temp
rm -rf ./Temp

###############################For Nginx####################
mkdir -p ./Temp

cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Temp
mkdir -p ./etc/nginx

while read nginx;do
cp -pf $nginx ./etc/nginx
done < /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/nginx
dos2unix ./etc/nginx/*
chmod 644 ./etc/nginx/*

tar cfpP nginx.tar etc
mv nginx.tar /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/Nginx

cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"/
chmod -R 755 ./Temp
rm -rf ./Temp

#######################Final tar file###################################
cd /cm_data/direcpc/ubb/build/Evn_specific_file/"$3"
tar cfpP "$3"_$1.tar AD EMS_API UI Common nginx
mv "$3"_$1.tar ../..
rm -rf /cm_data/direcpc/ubb/build/Evn_specific_file/*

