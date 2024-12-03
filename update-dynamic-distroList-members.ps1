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

