param (
    [Parameter(HelpMessage="The interval between pulls in seconds.")]
    [int]$Interval = 300, # Default to 5 minutes

    [Parameter(HelpMessage="Total duration to run the script in minutes. Use 0 for infinite.")]
    [int]$Duration = 0
)

$startTime = Get-Date
$stopTime = if ($Duration -gt 0) { $startTime.AddMinutes($Duration) } else { $null }

Write-Host "Auto-Pull started. Checking every $Interval seconds..." -ForegroundColor Magenta

do {
    if (Test-Path .git) {
        $currentTime = Get-Date -Format "HH:mm:ss"
        Write-Host "[$currentTime] Syncing..." -ForegroundColor Cyan
        git pull
    } else {
        Write-Error "Not a git repository. Exiting."
        break
    }

    # Check if we've exceeded the duration
    if ($stopTime -and (Get-Date) -gt $stopTime) {
        Write-Host "Duration reached. Stopping script." -ForegroundColor Green
        break
    }

    Start-Sleep -Seconds $Interval
} while ($true)
