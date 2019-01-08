# Tools for Managing SharePoint/Project Server on premise

##### I am currently in the process of organizing and sanitizing my powershell tools and scripts for managing both SharePoint and project Server.  The most exciting project being worked on now, is the Azure-SharePoint-IaaS environment.  Primary of development and testing of SharePoint and Project Server enviroment, it can save an organization a lot of money by building those environment in the cloud and turning them on as needed.

## Azure-SharePoint-IaaS
  * 0.0 PrepUsernamePassword.ps1 - optional password files to eliminate passwords in scripts 
  * 1.0 CreateVNET.ps1 - create VNET using script -- IN PROCESS
  * 2.0 CreateAD-VM.ps1 - create Active Directory VM -- IN PROCESS
  * 2.1 ActiveDirectory-Post.txt - steps to create Active Directory - IN PROCESS
  * 3.0 CreateSqlServerVmOnAzure.ps1 - create SQL Server VM
  * 3.1 SqlServer-Post.txt - Post steps after SQL Server VM is create, ie join domain, etc
  * 4.0 CreateSharePointServerOnAzureVM.ps1 - create SharePoint VM
  * 4.1 SharePoint-Post.txt - post steps after SharePoint Server VM is created, ie join domain, etc
  * 4.2 ConfigurationWizard.ps1 - SharePoint configuration wizard as PowerShell command
  * 4.3 ProjectServer2019.ps1 - Create SharePoint/Project Server site
  * 5.0 CreateWindows10-VM.ps1 - Create Windows 10 and load developer tools 
  * 5.1 Windows10-Post.txt  - Steps after Windows 10 create.  ie join domain, etc

## Azure-Tools - Miscellanous tools for Azure
  * RDPResource.ps1 unchecks the "ALlow connections only from computers running Remote Desktop with Network Level Authentication.
  Update to windows security lock VMs from connecting.  If this fails, copy the four lines and run in Console PS mode from Portal.
## Migration-SharePoint-2010-2013-Tools
  * Migrate2010-2013.ps1
  * Pre-Migrate2010-to-2013.ps1
  * TBD currently sanitize from my tool box
## Migration-SharePoint-2013-2016-Tools
  * File to be added soon.txt (currently sanitize from my tool box)
## Migration-SharePoint-2016-2016-Tools
  * File to be added soon.txt (currently sanitize from my tool box)
## PowerShell Tools
  * FindSkuOfferPublisher.ps1  use to find SKU, OFfers, publisher and version for creating Azure Vms
## Project2016Reports
  * File to be added soon.txt (currently sanitize from my tool box)
## ProjectServer-SharePoint-2013-Tools
  * File to be added soon.txt (currently sanitize from my tool box)
## ProjectServer-SharePoint-2016-Tools
  * File to be added soon.txt (currently sanitize from my tool box)
## ProjectServer-SharePoint-2019-Tools
  * File to be added soon.txt (currently sanitize from my tool box)
## SharePoint-2019-Tools
  * File to be added soon.txt (currently sanitize from my tool box)

## Michael Wharton, Project MVP
* http://myprojectexpert.com 
* http://whartoncomputer.com
