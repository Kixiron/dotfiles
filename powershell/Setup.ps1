Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install fzf --yes

Install-Module yarn-completion
Install-Module PSFzf
Install-Module posh-git
Install-Module oh-my-posh
Install-Module PoshRSJob
Install-Module PSReadLine

function Install-WingetPackages {
    param ([string[]] $Packages)
    
    foreach ($Package in $Packages) {
        winget install -e --id $Package
    }
}

Install-WingetPackages @(
    "Mozilla.Firefox",
    "Git.Git",
    "Microsoft.VisualStudioCode",
    "Discord.Discord",
    "Valve.Steam",
    "OpenJS.Nodejs",
    "7zip.7zip",
    "Spotify.Spotify",
    "Python.Python.3",
    "GnuWin32.Make",
    "Kitware.CMake",
    "Microsoft.PowerToys",
    "Microsoft.PowerShell",
    "Microsoft.WindowsTerminalPreview",
    "LLVM.LLVM",
    "Files-UWP.FilesUWP",
    "AntibodySoftware.WizTree",
    "Yarn.Yarn",
    "OpenJS.NodeJS",
    "stack.stack",
    "Microsoft.VisualStudio.2019.Community",
    "Rustlang.rust-msvc"
)

# Update rust
rustup toolchain add nightly --force
rustup update

function Install-Crates {
    param ([string[]] $Crates)
    
    foreach ($Crate in $Crates) {
        cargo install $Crate --force
    }
}

Install-Crates @(
    "lsd",
    "cargo-make",
    "ripgrep",
    "tokei",
    "cargo-release"
)

# Allow python files to be executed
cmd /c assoc .py=PythonScript
cmd /c ftype PythonScript=C:\Users\Chase\AppData\Local\Programs\Python\Python39\python.exe "%1" %*
setx PATHEXT %PATHEXT%;.PY

# Additional things to install:
# https://github.com/DynamoRIO/dynamorio/releases/latest
