# Mirror_Builder
A set of scripts to rapidly deploy local mirrors of DNF/YUM repos to expedite development in an sandboxed network lab

These scripts will setup local mirrors of the selected RHEL version.
These repos will syncronize DAILY once installed


*DISCLAIMER: You'll need to have your own Red Hat Subscriptions for this to work for you...
            *In the case of RHEL 7 - you will also need an ELS subscription too...


*REQUIRMENTS:  

1) Plan for at least 150+ GB (or more) per repo to be synced - all repos will be cloned to /var/www/html 
Ensure /var/www/html has SIGNIFICANT space to accomodate the future size of your mirrors...

2) A separate machine or VM is required for each RHEL version (i.e. you cannot reposync both RHEL * & RHEL9 on the same machine)

3) You will need to create your own .repo files under /etc/yum.repos.d to enable your client systems to leverage these new local mirrors within your lab environments.

4) These mirrors are for your development in-house and may not be shared publicly. Ever.

5) The initial reposync operation WILL take several hours (be patient)
In my initial testing for RHEL7 repos, the first sync'ing took over a day and ~250GB of storage 
One should plan for /var to have between 350-400 GiB of space.

6) WARNING! Do not attempt to run the RHEL9 mirror and the RHEL9 EUS mirrors on the same machine as these must be kept on separate systems.

