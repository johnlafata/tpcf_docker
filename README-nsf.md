# using nfs service with docker image
create virtual machine nfs server. - allow ssh access

## install nfs on ubuntu server
setup nfs server as in the following document
### reference:
https://documentation.ubuntu.com/server/how-to/networking/install-nfs/index.html

###  install instructions for ubuntu server setup:
```
sudo apt install nfs-kernel-server
sudo systemctl start nfs-kernel-server.service

mkdir /nfs
mkdir /nfs/test
Ensure /etc/exports has entry for /nfs

systemctl restart nfs-kernel-server
```

## ensure nfs service is available
```
cf m
```
expected response:
```
Getting all service offerings from marketplace in org test / space test-space as admin...

offering         plans      description                                                                              broker
app-autoscaler   standard   Scales bound applications in response to load                                            app-autoscaler
nfs              Existing   Existing NFSv3 and v4 volumes (see: https://code.cloudfoundry.org/nfs-volume-release/)   nfsbroker
smb              Existing   Existing SMB shares (see: https://code.cloudfoundry.org/smb-volume-release/)             smbbroker
credhub          default    Stores configuration parameters securely in CredHub                                      credhub-broker
````

## if it needs to be enabled, use admin account and execute
```
cf enable-service-access nfs
```
response
```
## check if service is enabled
```

## verify target mount point exists
```
cf ssh tpcf_docker
d27268e4-c7d1-4f84-6b59-edaa:~# ls /opt
d27268e4-c7d1-4f84-6b59-edaa:~# cd /opt
d27268e4-c7d1-4f84-6b59-edaa:/opt# ls
d27268e4-c7d1-4f84-6b59-edaa:/opt# exit
exit
```

in above, nothing was returned in ls of /opt folder. This is expected as the mount point has not been created yet.

## bind to nfs service

## at desktop commandline create service
```
cf create-service nfs Existing nfs-mount -c '{"share":"192.168.86.6/nfs/test"}'
cf bind-service tpcf_docker nfs-mount -c '{"uid":"1000","gid":"1000","mount":"/opt/test"}'
cf restage tpcf_docker
```
response:
```
This action will cause app downtime.

Restaging app tpcf_docker in org test / space test-space as admin...

Staging app and tracing logs...
   Cell 485c547f-fd96-4299-85ef-d8c07fe8288b creating container for instance 5ebcc968-93ed-4a29-9a59-c79ff0de5d24
   Security group rules were updated
   Cell 485c547f-fd96-4299-85ef-d8c07fe8288b successfully created container for instance 5ebcc968-93ed-4a29-9a59-c79ff0de5d24
   Staging...

Restarting app tpcf_docker in org test / space test-space as admin...

Stopping app...

Waiting for app to start...

Instances starting...
Instances starting...

name:              tpcf_docker
requested state:   started
routes:            tpcf_docker.apps.agi-explorer.com
last uploaded:     Thu 15 May 09:29:38 EDT 2025
stack:             
docker image:      jltestcr.azurecr.io:443/alpine-bash:latest

type:           web
sidecars:       
instances:      1/1
memory usage:   1024M
     state     since                  cpu    memory     disk       logging        cpu entitlement   details
#0   running   2025-05-15T13:29:43Z   0.0%   0B of 1G   0B of 2G   0B/s of 0B/s   0.0%              
```
## verify nfs mount point
```
 cf ssh tpcf_docker 
f8a7d6e2-e73f-4bd8-6cac-3ca6:~# ls /opt
test
f8a7d6e2-e73f-4bd8-6cac-3ca6:~# exit
exit
```

/opt folder now has /test folder within it. This is the mount point for the nfs share.
