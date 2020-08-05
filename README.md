# userAuthenticationPhoneMethod
This repo contains two PowerShell scripts that can be used to set the user's authentication phone method in Azure Active Directory using Microsoft Graph.

The main difference between the two scripts is the method used to access Microsoft Graph:

- MicrosoftGraphPSModule.ps1 uses the "Get-MgUserAuthenticationPhoneMethod" cmdlet, which is available as part of the "Microsoft.Graph.Identity.AuthenticationMethods" module

- MicrosoftGraphREST.ps1 uses the "Invoke-RestMethod" cmdlet to call HTTP methods against the Microsoft Graph API

Both scripts require an Azure AD Application Service Principal that is assigned any of the following roles:

- Authentication Administrator 
- Privileged Authentication Administrator
- Global Admin

In addition to the above roles, the Azure AD application must be granted the following API Permissions:

- UserAuthenticationMethod.Read 
- UserAuthenticationMethod.Read.All
- UserAuthenticationMethod.ReadWrite
- UserAuthenticationMethod.ReadWrite.All
