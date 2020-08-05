<#
.SYNOPSIS
This script uses the Microsoft.Graph.Identity.AuthenticationMethods PowerShell module to set a user's authentication phone method in Azure AD
You can install the Microsoft.Graph PowerShell modules using "Install-Module Microsoft.Graph"

.EXAMPLE
MicrosoftGraphPSModule.ps1 -TenantID '9a2866fd-a1ce-4f8f-afcc-2143e2bf92bf' -ApplicationID '1c9a8f98-a716-4aa5-ac55-639f5c5ef88d' -CertificateThumprint '2500AE2A61FDB704E28A1472E1C2D39B5AF306B6' -UserPrincipalName 'clouduser@scrapaper.ca' -PhoneNumber '+1 6132218900' -PhoneType 'mobile'

.PARAMETER TenantID
The id of the Azure AD directory or tenant to connect to.

.PARAMETER ApplicationID
The client ID of your application

.PARAMETER CertificateThumbprint
The thumbprint of a certificate that is installed in the current user's certificate store. The installed certificate must contain the private key.
The public key of the certificate must be uploaded to the application (Azure AD -> App Registrations -> myApp -> Certificates and Secrets)

.PARAMETER UserPrincipalName
The UPN of the user whose phone authentication method will be set

.PARAMETER PhoneNumber 
The authentication phone number to be used in the following format: +{Country Code} {Area Code}{Phone Number}, e.g. +1 6132904620

.PARAMETER PhoneType
The authentication phone type to be used, e.g. mobile
#>

#Requires -Modules Microsoft.Graph.Identity.AuthenticationMethods

Param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $TenantID,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ApplicationID,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificateThumprint,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $UserPrincipalName,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $PhoneNumber,
    [Parameter(Mandatory=$true)]
    [ValidateSet("mobile", "alternateMobile", "office")]
    [String]
    $PhoneType
)

# Connect using the certificate
Connect-Graph -CertificateThumbprint $CertificateThumprint -TenantId $TenantID -ClientId $ApplicationID

# Retrieve the Id of the authentication phone method (if configured)
$AuthenticationMethodId = (Get-MgUserAuthenticationPhoneMethod -UserId $UserPrincipalName).Id

# Create a new authentication phone method if one does not exist
if (-not $AuthenticationMethodId)
{
    New-MgUserAuthenticationPhoneMethod -UserId $UserPrincipalName -PhoneType $PhoneType -PhoneNumber $PhoneNumber
}
# Update the authentication phone method if it already exists
else
{
    Update-MgUserAuthenticationPhoneMethod -UserId $UserPrincipalName -PhoneType $PhoneType -PhoneNumber $PhoneNumber
}
