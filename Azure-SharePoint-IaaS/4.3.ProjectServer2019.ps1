﻿<#
  Author: Michael Wharton
  Date: 12/07/2018
  Description: Configure Project Server 2019 configuration
  FileName: 4.3.ProjectServer2019.ps1
#>
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Confirm:$false -Verbose
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue  -Verbose

# Disable Loopback
New-ItemProperty HKLM:\System\CurrentControlSet\Control\Lsa -Name "DisableLoopbackCheck" -Value 1 -PropertyType DWord

Measure-command {
Write-Host -ForegroundColor Yellow "Project Server Service Configuration Started"
#######################################################
#  Setup the followig configuration values
#######################################################
$SqlServerName        = "demosp"
$WebAppName           = "Project Server 2019"
$WebAppURL            = "http://demosp.XXX2dev.local"
# $WebHostHeader        = "demosp"
$SiteRootName         = "RootSite"
$SiteRootURL          = "http://demosp.XXX2dev.local/"
$SiteHostHeader       = "demosp.XXX2dev.local"
#
$SitePwaURL           = "http://demosp.XXX2dev.local/pwa"
$ProjectServiceApp    = "Project Server Service Application"
$ProjectServicePool   = "ProjectServicePool"
$ProjectAppPool       = "ProjectAppPool"
$ProjectSiteName      = "Project Management Office"
$ProjectOwner         = "XXX2dev\mawharton"
$SecondOwner          = "XXX2dev\mwharton"
$ProjectKey           = "11111-22222-33333-44444-55555"     # use your license key
$ManagedPath          = "PWA"
$WSS_ContentDB        = "SP19_PWAContent"
$templateSTS          = Get-SPWebTemplate "STS#0" -CompatibilityLevel 14
$templatePWA          = Get-SPWebTemplate "PWA#0" -CompatibilityLevel 14
# Create credentials
$ServiceSP            = "XXX2dev\ServiceSP"   
$credServiceSP        = Import-CliXml -Path 'C:\safe\XXX2dev-ServiceSP.txt'

# create Managed Account
$ManagedAcct = Get-SPManagedAccount -Identity $ServiceSP -ErrorAction SilentlyContinue
If ($ManagedAcct -eq $null)
    {
    Write-Host -ForegroundColor Yellow "Create Managed Account: $ServiceSP "
    $ManagedAcct = New-SPManagedAccount -Credential $credServiceSP -Verbose
    }
else
    {Write-Host -ForegroundColor Green "Managed Account $ServiceSP Already Created"}

# Create Project Service Pool
$ServicePool = Get-SPServiceApplicationPool | Where-Object {$_.Name -eq $ProjectServicePool } -ErrorAction SilentlyContinue
If ($ServicePool -eq $null)
    { 
    Write-Host -ForegroundColor Yellow "Create Project Service Pool: $ProjectServicePool"
    $ServicePool = New-SPServiceApplicationPool -Name $ProjectServicePool -Account $ServiceSP -Verbose
    }
Else
    {Write-Host -ForegroundColor Green "Project Service Pool: $ProjectServicePool Already Created"}

#  Create Project Server Service and Enable Project Key
$ProjectServiceID = Get-SPServiceApplication |  Where-Object {$_.DisplayName -eq $ProjectServiceApp } -ErrorAction SilentlyContinue
If ($ProjectServiceID -eq $null)
    {
    Write-Host -ForegroundColor Yellow "Create Service Application: $ProjectServiceApp"
    $ProjectServiceID = New-SPProjectServiceApplication -Name $ProjectServiceApp -ApplicationPool $ServicePool -Proxy -verbose
    }
Else
    {Write-Host -ForegroundColor Green "Project Service Application: $ProjectServiceApp  Already Created"}

#  Enabled Project Server Services with license key
$ProjectEnabled = Get-ProjectServerLicense -Verbose
If (($ProjectEnabled).Contains("Disabled"))
    {
    Write-Host -ForegroundColor Yellow "Project Server 2019 Preview: Disabled"
    Enable-projectserverlicense -Key $ProjectKey
    Write-Host -ForegroundColor Green "Project Server 2019 Preview: NOW Enabled"
}
    Else
{
    Write-Host -ForegroundColor Green "Project Server 2019 Preview: Already Enabled"
}

# Create Web Application on root that contains project server collection
$WA = Get-SPWebApplication | Where-Object {$_.DisplayName -eq $WebAppName } 
if ($WA -eq $null)
    {
    Write-Host -ForegroundColor YELLOW "Create Project Web Application: $WebAppName"
#   $ProjectServicePool   = "ProjectServicePool2"
    $ap = New-SPAuthenticationProvider
    $WA = New-SPWebApplication -Name $WebAppName -URL $WebAppURL -port 80 `
         -AuthenticationProvider $ap  -AuthenticationMethod NTLM `
         -DatabaseName $WSS_ContentDB  -ApplicationPool $ProjectServicePool `
         -ApplicationPoolAccount (Get-SPManagedAccount $ServiceSP)  -Confirm:$false -Verbose
    }
Else
    {Write-Host -ForegroundColor Green "Project Web Application: $WebAppName  Already Created"}

# Create Root Site when PWA is defined on root
$Root = Get-SPSite -WebApplication $WebAppName  | Where-Object {$_.URL -eq $SiteRootURL } 
if ($Root -eq $null)
    {
    Write-Host -ForegroundColor Yellow "Create Root Site: $SiteRootURL "
    New-SPSite -url $SiteRootURL -Name 'Rootsite' `
             -Template STS#0 -OwnerAlias $ProjectOwner -Verbose 
    Start $SiteRootURL -Verbose
    # sets Permissions groups
    # Start "$SiteRootUrl/_layouts/permsetup.aspx" -verbose
    }
else
    {
    Write-Host -ForegroundColor Green "Root Site: $SiteRootURL already Created"
    }

# Provision PWA 
$PWA = Get-SPSite | Where-Object {$_.URL -eq $SitePwaURL } 
if ($PWA -eq $null)
    {
    Write-Host -ForegroundColor Green "Creating Project Site: $SitePwaURL"
    New-SPManagedPath $ManagedPath -WebApplication $WebAppURL -Explicit
    $PWA = New-SPSite -Url $SitePwaURL -Name $ProjectSiteName -Template PWA#0 `
         -OwnerAlias $ProjectOwner -Verbose 
    Enable-SPFeature PWASITE -Url $SitePwaURL -Verbose 
    Set-SPProjectPermissionMode -Url $SitePwaURL -Mode ProjectServer -Verbose
    Start $SitePwaURL
    }
else
    {
    Write-Host -ForegroundColor Green "Project Site: $SitePwaURL Already Created"
    }
Write-Host -ForegroundColor Yellow "Project Server Service Configuration Finished"
}

