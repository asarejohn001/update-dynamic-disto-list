<#
Author: John Asare
Date: 2024/12/03

Description: Update the dynamic group members
#>

# Install module if not already
Install-Module ExchangeOnlineManagement

# Import module
Import-Module ExchangeOnlineManagement

# Function to log warnings, errors, and success message
function Get-Log {
    param (
        [string]$LogFilePath,
        [string]$LogMessage
    )

    # Create the log entry with the current date and time
    $logEntry = "{0} - {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $LogMessage

    # Append the log entry to the log file
    Add-Content -Path $LogFilePath -Value $logEntry
}

# Set variables
$logFilePath = ".\log.txt"
$dynamicGroupName = "dph_all@dph.sc.gov"

# Connect to EAC
try {
    Connect-ExchangeOnline -ErrorAction Stop
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Host "Couldn't connect to EAC: $_"
    Exit
}

# Get the existing filter of the dynamic distribution group
try {
    $dynamicGroup = Get-DynamicDistributionGroup -Identity $dynamicGroupName
    $currentFilter = $dynamicGroup.RecipientFilter

    # Log current filter
    Get-Log -LogFilePath $logFilePath -LogMessage "Current filter: $currentFilter"

    # Update the filter to exclude the specific email address
    $newCondition = " -and (-not(PrimarySmtpAddress -eq 'securityalerts@dhec.sc.gov'))"

    # Update the dynamic distribution group's filter
    Set-DynamicDistributionGroup -Identity $dynamicGroupName -RecipientFilter $newCondition
    $newUpdatedFilter = $dynamicGroup.RecipientFilter

    # Log success
    Get-Log -LogFilePath $logFilePath -LogMessage "Updated filter: $newUpdatedFilter"
}
catch {
    Get-Log -LogFilePath $logFilePath -LogMessage "Error updating dynamic distribution group: $_"
}
finally {
    #Disconnect-ExchangeOnline -Confirm:$false
    #Get-Log -LogFilePath $logFilePath -LogMessage "Disconnected from Exchange Online."
}