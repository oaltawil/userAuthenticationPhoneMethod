<#
.SYNOPSIS
This script calls HTTP REST methods against the Microsoft Graph API to set a user's authentication phone method in Azure AD

.EXAMPLE
.\userAuthenticationPhoneMethod_REST.ps1 -TenantID '9a2866fd-a1ce-4f8f-afcc-2143e2bf92bf' -ApplicationID '1c9a8f98-a716-4aa5-ac55-639f5c5ef88d' -ApplicationSecret 'Client Secret' -UserPrincipalName 'clouduser@scrapaper.ca' -PhoneNumber '+1 6132218900' -PhoneType 'mobile'

.PARAMETER TenantID

.PARAMETER ApplicationID

.PARAMETER ApplicationSecret

.PARAMETER UserPrincipalName

.PARAMETER PhoneNumber 

.PARAMETER PhoneType

#>

Param(
	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()]
	[String]
	$TenantID,
	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()]
	[String]
	$ApplicationId,
	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()]
	[String]
	$ApplicationSecret,
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

$Scope = "https://graph.microsoft.com/.default"

$Url = "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token"

# Create the body of the first HTTP Request for authentication
$Body = @{
	client_id = $ApplicationId
	client_secret = $ApplicationSecret
	scope = $Scope
	grant_type = 'client_credentials'
}

# Splat the parameters for Invoke-RestMethod for cleaner code
$Parameters = @{
	ContentType = 'application/x-www-form-urlencoded'
	Method = 'POST'
	Body = $Body
	Uri = $Url
}

# Request the OAuth 2.0 Access Token
$Request = Invoke-RestMethod @Parameters

# Create an Authorization Header
$Header = @{
    Authorization = "$($Request.token_type) $($Request.access_token)"
}

# Retrieve the user's authentication phone method (if it exists)
$Uri = "https://graph.microsoft.com/beta/users/$UserPrincipalName/authentication/phoneMethods"
$authenticationPhoneMethod = Invoke-RestMethod -Uri $Uri -Headers $Header -Method Get -ContentType "application/json"
$authenticationPhoneMethodId = $authenticationPhoneMethod.id

# Create a Request Body containing the user's phoneNumber and phoneType
$Body = @"
{
	"phoneNumber": "$PhoneNumber", 
	"phoneType": "$PhoneType"
}
"@

# Create a new user authentication phone method
if (-not $authenticationPhoneMethodId)
{
	$Uri = "https://graph.microsoft.com/beta/users/$UserPrincipalName/authentication/phoneMethods"
	Invoke-RestMethod -Uri $Uri -Headers $Header -Body $Body -Method Post -ContentType "application/json"
}
# Update the user's existing authentication phone method
else {

	$Uri = "https://graph.microsoft.com/beta/users/$UserPrincipalName/authentication/phoneMethods/$authenticationPhoneMethodId"
	Invoke-RestMethod -Uri $Uri -Headers $Header -Body $Body -Method Put -ContentType "application/json"

}
