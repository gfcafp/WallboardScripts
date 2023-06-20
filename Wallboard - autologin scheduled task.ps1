$folderPath = "C:\Wallboard"  # Sti til mappe der skal kigges efter før scriptet kan køre.
$taskName = "Wallboard - Autolaunch Telia ace edge fullscreen"  # Navn på scheduled task der oprettes.
$taskCommand = "powershell.exe -ExecutionPolicy Bypass -File 'C:\Wallboard\Wallboard.ps1'"  # Kommando der kører i scheduled task der oprettes.

# Tjekker om mappe eksisterer og der er filer i den - der skal gerne være Wallboard.ps1 og settings.json
if ((Test-Path $folderPath -PathType Container) -and (Get-ChildItem -Path $folderPath -File)) {
    # Tjekker om scheduled task eksisterer i forvejen med det navn, og kører ikke hvis det er tilfældet.
    $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

    if ($existingTask -eq $null) {
        # Opretter scheduled task med ovenstående og trigger hvis "computernavn"\Wallboard logger ind. Bruger miljøvariabel til at trække computernavn.
        $userName = "$env:COMPUTERNAME\Wallboard"
        $taskTrigger = New-ScheduledTaskTrigger -AtLogOn -User $userName
        $taskAction = New-ScheduledTaskAction -Execute $taskCommand
        $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $taskName -Trigger $taskTrigger -Action $taskAction -Settings $taskSettings -Force
        Write-Host "Scheduled task created successfully."
    }
    else {
        Write-Host "Scheduled task already exists."
    }
}
else {
    Write-Host "Folder does not exist or does not contain any files."
}
