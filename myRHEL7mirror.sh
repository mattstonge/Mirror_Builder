# myRHEL7mirror.sh
#
# creates a local mirror of the 5 standard RHEL7 repos
# will also mirror ELS repos once available and subscribed
# Red Hat Subscriptions are required for main repos and ELS
#
# MIT License ( https://opensource.org/license/mit/ )
#
# v1.1  6/30/2024
##################################


##################################
#
# Global Variables
#
##################################

# set this number to the latest release version number OR the 
# release version you wish to stop at
# to be able to leverage ELS the version of RHEL must be at the final release
MYRELVER=7.9

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
        yum install -y yum-utils
        MYOUTPUT="$LOGGERPREF  Setting Release Version $MYRELVER"
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
        subscription-manager release --set $MYRELVER
        MYOUTPUT="$LOGGERPREF Installing Software: httpd "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
        yum install -y httpd

        InitialReposync
}

function InitialReposync()
{
        MYOUTPUT="$LOGGERPREF Intial Sync of BaseOS Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

        reposync -p /var/www/html --download-metadata --repoid=rhel-7-server-rpms

        MYOUTPUT="$LOGGERPREF Intial Sync of Common Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

        reposync -p /var/www/html --download-metadata --repoid=rhel-7-server-rh-common-rpms

        MYOUTPUT="$LOGGERPREF Intial Sync of Optional Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

        reposync -p /var/www/html --download-metadata --repoid=rhel-7-server-optional-rpms

        MYOUTPUT="$LOGGERPREF Intial Sync of Supplementary Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

        reposync -p /var/www/html --download-metadata --repoid=rhel-7-server-supplementary-rpms

        MYOUTPUT="$LOGGERPREF Intial Sync of Software Collections Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

        reposync -p /var/www/html --download-metadata --repoid=rhel-server-rhscl-7-rpms

        MYOUTPUT="$LOGGERPREF Intial Sync of RHEL 7 Server ELS  Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
 
        reposync -p /var/www/html --download-metadata --repoid=rhel-7-server-els-rpms


        MYOUTPUT="$LOGGERPREF Intial Sync of RHEL 7 Server Optional ELS Repo "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger
 
        reposync -p /var/www/html --download-metadata --repoid=rhel-7-server-els-optional-rpms


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

        MYOUTPUT="$LOGGERPREF Building a crontab file"
        echo $MYOUTPUT
        echo $MYOUTPUT | logger


 	cp 0reposyncR7 /etc/cron.daily/

        chmod +x /etc/cron.daily/0reposyncR7

        AllDone

}


function AllDone()
{
        MYOUTPUT="$LOGGERPREF All Done... Enjoy "
        echo $MYOUTPUT
        echo $MYOUTPUT | logger

}


CheckRegStatus
