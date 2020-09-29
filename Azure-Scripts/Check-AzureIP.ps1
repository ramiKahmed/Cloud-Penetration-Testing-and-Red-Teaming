$IP = $args[0]
$REQUEST= wget https://www.azurespeed.com/api/ipinfo?ipAddressOrUrl=$IP
function _check() 
{


    
    if (  $REQUEST -match  "null") 
    {
        
        Write-host "[!]" -ForegroundColor red -NoNewline 
        Write-Host " IP ($IP) doesn't exist "
        
    }
    else
    {
        
        Write-host "[+]" -ForegroundColor green -NoNewline
        Write-Host " IP ($IP) exists "
        
    }
        
    
}


echo ""
_check
echo ""
