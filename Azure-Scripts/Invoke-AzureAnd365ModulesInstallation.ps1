
function Invoke-AzureAnd365ModulesInstallation() {

    [CmdletBinding()]
    param(
        
        [Parameter(Mandatory=$false)]
        [switch]$All,
        [Parameter(Mandatory=$false)]
        [switch]$Az,
        [Parameter(Mandatory=$false)]
        [switch]$AzureAD,
        [Parameter(Mandatory=$false)]
        [switch]$AzureADPreview,
        [Parameter(Mandatory=$false)]
        [switch]$MSOnline,
        [Parameter(Mandatory=$false)]
        [switch]$Teams,
        [Parameter(Mandatory=$false)]
        [switch]$PowerApps,
        [Parameter(Mandatory=$false)]
        [switch]$Exchange,
        [Parameter(Mandatory=$false)]
        [switch]$Sharepoint,
        [Parameter(Mandatory=$false)]
        [switch]$AzureCLI,
        [Parameter(Mandatory=$false)]
        [switch]$AIPService,
        [Parameter(Mandatory=$false)]
        [switch]$MSCommerce,
        [Parameter(Mandatory=$false)]
        [switch]$MicrosoftGraphIntune,
        [Parameter(Mandatory=$false)]
        [switch]$MicrosoftGraph,
        [Parameter(Mandatory=$false)]
        [switch]$MicrosoftPowerBIMgmt,
        [Parameter(Mandatory=$false)]
        [switch]$MicrosoftPowerAppsPowerShell,
        [Parameter(Mandatory=$false)]
        [switch]$Microsoft365DSC,
        [Parameter(Mandatory=$false)]
        [switch]$AADRM
        
        
        
        

    )


        # Variables 
        $elevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        $Modules = @(
            "Az",
            "AzureADPreview",
            "AzureAD",
            "MSOnline",
            "AzureRM",
            "AADRM",
            "ExchangeOnlineManagement",
            "Microsoft.Online.SharePoint.PowerShell",
            "SharePointPnPPowerShellOnline",
            "PnP.Powershell",
            "MicrosoftTeams",
            "Microsoft.PowerApps.Administration.PowerShell",
            "AIPService",
            "MSCommerce",
            "Microsoft.Graph.Intune",
            "Microsoft.Graph",
            "MicrosoftPowerBIMgmt",
            "Microsoft.PowerApps.PowerShell",
            "Microsoft365DSC"

        )

    ######### functions #########
    

    function ShowStatus($modulename) {
        Write-host "[+] " -ForegroundColor Green -NoNewline
        write-host "Installing " -NoNewline
        write-host "$modulename " -ForegroundColor DarkGreen -NoNewline
        write-host "Module .." 
    }

    function ShowError($modulename) {
        Write-host "[!] " -ForegroundColor Red -NoNewline
        write-host "Installing " -NoNewline
        write-host "$modulename " -ForegroundColor red -NoNewline
        write-host "Module failed .." 
    }

    function Invoke-ModuleInstallation {

        [CmdletBinding()]
        param(
            [Parameter(Mandatory=$true, HelpMessage='Powershell module you wish to install ')]
            [string]$Module
            
        )

        if ($(Get-Module $Module -ListAvailable)) {
            write-host "[+] " -NoNewline -ForegroundColor green
            write-host "Module [ " -NoNewline
            write-host $Module -nonewline -ForegroundColor yellow
            write-host " ] already installed "

        }

        else {
            try{
                ShowStatus($Module)
                install-module $Module -Force -AllowClobber  -erroraction SilentlyContinue
            }
            catch{
                ShowError($Module)
            }
             
        }


    }

    function init_settings {

        if ($(Get-Module PowerShellGet -ListAvailable)) {
    
            if ((Get-PSRepository).Name  -eq "PSGallery" -and (Get-PSRepository).InstallationPolicy  -eq "Trusted" ) { 
            Write-Host "[!] " -NoNewline -ForegroundColor yellow
            Write-Host "PSGallery already set to Trusted, moving on ....." 
            
            }
            else {
                 Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
            }
        
        }
        else {
        Install-Module -Name PowerShellGet -Force 
        if ((Get-PSRepository).Name  -eq "PSGallery" -and (Get-PSRepository).InstallationPolicy  -eq "Trusted" ) { 
            Write-Host "[!] " -NoNewline -ForegroundColor yellow
            Write-Host "PSGallery already set to Trusted, moving on ....." 
            
            }
            else {
                 Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
            }
        }
    
    
    }

    function install_azcli {
        if((get-command az)) {
            write-host "[+] " -NoNewline -ForegroundColor green
            write-host "Tool  [ " -NoNewline
            write-host "Azure CLI ( az ) " -nonewline -ForegroundColor yellow
            write-host " ] already installed "
        }
        else {
            showstatus("Azure CLI")
            Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
            Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
        }
        
    
    }



    if($elevated) {

        

        if($All) {
            
            try {
                init_settings
                foreach ($Module in $Modules) {
                    Invoke-ModuleInstallation -Module $Module
                }
                install_azcli
            }

            catch {
                write-host "[!] " -NoNewline -ForegroundColor Red
                Write-Host " Couldn't perform the installation .... EXITING"
                exit

            }
         
        }

        if($Az) {
            Invoke-ModuleInstallation -Module Az
        }

        if($AzureAD) {
            Invoke-ModuleInstallation -Module AzureAD
        }

        if($AzureADPreview) {
            Invoke-ModuleInstallation -Module AzureADpreview
        }

        if($MSOnline) {
            Invoke-ModuleInstallation -Module MSOnline
        }

        if($Exchange) {
            Invoke-ModuleInstallation -Module ExchangeOnlineManagement
        }
        
        if($sharepoint) {
            Invoke-ModuleInstallation -Module Microsoft.Online.SharePoint.PowerShell
            Invoke-ModuleInstallation -Module PnP.Powershell
        }

        if($Teams) {
            Invoke-ModuleInstallation -Module MicrosoftTeams
        }

        if($PowerApps) {
            Invoke-ModuleInstallation -Module Microsoft.PowerApps.Administration.PowerShell
        }

        if($AIPService) {
            Invoke-ModuleInstallation -Module AIPService
        }

        if($MicrosoftGraphIntune) {
            Invoke-ModuleInstallation -Module Microsoft.Graph.Intune
        }
        
        if($MSCommerce) {
            Invoke-ModuleInstallation -Module MSCommerce
        }

        if($MicrosoftGraph) {
            Invoke-ModuleInstallation -Module Microsoft.Graph
        }

        if($MicrosoftPowerBIMgmt) {
            Invoke-ModuleInstallation -Module MicrosoftPowerBIMgmt
        }

        if($MicrosoftPowerAppsPowerShell) {
            Invoke-ModuleInstallation -Module Microsoft.PowerApps.PowerShell
        }

        if($Microsoft365DSC) {
            Invoke-ModuleInstallation -Module Microsoft365DSC
        }
        
        if($AADRM) {
            Invoke-ModuleInstallation -Module AADRM
        }

        if($AzureCLI) {
            if((get-command az)) {
                write-host "[+] " -NoNewline -ForegroundColor green
                write-host "Tool  [ " -NoNewline
                write-host "Azure CLI ( az ) " -nonewline -ForegroundColor yellow
                write-host " ] already installed "
            }
            else {
                showstatus("Azure CLI")
                Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
                Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
            }
        }

        



    }

    else {
        write-host "[!] " -NoNewline -ForegroundColor Red
        Write-Host " Powershell session with administrative rights is required .... EXITING"
        exit
    }

}