# Mirror_Builder
A set of scripts to rapidly deploy local mirrors of DNF/YUM repos to expedite development in an sandboxed network lab

These scripts will setup local mirrors of the selected RHEL version.
These repos will syncronize hourly once installed


*DISCLAIMER: You'll need to have your own Red Hat Subscriptions for this to work for you...

*REQUIRMENTS:  

1) Plan for at least 80GB per repo to be synced - all repos will be cloned to /var/www/html

2) A separate machine or VM is required for each RHEL version (i.e. you cannot reposync both RHEL * & RHEL9 on the same machine)

3) You will need to create your own files under /etc/yum.repos.d to enable clients to leverage these new local mirrors

4) These mirrors are for your development in-house and may not be shared publicly

5) The initial reposync operation may take several hours (be patient)
In my initial testing for RHEL7 repos, the first sync'ing took over a day and 160GB of storage 


