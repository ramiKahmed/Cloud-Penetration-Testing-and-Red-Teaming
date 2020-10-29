# Cloud-Penetration-Testing-and-Red-Teaming
Tools, Resources &amp; Helpful Tips 


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


