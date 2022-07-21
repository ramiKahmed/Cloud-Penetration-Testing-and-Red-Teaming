_check_sharepoint_existence() {
	command=$(ping  $1.sharepoint.com -c 1  2> /dev/null | grep "bytes from")
	if [[ $command ]] 
	then
	echo "[+] sharepoint subdomain found for domain: ($1)"
	echo "[+] URL --> https://$1.sharepoint.com/"
	else echo "[-] sharepoint subdomain not found for domain: ($1)"
	fi
}


_check_federationInfo() {
	command=$(curl -s https:///login.microsoftonline.com/getuserrealm.srf\?login\=$1\&\json\=1 | jq -r '.NameSpaceType')
	if [[ $command == "Managed" ]] 
	then
	echo "[+] Azure Tenant Exists for domain: ($1)"
	elif [[ $command == "Unknown" ]]
	then
	echo "[-] Azure Tenant doesn't Exist for domain: ($1)"
	fi
}

_check_OpenIDConfig() {
	command=$(curl -s https://login.microsoftonline.com/$1/v2.0/.well-known/openid-configuration | jq -r '.token_endpoint')
	if [[ $command ]] 
	then
	tenantid=$(curl -s https://login.microsoftonline.com/$1/v2.0/.well-known/openid-configuration | jq -r '.token_endpoint' | cut -d "/" -f 4)
	echo "[+] Azure Tenant Exists for domain: ($1)"
	echo "[+] Tenant ID:  ($tenantid)"
	else 
	echo "[-] Azure Tenant doesn't Exist for domain: ($1)"
	fi
}

_check_autodiscover_cnmae() {
	command=$(host -t CNAME autodiscover.$1 | grep alias)
	if [[ $command ]]
	then
	echo "[+] Azure AD Tenant found for domain: ($1)"
	echo "[+] CNAME poiting to (autodiscover.outlook.com) Exists"
	else
	echo "[-] Azure Tenant doesn't Exist for domain: ($1)"
	fi
}

_check_mx_records() {
	command=$(host -t mx $1 | awk '{print $7}' | cut -d . -f 2,3,4,5)
	if [[ $command == "mail.protection.outlook.com" ]]
	then
	mxrecord=$(host -t mx $1 | awk '{print $7}')
	echo "[+] Azure AD Tenant found for domain: ($1)"
	echo "[+] Mail is handled by ($mxrecord)"
	else
	echo "[-] Azure Tenant doesn't Exist for domain: ($1)"
	fi
}

_check_txt_records() {
	command=$(host -t txt $1 | awk '{print $5}' | cut -d : -f 2)
	if [[ $command == "spf.protection.outlook.com" ]]
	then
	echo "[+] Azure AD Tenant found for domain: ($1)"
	echo "[+] TXT record has the following spf value  ($command)"
	else
	echo "[-] Azure Tenant doesn't Exist for domain: ($1)"
	fi
}


