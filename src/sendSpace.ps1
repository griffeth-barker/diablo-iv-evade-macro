<#
.SYNOPSIS
  A macro to send spacebar keystrokes to the "Diablo IV" game window when it is active.

.DESCRIPTION
  This script provides a graphical user interface to start and stop a macro that sends spacebar keystrokes to the "Diablo IV" game window when it is active.

.PARAMETER None
  This script has no parameters.

.EXAMPLE
  Run the script in PowerShell to display the macro UI. Click "Start Macro" to begin sending spacebar keystrokes, and "Stop Macro" to cease sending.

.NOTES
  Author      : Griffeth Barker (github@griff.systems)
  Date        : 2024-10-19
  Version     : 0.3
  Last Change : Converted script from using PowerShell background jobs to using .NET Windows forms timers.
  Requires    : PowerShell 5.1 or higher
  License     : MIT License

  Disclaimer  : This script is provided "as is" without warranty of any kind. Use at your own risk. This is neither sponsored nor endorsed by Blizzard Entertainment.
                Consider this an educational project; please ensure you abide by the terms of service for the game you are using this script with!
                This script by default uses an external icon from the internet (check out icon-icons.com); I suggest updating this with your own icon to avoid external dependencies.
#>

$macroWindowTitle = 'Diablo IV Evade Macro'
Add-Type -AssemblyName System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$form.Text = "$macroWindowTitle"
$form.Size = New-Object System.Drawing.Size(315, 100)
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.TopMost = $true
$iconPath = "$env:SystemRoot\Temp\powershell.png"
$iconPath = 'C:\Windows\Temp\powershell_red.ico'
if (!(Test-Path -Path $iconPath)) {
  Invoke-WebRequest -Uri 'https://icon-icons.com/downloadimage.php?id=130242&root=2107/ICO/512/&file=file_type_powershell_psd_icon_130242.ico' -OutFile $iconPath #| Out-Null
}
$form.Icon = New-Object System.Drawing.Icon($iconPath)
$startButton = New-Object System.Windows.Forms.Button
$startButton.Text = 'Start Macro'
$startButton.Size = New-Object System.Drawing.Size(75, 40)
$startButton.Location = New-Object System.Drawing.Point(50, 10)
$startButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$startButton.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($startButton)
$stopButton = New-Object System.Windows.Forms.Button
$stopButton.Text = 'Stop Macro'
$stopButton.Size = New-Object System.Drawing.Size(75, 40)
$stopButton.Location = New-Object System.Drawing.Point(150, 10)
$stopButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$stopButton.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($stopButton)
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Size = New-Object System.Drawing.Size(200, 40)
$statusLabel.Location = New-Object System.Drawing.Point(250, 10)
$statusLabel.ForeColor = [System.Drawing.Color]::Red
$statusLabel.Text = "Stopped"
$form.Controls.Add($statusLabel)
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 2
$timer.Add_Tick({
  function Get-ActiveWindowTitle {
    $sig = @"
[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();
[DllImport("user32.dll")]
public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);
"@
    Add-Type -MemberDefinition $sig -Namespace Win32Functions -Name WindowFunctions
    $handle = [Win32Functions.WindowFunctions]::GetForegroundWindow()
    $title = New-Object System.Text.StringBuilder 256
    [void][Win32Functions.WindowFunctions]::GetWindowText($handle, $title, $title.Capacity)
    return $title.ToString()
  }
  $wshell = New-Object -ComObject wscript.shell
  $currentWindowTitle = Get-ActiveWindowTitle
  if ($currentWindowTitle -eq 'Diablo IV') {
    $wshell.SendKeys(' ')
  }
})
$startButton.Add_Click({
  $wshell = New-Object -ComObject wscript.shell
  $wshell.AppActivate('Diablo IV')  # Bring the game window to the foreground
  $timer.Start()  # Start the timer to check the active window
  $statusLabel.Text = "Running"
  $statusLabel.ForeColor = [System.Drawing.Color]::Green
})
$stopButton.Add_Click({
  $timer.Stop()  # Stop the timer when the stop button is clicked
  $statusLabel.Text = "Stopped"
  $statusLabel.ForeColor = [System.Drawing.Color]::Red
})
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
Remove-Item -Path $iconPath -Force -Confirm:$false #| Out-Null
