
Get-Service IntuneManagementExtension | Stop-Service

Get-Process -Name CompanyPortal | Stop-Process -Force

del 'C:\Windows\System32\config\systemprofile\AppData\Local\mdm\*' -Recurse

del 'C:\Program Files (x86)\Microsoft Intune Management Extension\Content\Incoming\*' -Recurse

Get-AppPackage -Name Microsoft.CompanyPortal | Reset-AppPackage


# Define the registry path
$registryPath = "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps"

# Check if the path exists
if (Test-Path $registryPath) {
    # Get all subkeys under Win32Apps
    $subKeys = Get-Item -Path $registryPath 
    
    # Loop through each subkey and remove it
    foreach ($subKey in $subKeys) {
    $subkey
        try {
            Remove-Item -Path $subKey.PSParentPath -Recurse -Force -ErrorAction Stop
            Write-Host "Successfully deleted $subKey"
        }
        catch {
            Write-Host "Error deleting $subKey : $_"
        }
    }
}
else {
    Write-Host "The registry path $registryPath does not exist."
}

Get-Service IntuneManagementExtension | Start-Service

Start-Sleep -Seconds 5

# Trigger the PushLaunch scheduled task
Get-ScheduledTask | Where-Object {$_.TaskName -eq 'PushLaunch'} | Start-ScheduledTask
