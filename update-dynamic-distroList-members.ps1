<#
Author: John Asare
Date: 2024/12/03

Description: Update the dynamic group members
#>

# Install module if not already
#Install-Module ExchangeOnlineManagement

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
$dynamicGroupName = "examplegroup@domain.com"

# Connect to EAC
try {
    Connect-ExchangeOnline -ErrorAction Stop
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Host "Couldn't connect to EAC: $_"
    Exit
}

# Fetch the current recipient filter
$currentFilter = (Get-DynamicDistributionGroup -Identity $dynamicGroupName).RecipientFilter

# Append the new exclusion condition
$newCondition = " -and (-not(PrimarySmtpAddress -eq 'someemail@domain.com'))"
$updatedFilter = "($currentFilter)$newCondition"

# Apply the updated filter
try {
    Set-DynamicDistributionGroup -Identity $dynamicGroupName -RecipientFilter $updatedFilter

    # Log success
    Get-Log -LogFilePath $logFilePath -LogMessage "Successfully appended exclusion condition. New filter: $updatedFilter"
}
catch {
    Get-Log -LogFilePath $logFilePath -LogMessage "Error updating the filter: $_"
}


finally {
    Disconnect-ExchangeOnline -Confirm:$false
    Get-Log -LogFilePath $logFilePath -LogMessage "Disconnected from Exchange Online."
}