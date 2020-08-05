# Configuring the User Authentication Phone Method in Azure AD using Microsoft Graph
This repo contains two PowerShell scripts that can be used to set the user's authentication phone method in Azure Active Directory using Microsoft Graph.

The main difference between the two scripts is the method used to access Microsoft Graph:

- MicrosoftGraphPSModule.ps1 uses the "Get-MgUserAuthenticationPhoneMethod" cmdlet, which is available as part of the "Microsoft.Graph.Identity.AuthenticationMethods" module

- MicrosoftGraphREST.ps1 uses the "Invoke-RestMethod" cmdlet to call HTTP REST methods against the Microsoft Graph API

Both scripts require the registration of an Azure AD Application and assigning its Service Principal at least one of the following roles:

- Authentication Administrator 
- Privileged Authentication Administrator
- Global Admin

In addition to the above roles, the Azure AD application must be granted the following API Permissions:

- UserAuthenticationMethod.Read 
- UserAuthenticationMethod.Read.All
- UserAuthenticationMethod.ReadWrite
- UserAuthenticationMethod.ReadWrite.All

For more information, please refer to the following article: https://docs.microsoft.com/en-us/graph/authenticationmethods-get-started
