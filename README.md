# openFPGA Updater

This Windows Powershell script automates downloading all of the currently-available cores for the [Analogue Pocket's](https://www.analogue.co/pocket) OpenFPGA feature.  At present it's a very basic script that simply downloads every core every time you run it, I hope to improve it in future versions to skip cores that do not need updates.

## Setup
If you have not run the script before, open a Powershell prompt and run:

    PS> Set-ExecutionPolicy Unrestricted -Scope CurrentUser
    
Download the Powershell script [here](https://raw.githubusercontent.com/KeenIIDX/openFPGAUpdater/main/openFpgaUpdater.ps1) and place it on the root of your Pocket's micro SD card.  Right click the file, click 'Run with PowerShell'.  A window will open as it's running.

## Thanks
* Thank you to Josh Campbell for his [openFPGA Cores Inventory](https://joshcampbell191.github.io/openfpga-cores-inventory/analogue-pocket) page.
* Thank you to Neil Morrison for his [Core updating script](https://gist.github.com/neil-morrison44/34fbb18de90cd9a32ca5bdafb2a812b8), which was the inspiration for this one.
