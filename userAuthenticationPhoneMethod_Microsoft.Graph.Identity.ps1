<#
.SYNOPSIS
This script uses the Microsoft.Graph.Identity.AuthenticationMethods PowerShell module to set a user's authentication phone method in Azure AD
You can install the Microsoft.Graph PowerShell modules using "Install-Module Microsoft.Graph"

.EXAMPLE
.\userAuthenticationPhoneMethod_Microsoft.Graph.Identity.ps1 -TenantID '9a2866fd-a1ce-4f8f-afcc-2143e2bf92bf' -ApplicationID '1c9a8f98-a716-4aa5-ac55-639f5c5ef88d' -CertificateThumprint '2500AE2A61FDB704E28A1472E1C2D39B5AF306B6' -UserPrincipalName 'clouduser@scrapaper.ca' -PhoneNumber '+1 6132218900' -PhoneType 'mobile'

.PARAMETER TenantID

.PARAMETER ApplicationID

.PARAMETER CertificateThumbprint
The thumbprint of a certificate that is installed in either the "LocalMachine\My" or "CurrentUser\My" certificate store.
The installed certificate must include the private key
The public key of the certificate must be uploaded to the application (Azure AD -> App Registrations -> myApp -> Certificates and Secrets)

.PARAMETER UserPrincipalName

.PARAMETER PhoneNumber 

.PARAMETER PhoneType

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
