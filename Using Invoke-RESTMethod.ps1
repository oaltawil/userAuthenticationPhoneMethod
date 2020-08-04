$AppId = '1c9a8f98-a716-4aa5-ac55-639f5c5ef88d'
$AppSecret = 'Client Secret'

$Scope = "https://graph.microsoft.com/.default"

$TenantName = "scrapaper.onmicrosoft.com"

$Url = "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token"

Add-Type -AssemblyName System.Web

# Create the body of the HTTP Request
$Body = @{
	client_id = $AppId
	client_secret = $AppSecret
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

# Request the access token
$Request = Invoke-RestMethod @Parameters

$Header = @{
    Authorization = "$($Request.token_type) $($Request.access_token)"
}

$Uri = "https://graph.microsoft.com/beta/users/1a2795bf-d4a3-446c-ac92-b7f864057e15/authentication/phoneMethods"

Invoke-RestMethod -Uri $Uri -Headers $Header -Method Get -ContentType "application/json"
