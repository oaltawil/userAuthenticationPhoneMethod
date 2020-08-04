$TenantID = '9a2866fd-a1ce-4f8f-afcc-2143e2bf92bf'
$ApplicationID = '1c9a8f98-a716-4aa5-ac55-639f5c5ef88d'
$CertificateThumprint = '2500AE2A61FDB704E28A1472E1C2D39B5AF306B6'

# Connect using the Certificate
Connect-Graph -CertificateThumbprint $CertificateThumprint -TenantId $TenantID -ClientId $ApplicationID

Get-MgUserAuthenticationPhoneMethod -UserId '1a2795bf-d4a3-446c-ac92-b7f864057e15'
