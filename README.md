# userAuthenticationPhoneMethod
This repo contains two PowerShell scripts that can be used to set the user's authentication phone method in Azure Active Directory using Microsoft Graph.

The main difference between the two scripts is the method used to access Microsoft Graph:

(-) MicrosoftGraphPSModule.ps1 uses the "Get-MgUserAuthenticationPhoneMethod" cmdlet, which is available as part of the "Microsoft.Graph.Identity.AuthenticationMethods" module

(-) MicrosoftGraphREST.ps1 uses the "Invoke-RestMethod" cmdlet to call HTTP methods against the Microsoft Graph API
