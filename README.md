# Diablo IV Evade Macro  
A Windows-native macro with a simple graphical user interface to send spacebar keystrokes to the "Diablo IV" game window when it is active.  
  
## Disclaimers  
  - This script and executabl are provided "as is" without warranty of any kind. Use at your own risk.  
  - This is neither sponsored nor endorsed by Blizzard Entertainment.  
  - Consider this an educational project; please ensure you abide by the terms of service for the game you are using this script with.  
  - This script by default uses an external icon from the internet (check out icon-icons.com); I suggest updating this with your own icon to avoid external dependencies.  
  
## Summary  
I'm always looking for a fun challenge with PowerShell and while playing a favorite game of ours (Diablo IV), my buddy and I were talking about how some people use Logitech G-Hub or other software to automate keypresses for the dodging required in certain class builds.  
I realized that there's no reason I couldn't try building this in PowerShell, and threw this together real quick. Is it great? No. But it's functional, easy to use, and was a fun quick little project.  
  
## Recreating the executable  
I used the PS2EXE PowerShell module to wrap the script as an executable with an icon and some metadata.

```PowerShell
# Install the PS2EXE module
Install-Module -Name 'PS2EXE' -Force -Confirm:$false

# Import the PS2EXE module
Import-Module -Name 'PS2EXE' -Force

# Wrap the script as an executable
Invoke-PS2EXE .\sendSpace.ps1 '.\Diablo IV Evade Macro.exe' -noConsole -iconFile 'C:\path\to\your\icon\file' -title 'Diablo IV Evade Macro' -description 'A macro to send spacebar keystrokes to the Diablo IV game window when it is active.' -version '0.1' -company 'your name'
```

Of course, you don't have to recreate the executable if you don't want to; you can simply download the prebuilt executable from releases.  
  
## Screenshots  
__The executable file__  
![image](https://github.com/user-attachments/assets/c0be94fe-ab2f-481a-8ef1-fb4301e54248)  
Simply double-click the executable to launch the user interface. You can click-and-drag it to wherever you'd like on your screen.

__The graphical user interface__  
![image](https://github.com/user-attachments/assets/faa28953-a049-4def-b017-7bc3875a25f2)  
![image](https://github.com/user-attachments/assets/19c31c78-0816-4d35-9a77-8a3cf1f80199)  
  
The user interface will always stay on top of all other windows, even when not the active window. This makes it easy to get back to it to stop the macro when you want to. It's a small window that shouldn't impede your ability to see the game; of course you can leave it on a secondary monitor if you wish.
The user interface isn't fancy or responsive. The "Start Macro" button will start running the macro (via a Windows Forms timer); the "Stop Macro" button will stop running the same. There is a status label in the corner to indicate if the macro is currently running.
The emulated keypresses will only be sent to the Diablo IV application window, so don't worry too much if you need to click out of it for a minute to answer a Discord message, browse the web, etc.; it should not interfere.
