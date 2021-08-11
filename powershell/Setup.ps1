Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Install-Module yarn-completion -Scope CurrentUser

Add-WingetPackages @(
    "Mozilla.Firefox",
    "Git.Git",
    "Microsoft.VisualStudioCode",
    "Discord.Discord",
    "Valve.Steam",
    "OpenJS.Nodejs",
    "7zip.7zip",
    "Spotify.Spotify",
    "Python.Python",
    "GnuWin32.Make",
    "Kitware.CMake",
    "Microsoft.PowerToys",
    "Microsoft.PowerShell",
    "Microsoft.WindowsTerminalPreview",
    "LLVM.LLVM",
    "Files-UWP.FilesUWP",
    "AntibodySoftware.WizTree",
    "Yarn.Yarn",
    "OpenJS.NodeJS"
)

choco install fzf --yes

function Add-WingetPackages {
    param ([string[]] $Packages)
    
    foreach ($Package in $Packages) {
        winget install -e --id $Package
    }
}
