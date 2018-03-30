# ManageWindowsScheduledTask
An example/stub of how to create/edit a scheduled task with Powershell. This particular example calls the freely-available `idlelogoff.exe` for auto-user logoff after 5 minutes of inactivity. While this particular example script calls a specific application, its intended purpose is to be used as a launchpad example for manipulating scheduled tasks for your environment.

__An Important Note:__ The site hosting the download and documentation for `idlelogoff.exe` is now known to be serving javascript malware and other potentially nasty browser-based tricks. As such, should you not already have the binary on hand please exercise caution should you go looking for a download. Or just change the `$action` to something already on your testing workstation.

## Purpose
This script creates (or updates) a scheduled task to call `idlelogoff.exe`

It may be most useful for situations with multi-user workstations (kiosk-style, presentation station, etc.) to ensure folks are safely logged off after a period of inactivity. Because people seem to forget...

This script must be run as an administrator, and (in order for the scheduled task to actually run) will require `idlelogoff.exe` to be distributed to/available on the target workstation in a process separate from this task manager (e.g. application via SCCM, baked into a WIM, etc.).

## Example Information
When run without any edits, this script will create or edit a task matching `$taskName`. The action calls `idlelogoff.exe` with a "5 minute Logoff" (`300 LOGOFF`) argument, sets the task trigger to any console user (`BUILTIN\Users`) at log on (`-AtLogOn`).

For testing reasons, the `-Disable` flag has been added to the task settings. This will create the task but not auto-enable. For production deployment, one would remove the `-Disable` option.

Much detail on how to extend the use of scheduled tasks can be found at https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/ and https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtask

Bare-bones logging is also output to `$logPath` and could be easily extended for one's own sanity or need.