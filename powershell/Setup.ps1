Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Install-Module yarn-completion -Scope CurrentUser

function Add-WingetPackages {
    param ([string[]] $Packages)
    
    foreach ($Package in $Packages) {
        winget install -e --id $Package --log
    }
}

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
    "OpenJS.NodeJS",
    "stack.stack",
    "Microsoft.VisualStudio.2019.Community",
    "Rustlang.rust-msvc"
)

choco install fzf --yes

# Update rust
rustup toolchain add nightly --force
rustup update

cargo install lsd --force
cargo install cargo-make --force
cargo install ripgrep --force
cargo install tokei --force

# Additional things to install:
# https://github.com/DynamoRIO/dynamorio/releases/latest
