# Cloud-Penetration-Testing-and-Red-Teaming
Tools, Resources &amp; Helpful Tips


![](Images/cloudInfraHacking.png)

## Install required modules for Azure using powershell

```
Invoke-AzureAnd365ModulesInstallation -All
```
## All-in-one

### Cloud Existence Discovery
* **Get Federation info for target domain by quering** (https://login.microsoftonline.com/) - check tenant existence

```
_check_federationInfo domain.com
```

* **Get OpenID config by quering** (https://login.microsoftonline.com/tenantname/v2.0/.well-known/openid-configuration) - check tenant existence & retrieve Tenant ID

```
_check_OpenIDConfig domain.com
```

* **Get OpenID config using aadinternal’s get-aadintopenidconfiguration** - (https://github.com/Gerenios/AADInternals)
```
invoke-aadintreconasoutsider -domainname domain.com 2> $null
```

* **Recon using aadinternal’s invoke-aadintreconasoutsider** - (https://github.com/Gerenios/AADInternals)
```
invoke-aadintreconasoutsider -domainname domain.com 2> $null
```

* **Recon using aadinternal’s Get-AADIntLoginInformation** - (https://github.com/Gerenios/AADInternals)
```
Get-AADIntLoginInformation -Domain domain.com
```

* **Recon using aadinternal’s get-aadinttenantdomains** - retrieve tenant domains 
```
get-aadinttenantdomains -domain domain.com
```

* **Recon using netspi’s Get-FederationEndpoint** - https://raw.githubusercontent.com/NetSPI/PowerShell/master/Get-FederationEndpoint.ps1
```
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/NetSPI/PowerShell/master/Get-FederationEndpoint.ps1'); Get-FederationEndpoint -domain domain.com
```

* **Recon using Invoke-Get-AADIntTenantDomains  + Get-FederationEndpoint** - ( you can run this command if you have multiple domains returned with invoke-aadintreconasoutsider )
```
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/NetSPI/PowerShell/master/Get-FederationEndpoint.ps1') ; Get-AADIntTenantDomains  domain.com |  % { Get-FederationEndpoint -domain $_ } | ft -wrap -autosize
``` 

* **Query DNS records for sharepoint** - (https://companydomain.sharepoint.com/)  
```
_check_sharepoint_existence <companynameonly>
```
 
* **Recon using Oh365UserFinder** - (https://github.com/dievus/Oh365UserFinder)
 ```
 python3 oh365userfinder.py -d domain.com
 ```

* **Recon using o365chk.py** - (https://github.com/nixintel/o365chk)
```
python3 o365chk.py -d domain.com
```

* **Recon using offensive_azure's outsider_recon.py** - (https://github.com/blacklanternsecurity/offensive-azure/blob/main/offensive_azure/Outsider_Recon/outsider_recon.py)
```
python3  ~/tools/offensive-azure/offensive_azure/Outsider_Recon/outsider_recon.py domain.com   -o outfile
```

* **Check CNAME record for the autodiscover endpoint of the target domain** 
```
_check_autodiscover_cnmae domain.com
```

* **Query the MX record for the target domain** -  if the MX record is set to ( companydomain-com.mail.protection.outlook.com ) then the target company is using O365 
```
_check_mx_records domain.com
(Resolve-DnsName -name domain.com -Type MX ).NameExchange # requires aadinternals module - install-module aadinternals -force 
```

* **Query the TXT record for the target domain** -  if the TXT record includes  (mail.protection.outlook.com), then the target company is using O365 
```
_check_txt_records domain.com
(Resolve-DnsName -name domain.com -Type TXT).strings # requires aadinternals module - install-module aadinternals -forc
```

* **Recon using trevorspray.py** - (https://github.com/blacklanternsecurity/TREVORspray)
```
python trevorspray.py --recon domain.com 
```




### Cloud Assets Discovery 

*Spidering websites to extract cloud assets*

- using gospider 
```
gospider -d 0 -a -w -r   --js --sitemap --robots -q  -u web -s http://domain.com | sed 's|.*]||' | awk '{print $2}' | egrep -i 'azure|azurewebsites.net|cloudapp.net|core.windows.net|awsapps.com|s3.amazonaws.com|s3|blob|amazonaws.com|digitaloceanspaces|aliyuncs.com|googleapis'
```
- using lolruslove.py
```
python lolruslove.py http://domain.com  2>&1 | grep  -i url | cut -d"]" -f 2 | egrep -i 'azure|azurewebsites.net|cloudapp.net|core.windows.net|awsapps.com|s3.amazonaws.com|s3|blob|amazonaws.com|digitaloceanspaces|aliyuncs.com|googleapis' | awk '{print $2}'
```
- using shodan 
```
shodan download out-file 'hostname:<domain>' --limit -1 && sudo gunzip out-file.json.gz && sudo shodan parse --fields ip_str,port,org,hostnames,location.country_name,org,domains out-file.json | egrep -i 'azure|azurewebsites.net|cloudapp.net|core.windows.net|awsapps.com|s3.amazonaws.com|s3|blob|amazonaws.com|digitaloceanspaces|aliyuncs.com|googleapis'
```

## Azure 

## Searching for keys,secrets and others locally ( on-premise ) 
 * look for users who use Azure by searching for .Azure dir in their profiles 
 ```
 Get-ChildItem -Path C:\users\* -Recurse -Filter ".azure" | % { write-host $_.fullname -ForegroundColor green }
 ```


 
 ## Content Discovery for cloud Assets
### YAML rules to use with Nuclei Scanner 

  * Azure-Cloud-Storage-detect.yaml
  
    ```
    cat urls | nuclei -t Azure-Cloud-Storage-detect.yaml 
    ```
  * Azure-Cloud-Websites-detect.yaml 
  
    ```
    cat urls | nuclei -t Azure-Cloud-Websites-detect.yaml
    ```
-----------------------------
## AWS 

## Searching for keys,secrets and others locally ( on-premise ) 
 * look for users who use AWS by searching for .aws dir in their profiles 
 ```
 Get-ChildItem -Path C:\users\* -Recurse -Filter ".aws" | % { write-host $_.fullname -ForegroundColor green }
 ```

### YAML rules to use with Nuclei Scanner 

  * amazon-s3-detect.yaml
  
     ```
     cat urls | nuclei -t amazon-s3-detect.yaml
     ```

  * amazon-LB.yaml
  
    ```
    cat urls | nuclei -t amazon-LB.yaml
    ```
  ---------------------------
## all-in-one

## Searching for keys,secrets and others locally ( on-premise ) 

 ```
 Get-ChildItem -Path C:\users\* -Recurse -Include ('*.azure','*.aws')  | % { write-host $_.fullname -ForegroundColor green }
 ```
 
 
 ## Awesome github repos 
 * https://github.com/Kyuu-Ji/Awesome-Azure-Pentest 


