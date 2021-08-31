param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Name = "Chase Wilson",

    [ValidateNotNullOrEmpty()]
    [string]
    $Email = "me@chasewilson.dev"
)

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    $item = $null

    do {
        $name = [System.IO.Path]::GetRandomFileName()
        $item = New-Item -Path $parent -Name $name -ItemType "directory" -ErrorAction SilentlyContinue
    } while (-not $item)

    return $item.FullName
}

function Install-Modules {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]
        $Modules
    )

    Install-PackageProvider NuGet -Force
    Set-PSRepository PSGallery -InstallationPolicy Trusted

    foreach ($Module in $Modules) {
        Install-Module -Name $Module -AcceptLicense -Force -Confirm:$false
    }
}

function Install-WingetPackages {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]
        $Packages
    )
    
    foreach ($Package in $Packages) {
        winget install -e --id $Package
    }
}

function Install-Crates {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]
        $Crates
    )
    
    $OldValue = $env:RUSTFLAGS
    $env:RUSTFLAGS = "-C opt-level=3 -C target-cpu=native"

    foreach ($Crate in $Crates) {
        cargo install $Crate --force
    }

    if (-not $OldValue) {
        Remove-Item Env:\RUSTFLAGS
    } else {
        $env:RUSTFLAGS = $OldValue
    }
}

function Install-ChocoPackages {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]
        $Packages
    )
    
    foreach ($Package in $Packages) {
        choco install $Package --yes
    }
}

function Set-GitConfigs {
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Values
    )
    
    foreach ($Value in $Values.GetEnumerator()) {
        git config --global $Value.Key $Value.Value
    }
}

Set-ExecutionPolicy Bypass -Scope Process -Force

# Create a temp folder for setup to occur in
$InstallFolder = New-TemporaryDirectory

# Install chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Install-ChocoPackages @("fzf")
RefreshEnv.cmd

# Install powershell profile
New-Item -Path $env:PROFILE -ItemType "file" -Force

$IosevkaParams = @{
    Uri     = "https://raw.githubusercontent.com/Kixiron/dotfiles/master/powershell/Profile.ps1";
    OutFile = "$env:PROFILE";
}
Invoke-WebRequest @IosevkaParams

Install-Modules @(
    "yarn-completion",
    "PSFzf",
    "posh-git",
    "oh-my-posh",
    "PoshRSJob",
    "PSReadLine"
)
RefreshEnv.cmd

try {
    # Update powershell's help with the newly added modules
    Update-Help
} catch {
    # Ignore any errors, we don't care
}

Install-WingetPackages @(
    "Mozilla.Firefox",
    "Git.Git",
    "Microsoft.VisualStudioCode",
    "Discord.Discord",
    "Valve.Steam",
    "OpenJS.Nodejs",
    "7zip.7zip",
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
    "Microsoft.VisualStudio.2019.Community"
)
# Spotify is *special* so it has to be run in a non-elevated prompt in order to install
$SpotifyParams = @{
    Verb         = "RunAsUser";
    FilePath     = "winget.exe";
    ArgumentList = @("install", "-e", "--id", "Spotify.Spotify");
}
Start-Process @SpotifyParams

RefreshEnv.cmd

# Setup git
Set-GitConfigs @{
    # Set the user and email
    "user.name"            = $Name;
    "user.email"           = $Email;
    # Set the editor to VSCode
    "core.editor"          = "code --wait";
    "diff.tool"            = "vscode";
    "difftool.vscode.cmd"  = "code --wait --diff `$LOCAL `$REMOTE";
    "merge.tool"           = "vscode";
    "mergetool.vscode.cmd" = "code --wait `$MERGED";
}

# Download rustup
$RustupInit = Join-Path $InstallFolder "rustup-init.exe"
Invoke-RestMethod -Uri "https://win.rustup.rs/x86_64"-OutFile $RustupInit

# Install rust
& "$RustupInit --profile complete"
RefreshEnv.cmd

# Add the nightly toolchain and update rust
rustup toolchain add nightly --force
rustup update

# Install some crates
Install-Crates @(
    "lsd",
    "cargo-make",
    "ripgrep",
    "tokei",
    "cargo-release",
    "kondo",
    "cargo-hack",
    "cargo-cache",
    "sccache",
    "cargo-update",
    "cargo-criterion"
)

# Allow python files to be executed from the commandline
cmd /c "assoc .py=PythonScript"
cmd /c "ftype PythonScript=$HOME\AppData\Local\Programs\Python\Python39\python.exe `"%1`" %*"
setx PATHEXT "%PATHEXT%;.PY"

# Set up SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType "Automatic"

# Clone Iosevka
git clone "https://github.com/be5invis/Iosevka" --depth 1 $InstallFolder
# Download iosevka build plan
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Kixiron/dotfiles/master/powershell/private-build-plans.toml" `
    -OutFile $(Join-Path $InstallFolder "Iosevka" "private-build-plans.toml")

# Download ttfautohint
$TtfAutoHintDir = Join-Path $InstallFolder "ttf_auto_hint"

$TtfAutoHintParams = @{
    Uri       = "https://sourceforge.net/projects/freetype/files/ttfautohint/1.8.4/ttfautohint-1.8.4-win32.7z/download";
    OutFile   = $TtfAutoHintDir;
    UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox;
}
Invoke-WebRequest @TtfAutoHintParams

# Build Iosevka
Set-Location $(Join-Path $InstallFolder "Iosevka")
yarn install
yarn run build ttf::iosevka-custom

# Make destination directory
$FontDir = Join-Path $HOME "Code" "Fonts" "Iosevka"
New-Item -Path $FontDir -ItemType "directory" -Force

# Move the files into their font dir
Move-Item -Path $(Join-Path $InstallFolder "Iosevka" "dist" "iosevka-custom" "ttf") `
    -Destination $FontDir
# TODO: Install the fonts???
# TODO: FiraCode and FiraMono https://www.nerdfonts.com/font-downloads

# Delete the temporary directory
Remove-Item $InstallFolder -Recurse -Force

# TODO: Download and put in their proper places the rest of the dotfile scripts
# TODO: Do complete installation of Visual Studio to include C++ build tools
#  https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2019
# TODO: Install WinDbg preview, currently not avaliable via winget
# TODO: Install dynamorio https://github.com/DynamoRIO/dynamorio/releases/latest
# TODO: Setup GPG and SSH
