

{ 
    "share": "\\WIN-RG8AT7I0F15\Users\Administrator\Documents" 
}

## default mount point
"/var/vcap/data"

### smb access troubleshooting references
### 
https://forums.opensuse.org/t/samba-problem-no-workgroup-available/141882/9 

https://docs.oracle.com/en/operating-systems/solaris/oracle-solaris/11.4/manage-smb/how-configure-smb-server-workgroup-mode.html

### powershell cli commands
https://learn.microsoft.com/en-us/powershell/module/smbshare/get-smbconnection?view=windowsserver2025-ps
### list smb connections
Get-SmbConnection 
### list smb shares
Get-SmbShare

### samba client
https://www.redhat.com/en/blog/samba-file-sharing#:~:text=Create%20a%20shared%20location,names%20when%20testing%20and%20troubleshooting.

## install samba on mac
brew install samba 

```

sudo cat >/opt/homebrew/etc/smb.conf <<EOF
[sambashare]
   path = /sambashare
   read only = No
EOF
```

smbclient -L //WIN-RG8AT7I0F15/Users/Administrator/Documents -U WIN-RG8AT7I0F15\\administrator

smbclient -N \\\\192.168.86.11\\Users\\Administrator\\Documents

smbclient -L //192.168.86.11/C$ -U WIN-RG8AT7I0F15\\administrator

### on server, add computer to workgroup
```powershell
Add-Computer -WorkGroupName "Rocky"
```

### lists shares
smbclient -L //192.168.86.11/C$ -U Rocky\\administrator

### connect to share to test - can't write to share currently
smbclient //192.168.86.11/C$ -U Rocky\\administrator


### 
# troubleshooting smb access 
bosh ssh to diego cell

### find logs 
ls /var/vcap/sys/log/smbdriver/
cat /var/vcap/sys/log/smbdriver/pre-start.stderr.log

### test mount to share on diego cell
```
mkdir /temp
sudo mount -t cifs "//192.168.86.11/C$" /temp   -o username="Administrator",password="password",domain="Rocky"
sudo umount /temp
```

cd /var/vcap/data/volumes/smb
cat driver-state.json | grep <instance guid from cf env>
