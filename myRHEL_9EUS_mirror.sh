# myRHEL_9EUS_mirror.sh
#
# creates a local mirror of the standard RHEL9 EUS repos
# Red Hat Subscription is required
#
# MIT License ( https://opensource.org/license/mit/ )
#
# v1.0  11/14/2024
# 
#
# WARNING!!!!!! WARNING!!!!!!
# DO NOT RUN THIS EUS MIRROR ON TOP OF A 
# SERVER ALSO RUNNING A FAST STREAM MIRROR!!!
##################################


##################################
#
# Global Variables
#
##################################

# set this number to the latest release version number OR the 
# release version you wish to stop at
# OPTIONS for this setting:  9.0 / 9.2 / 9.4 / 9.6 / 9.8
# edit to your desired RHEL 9 EUS version
MYRELVER=9.4

# Log entry preface - for easy searches
LOGGERPREF="[Mirror_Builder] "


##################################
#
# Functions
#
##################################


function CheckRegStatus()
{
	MYOUTPUT="$LOGGERPREF  Checking on Subscription Status"
	echo $MYOUTPUT
	echo $MYOUTPUT | logger
	SUBSTATUS="$(subscription-manager status | grep Overall )"
	echo $SUBSTATUS
	echo "$LOGGERPREF  $SUBSTATUS" | logger

	InstallSoftware
}

function InstallSoftware()
{
	MYOUTPUT="$LOGGERPREF  Installing Software: yum-utils "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
	dnf install -y yum-utils
	MYOUTPUT="$LOGGERPREF  Setting Release Version $MYRELVER"
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
	subscription-manager release --set $MYRELVER
	MYOUTPUT="$LOGGERPREF Installing Software: httpd "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger	
	dnf install -y httpd

	InitialReposync
}

function InitialReposync()
{
	MYOUTPUT="$LOGGERPREF Intial Sync of BaseOS EUS Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
	
	reposync -p /var/www/html --download-metadata --repoid=rhel-9-for-x86_64-baseos-eus-rpms
	
	MYOUTPUT="$LOGGERPREF Intial Sync of AppStream EUS Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

	reposync -p /var/www/html --download-metadata --repoid=rhel-9-for-x86_64-appstream-eus-rpms

	MYOUTPUT="$LOGGERPREF Intial Sync of Supplementary EUS Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

	reposync -p /var/www/html --download-metadata --repoid=rhel-9-for-x86_64-supplementary-eus-rpms

	MYOUTPUT="$LOGGERPREF Intial Sync of CodeReady Builder EUS Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

	reposync -p /var/www/html --download-metadata --repoid=codeready-builder-for-rhel-9-x86_64-eus-rpms


	InitializingWeb
}

function InitializingWeb()
{
	MYOUTPUT="$LOGGERPREF Intializing Web Services "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

	systemctl enable --now httpd.service
	
	MYOUTPUT="$LOGGERPREF Configuring Firewall for HTTP "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
	
	firewall-cmd --add-service=http --permanent
	firewall-cmd --reload

	CronMaster
}

function CronMaster()
{
	MYOUTPUT="$LOGGERPREF Building a cront.hourly file "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

  cp 0reposyncR9EUS /etc/cron.daily/

	chmod +x /etc/cron.daily/0reposyncR9EUS

	AllDone

}


function AllDone()
{
	MYOUTPUT="$LOGGERPREF All Done... Enjoy "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

}




CheckRegStatus
