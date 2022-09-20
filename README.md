# openFPGA Updater

![GitHub all releases](https://img.shields.io/github/downloads/KeenIIDX/openFPGAUpdater/total?style=social)

This Windows Powershell script automates downloading all of the currently-available cores for the [Analogue Pocket's](https://www.analogue.co/pocket) OpenFPGA feature, and automates updating them in the future.

## Setup
If you have not run the script before, open a Powershell prompt and run:

    PS> Set-ExecutionPolicy Unrestricted -Scope CurrentUser
    
Download the Powershell script [here](https://github.com/KeenIIDX/openFPGAUpdater/releases/latest/download/openFpgaUpdater.ps1) (and optionally a list of the available cores in [this file](https://github.com/KeenIIDX/openFPGAUpdater/releases/latest/download/core_repos.json)) and place it on the root of your Pocket's micro SD card.  Right click the file, click 'Run with PowerShell'.  A window will open as it's running.  On first run, it will download and install all the available cores.  Every time you run it in the future it will only download new cores and updates to installed cores.

## Thanks
* Thank you to Josh Campbell for his [openFPGA Cores Inventory](https://joshcampbell191.github.io/openfpga-cores-inventory/analogue-pocket) page.
* Thank you to Neil Morrison for his [Core updating script](https://gist.github.com/neil-morrison44/34fbb18de90cd9a32ca5bdafb2a812b8), which was the inspiration for this one.
* Thank you to all the FPGA developers who created these cores, providing me with many hours of fun!
