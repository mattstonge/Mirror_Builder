# myRHEL9mirror.sh
#
# creates a local mirror of the 3 standard RHEL9 repos
# Red Hat Subscription is required
#
# MIT License ( https://opensource.org/license/mit/ )
#
# v1.2  9/28/2023
##################################


##################################
#
# Global Variables
#
##################################

# set this number to the latest release version number OR the 
# release version you wish to stop at
MYRELVER=9.2

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
	MYOUTPUT="$LOGGERPREF Intial Sync of BaseOS Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
	
	reposync -p /var/www/html --download-metadata --repoid=rhel-9-for-x86_64-baseos-rpms
	
	MYOUTPUT="$LOGGERPREF Intial Sync of AppStream Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

	reposync -p /var/www/html --download-metadata --repoid=rhel-9-for-x86_64-appstream-rpms

	MYOUTPUT="$LOGGERPREF Intial Sync of Supplementary Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

	reposync -p /var/www/html --download-metadata --repoid=rhel-9-for-x86_64-supplementary-rpms


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

  cp 0reposync-hourlyR9 /etc/cron.hourly/

	chmod +x /etc/cron.hourly/0reposync-hourlyR9

	AllDone

}


function AllDone()
{
	MYOUTPUT="$LOGGERPREF All Done... Enjoy "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

}




CheckRegStatus
