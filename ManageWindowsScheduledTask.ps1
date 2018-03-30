<# Header
 File Name: ManageWindowsScheduledTask.ps1
 Summary: An example of how to create or edit a scheduled task to leverage the freely-available idlelogoff.exe for auto-user logoff after (for this example) 5 minutes of inactivity.
 Created by: Matt Zaske
 Version 1.0

Purpose
=======
 This script creates (or updates) a scheduled task to leverage idlelogoff.exe
 Must be run as an administrator, and (in order for the scheduled task to succeed) will require idlelogoff.exe to be distributed to/available on the target workstation in a process separate from this task manager (e.g. application via SCCM, baked into a WIM, etc.).

Example Information
===================
 When run without any edits, this script will create or edit a task matching $taskName. The action calls idlelogoff.exe with a "5 minute / Logoff action" argument, sets the task trigger to any console user (BUILTIN\Users) at log on (-AtLogOn).

 For testing reasons, the -Disable flag has been added to the task settings. This will create the task but not auto-enable. For production deployment, one would remove the -Disable option.

 Much detail on how to extend the use of scheduled tasks can be found at https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/ and https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtask

 Bare-bones logging is also output and could be easily extended for one's own sanity.
#>
$taskName = "Idle Time Log Off - 5 Minute"
$taskDescription = "Automatic Log Off of user after 5 minutes of inactivity."
$action = New-ScheduledTaskAction -Execute "C:\Path\To\idlelogoff.exe" -Argument "300 LOGOFF"
$trigger =  New-ScheduledTaskTrigger -AtLogOn
$user = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Users"
$settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -Disable -Priority 7 -Compatibility Win8
$logPath = "C:\Windows\Temp\$taskName.log"

$existingTask = Get-ScheduledTask | Where-Object {$_.TaskName -eq "$taskName"}
if ($existingTask) { # UPDATE THE EXISTING TASK
    if (Set-ScheduledTask -Action $action -Trigger $trigger -Principal $user -TaskName $taskName) {
        $logText = "Successfully updated " + $taskName
        Out-File -FilePath $logPath -InputObject $logText
    }
} else { # CREATE A NEW TASK
    if (Register-ScheduledTask -Action $action -Trigger $trigger -Principal $user -TaskName $taskName -Description $taskDescription -Settings $settings) {
        $logText = "Successfully created " + $taskName
        Out-File -FilePath $logPath -InputObject $logText
    }
}