script /var/tmp/yum_session_`uname -n`.out
##############removing all Default external repositry#############
rm -rf /etc/yum.repos.d/rhel-source.repo
#############Disabling Subscription Manager#################
subscription-manager unregister
subscription-manager remove –all
subscription-manager config –rhsm.manage_repos=0
sed -i -e ‘s/enabled=1/enabled=0/g’ /etc/yum/pluginconf.d/subscription-manager.conf
sed -I -e ‘s/enabled=1/enabled=0/g’ /etc/yum/pluginconf.d/enabled_repos_upload.conf
yum clean all
rm -rf /var/cache/yum/*
rm -rf /etc/yum.repos.d/redhat.repo
rm -rf /etc/yum.repos.d/wfpatch.repo
###########Check SSL Certificate ####################
list=/etc/ssl/certs/wf-cabundle.crt
if [ -f "$list" ];then
ls -la /etc/ssl/certs/wf-cabundle.crt
else
wget link you can provide here
fi

##############Check Server is Prod or non prod ###################
out=`grep -i use /opt/opsware/agent_tools/get_info.sh`
if [ $out -eq prod ];then
echo "Server is production"
else
echo "Server is Non-prod"
fi

##################manually create repofile ##################
name=`cat /etc/redhat-release   | awk '{print $1}'`
version=`cat /etc/redhat-release   | awk '{print $1 " " $4}' | cut -d" " -f2 | cut -c1`
RHEL_BASE_NAME=WF-`echo $name-$version`-CV-
month=$1
year=`date +%Y`
Maint_Release=$($year_$month-OS)
touch /etc/yum.repos.d/wfpatch.repo
echo "[$RHEL_BASE_NAME$Maint_Release]" >> /etc/yum.repos.d/wfpatch.repo
echo "metadata_expire =1" >> /etc/yum.repos.d/wfpatch.repo
echo "baseurl= https://......................................../....../$RHEL_BASE_NAME" >> /etc/yum.repos.d/wfpatch.repo
echo "ui_repoid_vars = releasever basearch" >> /etc/yum.repos.d/wfpatch.repo
echo "sslverify = 1" >> /etc/yum.repos.d/wfpatch.repo
echo "name = Yum repo for $Maint_Release_Official_Name" >> /etc/yum.repos.d/wfpatch.repo
echo "gpgkey =file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> /etc/yum.repos.d/wfpatch.repo
echo "enabled =1" >> /etc/yum.repos.d/wfpatch.repo
echo "sslcacert = /etc/ssl/certs/wf-cabundle.crt" >> /etc/yum.repos.d/wfpatch.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/wfpatch.repo

################Verify Yum Repo ################
yum –disablerepo=*
yum --enablerepo=WF-RHEL-*
yum repolist all

###################Patching #################
/usr/bin/yum –disablerepo =*
yum --enablerepo=WF-RHEL-*
yum update -y >> /home/username/patch.log
#cat /home/username/patch.log | grep -i error
if [ $? -ne 0 ];then
echo "patching has not been done properly"
else
echo -p "patching has done properly."
if [ $? -ne 0 ];then
echo "patching has not been done properly"
else
echo "patching has done properly."
read -p "Contiue to reboot (y/n)?" Cont
if [ "$Cont" = "y" ];then
reboot
else
exit 0
fi
fi
