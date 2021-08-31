#Requires -Version 7

using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# $script:StartTime = [System.Diagnostics.Stopwatch]::StartNew()
$env:POSH_GIT_ENABLED = $true

# UTF-8 all of the things
$OutputEncoding = [System.Text.UTF8Encoding]::new()
[System.Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
[System.Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
$PSDefaultParameterValues["*:Encoding"] = "utf8"

# ----------------------------------- Load Modules -----------------------------------

Import-Module PoshRSJob
Start-RSJob -ModulesToImport posh-git {} | Out-Null
Import-Module PSReadLine
Import-Module oh-my-posh
Import-Module PSFzf
Import-Module yarn-completion
Set-PoshPrompt -Theme G:\Users\Chase\Code\Powershell\terminal.omp.json

# ---------------------------- Tab-complete & history search --------------------------

Remove-PSReadLineKeyHandler "Ctrl+r"
Remove-PSReadLineKeyHandler "Ctrl+t"
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+c -Function Copy
Set-PSReadLineKeyHandler -Key Ctrl+v -Function Paste
# Make PSReadLine show completion hints
Set-PSReadLineOption -PredictionSource History
# Customize PSReadLine hint display
Set-PSReadLineOption -Colors @{ InlinePrediction = "#82AAFF" }

# Logic for matching quotes and braces
Set-PSReadLineKeyHandler -Key '"', "'" `
    -BriefDescription SmartInsertQuote `
    -LongDescription "Insert paired quotes if not already on a quote" `
    -ScriptBlock {
    param($key, $arg)

    $quote = $key.KeyChar

    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # If text is selected, just quote it without any smarts
    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $quote + $line.SubString($selectionStart, $selectionLength) + $quote)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
        return
    }

    $ast = $null
    $tokens = $null
    $parseErrors = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$parseErrors, [ref]$null)

    function FindToken {
        param($tokens, $cursor)

        foreach ($token in $tokens) {
            if ($cursor -lt $token.Extent.StartOffset) { continue }
            if ($cursor -lt $token.Extent.EndOffset) {
                $result = $token
                $token = $token -as [StringExpandableToken]
                if ($token) {
                    $nested = FindToken $token.NestedTokens $cursor
                    if ($nested) { $result = $nested }
                }

                return $result
            }
        }
        return $null
    }

    $token = FindToken $tokens $cursor

    # If we're on or inside a **quoted** string token (so not generic), we need to be smarter
    if ($token -is [StringToken] -and $token.Kind -ne [TokenKind]::Generic) {
        # If we're at the start of the string, assume we're inserting a new string
        if ($token.Extent.StartOffset -eq $cursor) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quote$quote ")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            return
        }

        # If we're at the end of the string, move over the closing quote if present.
        if ($token.Extent.EndOffset -eq ($cursor + 1) -and $line[$cursor] -eq $quote) {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            return
        }
    }

    if ($null -eq $token -or
        $token.Kind -eq [TokenKind]::RParen -or $token.Kind -eq [TokenKind]::RCurly -or $token.Kind -eq [TokenKind]::RBracket) {
        if ($line[0..$cursor].Where{ $_ -eq $quote }.Count % 2 -eq 1) {
            # Odd number of quotes before the cursor, insert a single quote
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($quote)
        } else {
            # Insert matching quotes, move cursor to be in between the quotes
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quote$quote")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
        }
        return
    }

    # If cursor is at the start of a token, enclose it in quotes.
    if ($token.Extent.StartOffset -eq $cursor) {
        if ($token.Kind -eq [TokenKind]::Generic -or $token.Kind -eq [TokenKind]::Identifier -or 
            $token.Kind -eq [TokenKind]::Variable -or $token.TokenFlags.hasFlag([TokenFlags]::Keyword)) {
            $end = $token.Extent.EndOffset
            $len = $end - $cursor
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($cursor, $len, $quote + $line.SubString($cursor, $len) + $quote)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($end + 2)
            return
        }
    }

    # We failed to be smart, so just insert a single quote
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($quote)
}
Set-PSReadLineKeyHandler -Key '(', '{', '[' `
    -BriefDescription InsertPairedBraces `
    -LongDescription "Insert matching braces" `
    -ScriptBlock {
    param($key, $arg)

    $closeChar = switch ($key.KeyChar) {
        <#case#> '(' { [char]')'; break }
        <#case#> '{' { [char]'}'; break }
        <#case#> '[' { [char]']'; break }
    }

    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    
    if ($selectionStart -ne -1) {
        # Text is selected, wrap it in brackets
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $key.KeyChar + $line.SubString($selectionStart, $selectionLength) + $closeChar)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    } else {
        # No text is selected, insert a pair
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}
Set-PSReadLineKeyHandler -Key ')', ']', '}' `
    -BriefDescription SmartCloseBraces `
    -LongDescription "Insert closing brace or skip" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[$cursor] -eq $key.KeyChar) {
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
    }
}
Set-PSReadLineKeyHandler -Key Backspace `
    -BriefDescription SmartBackspace `
    -LongDescription "Delete previous character or matching quotes/parens/braces" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -gt 0) {
        $toMatch = $null
        if ($cursor -lt $line.Length) {
            switch ($line[$cursor]) {
                <#case#> '"' { $toMatch = '"'; break }
                <#case#> "'" { $toMatch = "'"; break }
                <#case#> ')' { $toMatch = '('; break }
                <#case#> ']' { $toMatch = '['; break }
                <#case#> '}' { $toMatch = '{'; break }
            }
        }

        if ($toMatch -ne $null -and $line[$cursor - 1] -eq $toMatch) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
        }
    }
}

# Insert text from the clipboard as a here string
Set-PSReadLineKeyHandler -Key Ctrl+V `
    -BriefDescription PasteAsHereString `
    -LongDescription "Paste the clipboard text as a here string" `
    -ScriptBlock {
    param($key, $arg)

    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText()) {
        # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n", "`n").TrimEnd()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
    }
}

# --------------------------------------- Aliases -------------------------------------

Set-Alias -Name cls -Value Clear-Host -Force | Out-Null
Set-Alias -Name grep -Value rg -PassThru | Out-Null
Set-Alias -Name ls -Value lsd -Force -PassThru | Out-Null
Set-Alias -Name nano -Value C:\Progra~1\Git\usr\bin\nano.exe -PassThru -Force | Out-Null
Set-Alias -Name which -Value Get-Command -PassThru -Force | Out-Null

# --------------------------------- Utility Functions ---------------------------------

function Set-OldEnvironmentalVariables {
    param(
        [hashtable]
        $ExpectedValues,

        [hashtable]
        $OldValues
    )

    foreach ($Value in $OldValues.GetEnumerator()) {
        $Expected = $ExpectedValues[$Value.Key]
        $Current = [System.Environment]::GetEnvironmentVariable($Variable.Key);

        # If the user's script block didn't change the env var any,
        # we reset it to the previous value
        if ($Expected -eq $Current) {
            if (-not $Value) {
                Remove-Item "Env:\$($Value.Key)"
            } else {
                Set-Item "env:$($Value.Key)" -Value $Value.Value
            }
        }
    }
}

function Use-EnvVar {
    [CmdletBinding()]
    param(
        [ValidateNotNull()]
        [hashtable]
        $Env = @{},

        [ValidateNotNull()]
        [scriptblock]
        $ScriptBlock
    )

    $OldValues = @{}
    $Error = $null
    foreach ($Variable in $Env.GetEnumerator()) {
        if ($Variable.Key -eq "") {
            $Error = "cannot set an environmental variable without a name"
            break
        }

        $OldValues[$Variable.Key] = [System.Environment]::GetEnvironmentVariable($Variable.Key);
        Set-Item -Path "env:$($Variable.Key)" -Value $Variable.Value
    }

    if ($Error) {
        Set-OldEnvironmentalVariables $Env $OldValues
        throw $Error
    }

    try {
        Invoke-Command -ScriptBlock $ScriptBlock -NoNewScope
    } catch {
        # Rethrow the exeception
        throw $_.Exception
    } finally {
        Set-OldEnvironmentalVariables $Env $OldValues
    }
}

# ------------------------------------ Completions ------------------------------------

# Cargo
Register-ArgumentCompleter -Native -CommandName "cargo" -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        "cargo"
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith("-") -or
                $element.Value.StartsWith("+")) {
                break
            }
            $element.Value
        }) -join ";"

    $completions = @(switch ($command) {
            "cargo" {
                [CompletionResult]::new("-vv", "very-verbose", [CompletionResultType]::ParameterName, "Use verbose output (-vv very verbose/build.rs output)")
                [CompletionResult]::new("-v", "verbose", [CompletionResultType]::ParameterName, "Use verbose output (-vv very verbose/build.rs output)")
                [CompletionResult]::new("--verbose", "verbose", [CompletionResultType]::ParameterName, "Use verbose output (-vv very verbose/build.rs output)")
                [CompletionResult]::new("-q", "quiet", [CompletionResultType]::ParameterName, "Disable progress output")
                [CompletionResult]::new("--quiet", "quiet", [CompletionResultType]::ParameterName, "Disable progress output")
                [CompletionResult]::new("--list", "list", [CompletionResultType]::ParameterName, "List installed commands")
                [CompletionResult]::new("-V", "version", [CompletionResultType]::ParameterName, "Prints version information")
                [CompletionResult]::new("--version", "version", [CompletionResultType]::ParameterName, "Prints version information")
                [CompletionResult]::new("--frozen", "frozen", [CompletionResultType]::ParameterName, "Require Cargo.lock and cache are up to date")
                [CompletionResult]::new("--locked", "locked", [CompletionResultType]::ParameterName, "Require Cargo.lock is up to date")
                [CompletionResult]::new("--offline", "offline", [CompletionResultType]::ParameterName, "Run without accessing the network")
                [CompletionResult]::new("-h", "help", [CompletionResultType]::ParameterName, "cargo -h <subcommand>...`n`nPrints help information")
                [CompletionResult]::new("--help", "help", [CompletionResultType]::ParameterName, "cargo --help <subcommand>...`n`nPrints help information")
                [CompletionResult]::new("--color", "color", [CompletionResultType]::ParameterName, "cargo --color <auto, always, never>`n`nControl when colored output is used")
                [CompletionResult]::new("build", "build", [CompletionResultType]::ParameterName, "Compile the current package")
                [CompletionResult]::new("b", "build", [CompletionResultType]::ParameterName, "Alias: Compile the current package")
                [CompletionResult]::new("check", "check", [CompletionResultType]::ParameterName, "Analyze the current package and report errors, but don't build object files")
                [CompletionResult]::new("c", "check", [CompletionResultType]::ParameterName, "Alias: Analyze the current package and report errors, but don't build object files")
                [CompletionResult]::new("clean", "clean", [CompletionResultType]::ParameterName, "Remove the target directory")
                [CompletionResult]::new("doc", "doc", [CompletionResultType]::ParameterName, "Build this package's and its dependencies' documentation")
                [CompletionResult]::new("new", "new", [CompletionResultType]::ParameterName, "Create a new cargo package")
                [CompletionResult]::new("init", "init", [CompletionResultType]::ParameterName, "Create a new cargo package in an existing directory")
                [CompletionResult]::new("run", "run", [CompletionResultType]::ParameterName, "cargo run [options] [-- args]`n`nRun a binary or example of the local package")
                [CompletionResult]::new("r", "run", [CompletionResultType]::ParameterName, "Alias: Run a binary or example of the local package")
                [CompletionResult]::new("test", "test", [CompletionResultType]::ParameterName, "Execute all unit and integration tests and build examples of a local package")
                [CompletionResult]::new("t", "test", [CompletionResultType]::ParameterName, "Alias: Execute all unit and integration tests and build examples of a local package")
                [CompletionResult]::new("bench", "bench", [CompletionResultType]::ParameterName, "Execute all benchmarks of a local package")
                [CompletionResult]::new("update", "update", [CompletionResultType]::ParameterName, "Update dependencies listed in Cargo.lock")
                [CompletionResult]::new("search", "search", [CompletionResultType]::ParameterName, "Search registry for crates")
                [CompletionResult]::new("publish", "publish", [CompletionResultType]::ParameterName, "Package and upload this package to the registry")
                [CompletionResult]::new("install", "install", [CompletionResultType]::ParameterName, "Install a Rust binary. Default location is $HOME\.cargo\bin")
                [CompletionResult]::new("uninstall", "uninstall", [CompletionResultType]::ParameterName, "Uninstall a Rust binary")
                [CompletionResult]::new("help", "help", [CompletionResultType]::ParameterValue, "Prints this message or the help of the given subcommand(s)")
                [CompletionResult]::new("bench", "bench", [CompletionResultType]::ParameterValue, "Execute all benchmarks of a local package")
                [CompletionResult]::new("fetch", "fetch", [CompletionResultType]::ParameterName, "Fetch dependencies of a package from the network")
                [CompletionResult]::new("fix", "fix", [CompletionResultType]::ParameterName, "Automatically fix lint warnings reported by rustc")
                [CompletionResult]::new("login", "login", [CompletionResultType]::ParameterName, "Save an api token from the registry locally. If token is not specified, it will be read from stdin.")
                [CompletionResult]::new("logout", "logout", [CompletionResultType]::ParameterName, "Remove an API token from the registry locally")
                [CompletionResult]::new("metadata", "metadata", [CompletionResultType]::ParameterName, "Output the resolved dependencies of a package, the concrete used versions including overrides, in machine-readable format")
                [CompletionResult]::new("owner", "owner", [CompletionResultType]::ParameterName, "Manage the owners of a crate on the registry")
                [CompletionResult]::new("package", "package", [CompletionResultType]::ParameterName, "Assemble the local package into a distributable tarball")
                [CompletionResult]::new("pkgid", "pkgid", [CompletionResultType]::ParameterName, "Print a fully qualified package specification")
                [CompletionResult]::new("rustc", "rustc", [CompletionResultType]::ParameterName, "Compile a package, and pass extra options to the compiler")
                [CompletionResult]::new("rustdoc", "rustdoc", [CompletionResultType]::ParameterName, "Build a package's documentation, using specified custom flags.")
                [CompletionResult]::new("search", "search", [CompletionResultType]::ParameterName, "Search packages in crates.io")
                [CompletionResult]::new("tree", "tree", [CompletionResultType]::ParameterName, "Display a tree visualization of a dependency graph")
                [CompletionResult]::new("vendor", "vendor", [CompletionResultType]::ParameterName, "Vendor all dependencies for a project locally")
                [CompletionResult]::new("version", "version", [CompletionResultType]::ParameterName, "Show version information")
                [CompletionResult]::new("yank", "yank", [CompletionResultType]::ParameterName, "Remove a pushed crate from the index")
                [CompletionResult]::new("read-manifest", "read-manifest", [CompletionResultType]::ParameterName, "Print a JSON representation of a Cargo.toml manifest.")
                [CompletionResult]::new("generate-lockfile", "generate-lockfile", [CompletionResultType]::ParameterName, "Generate the lockfile for a package")
                [CompletionResult]::new("locate-project", "locate-project", [CompletionResultType]::ParameterName, "Print a JSON representation of a Cargo.toml file's location")
                [CompletionResult]::new("verify-project", "verify-project", [CompletionResultType]::ParameterName, "Check correctness of crate manifest")
                break
            }

            "cargo;--color" {
                [CompletionResult]::new("auto", "auto", [CompletionResultType]::ParameterName, "(default): Automatically detect if color support is available in the terminal")
                [CompletionResult]::new("always", "always", [CompletionResultType]::ParameterName, "Always display colors")
                [CompletionResult]::new("never", "never", [CompletionResultType]::ParameterName, "Never display colors")
                break
            }

            "cargo;run" {
                [CompletionResult]::new("--bin", "bin", [CompletionResultType]::ParameterName, "cargo run --bin <name> [options]`n`nRun the specified binary")
                [CompletionResult]::new("--example", "example", [CompletionResultType]::ParameterName, "cargo run --example <name> [options]`n`nRun the specified example")
                [CompletionResult]::new("--features", "features", [CompletionResultType]::ParameterName, "cargo run --features <features> [options]`n`nSpace or comma separated list of features to activate.`nFeatures of workspace members may be enabled with package-name/feature-name syntax.`nThis flag may be specified multiple times, which enables all specified features.")
                [CompletionResult]::new("--all-features", "all-features", [CompletionResultType]::ParameterName, "Activate all available features of all selected packages")
                [CompletionResult]::new("--no-default-features", "no-default-features", [CompletionResultType]::ParameterName, "Do not activate the default feature of the selected packages")
                [CompletionResult]::new("--target", "target", [CompletionResultType]::ParameterName, "cargo run --target <triple> [options]`n`nRun for the given architecture, defaulting to the host architecture.`nThe general format of the triple is <arch><sub>-<vendor>-<sys>-<abi>.`nRun rustc --print target-list for a list of supported targets.`n`nThis may also be specified with the build.target config value <https://doc.rust-lang.org/cargo/reference/config.html>.`n`nNote that specifying this flag makes Cargo run in a different mode where the target artifacts are placed in a separate directory. See the build cache <https://doc.rust-lang.org/cargo/guide/build-cache.html> documentation for more details.")
                [CompletionResult]::new("--release", "release", [CompletionResultType]::ParameterName, "Run optimized artifacts with the release profile.`nSee the PROFILES section for details on how this affects profile selection.")
                [CompletionResult]::new("--color", "color", [CompletionResultType]::ParameterName, "cargo run --color <auto, always, never> [options]`n`nControl when colored output is used")
                [CompletionResult]::new("--target-dir", "target-dir", [CompletionResultType]::ParameterName, "Directory for all generated artifacts and intermediate files")
                [CompletionResult]::new("-vv", "very verbose", [CompletionResultType]::ParameterName, "Use very verbose output, including dependency warnings and build script output")
                [CompletionResult]::new("--verbose", "verbose", [CompletionResultType]::ParameterName, "Use verbose output")
                [CompletionResult]::new("-v", "v", [CompletionResultType]::ParameterName, "Use verbose output")
                [CompletionResult]::new("--quiet", "quiet", [CompletionResultType]::ParameterName, "No output printed to stdout")
                [CompletionResult]::new("-q", "q", [CompletionResultType]::ParameterName, "No output printed to stdout")
                [CompletionResult]::new("--message-format", "message-format", [CompletionResultType]::ParameterName, "The output format for diagnostic messages")
                [CompletionResult]::new("--manifest-path", "manifest-path", [CompletionResultType]::ParameterName, "Path to the Cargo.toml file")
                [CompletionResult]::new("--frozen", "frozen", [CompletionResultType]::ParameterName, "cargo run --frozen [options]`n`nRequires that the Cargo.lock file is up-to-date and prevents Cargo from attempting to access the network to determine if it is out-of-date")
                [CompletionResult]::new("--locked", "locked", [CompletionResultType]::ParameterName, "cargo run --locked [options]`n`nRequires that the Cargo.lock file is up-to-date")
                [CompletionResult]::new("--offline", "offline", [CompletionResultType]::ParameterName, "cargo run --offline [options]`n`nPrevents Cargo from accessing the network for any reason")
                [CompletionResult]::new("+nightly", "toolchain-nightly", [CompletionResultType]::ParameterName, "cargo run +nightly [options]`n`nA Rustup toolchain to run Cargo with")
                [CompletionResult]::new("+stable", "toolchain-stable", [CompletionResultType]::ParameterName, "cargo run +stable [options]`n`nA Rustup toolchain to run Cargo with")
                [CompletionResult]::new("+beta", "toolchain-beta", [CompletionResultType]::ParameterName, "cargo run +beta [options]`n`nA Rustup toolchain to run Cargo with")
                [CompletionResult]::new("--help", "help", [CompletionResultType]::ParameterName, "cargo run --help`n`nPrints help information")
                [CompletionResult]::new("-h", "h", [CompletionResultType]::ParameterName, "cargo run -h`n`nPrints help information")
                [CompletionResult]::new("-Z", "Z", [CompletionResultType]::ParameterName, "cargo run -Z <flags> [options]`n`nUnstable (nightly-only) flags to Cargo, run cargo -Z help for details")
                [CompletionResult]::new("--jobs", "jobs", [CompletionResultType]::ParameterName, "cargo run --jobs <jobs> [options]`n`nNumber of parallel jobs to run, defaults to the number of CPUs ($((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors))")
                [CompletionResult]::new("-j", "j", [CompletionResultType]::ParameterName, "cargo run -j <jobs> [options]`n`nNumber of parallel jobs to run, defaults to the number of CPUs ($((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors))")
                [CompletionResult]::new("--package", "package", [CompletionResultType]::ParameterName, "cargo run --package <package> [options]`n`nThe package to run. See cargo-pkgid(1) for the SPEC format.`n`nBy default, the package in the current working directory is selected.`nThe -p flag can be used to choose a different package in a workspace.")
                break
            }

            "cargo;run;--color" {
                [CompletionResult]::new("auto", "auto", [CompletionResultType]::ParameterName, "(default): Automatically detect if color support is available in the terminal")
                [CompletionResult]::new("always", "always", [CompletionResultType]::ParameterName, "Always display colors")
                [CompletionResult]::new("never", "never", [CompletionResultType]::ParameterName, "Never display colors")
                break
            }

            "cargo;run;--message-format" {
                [CompletionResult]::new("human", "human", [CompletionResultType]::ParameterName, "(default): Display in a human-readable text format")
                [CompletionResult]::new("short", "short", [CompletionResultType]::ParameterName, "Emit shorter, human-readable text messages")
                [CompletionResult]::new("json", "json", [CompletionResultType]::ParameterName, "Emit JSON messages to stdout")
                [CompletionResult]::new("json-diagnostic-short", "json-diagnostic-short", [CompletionResultType]::ParameterName, "Ensure the rendered field of JSON messages contains the `"short`" rendering from rustc")
                [CompletionResult]::new("json-diagnostic-rendered-ansi", "json-diagnostic-rendered-ansi", [CompletionResultType]::ParameterName, "Ensure the rendered field of JSON messages contains embedded ANSI color codes for respecting rustc's default color scheme")
                [CompletionResult]::new("json-render-diagnostics", "json-render-diagnostics", [CompletionResultType]::ParameterName, "Instruct Cargo to not include rustc diagnostics in in JSON messages printed, but instead Cargo itself should render the JSON diagnostics coming from rustc")
                break
            }
        })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}

# Rustup
Register-ArgumentCompleter -Native -CommandName 'rustup' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'rustup'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-')) {
                break
            }
            $element.Value
        }) -join ';'

    $completions = @(switch ($command) {
            'rustup' {
                [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Enable verbose output')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enable verbose output')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Disable progress output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Disable progress output')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('dump-testament', 'dump-testament', [CompletionResultType]::ParameterValue, 'Dump information about the build')
                [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterValue, 'Show the active and installed toolchains or profiles')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Update Rust toolchains')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall Rust toolchains')
                [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Update Rust toolchains and rustup')
                [CompletionResult]::new('check', 'check', [CompletionResultType]::ParameterValue, 'Check for updates to Rust toolchains')
                [CompletionResult]::new('default', 'default', [CompletionResultType]::ParameterValue, 'Set the default toolchain')
                [CompletionResult]::new('toolchain', 'toolchain', [CompletionResultType]::ParameterValue, 'Modify or query the installed toolchains')
                [CompletionResult]::new('target', 'target', [CompletionResultType]::ParameterValue, 'Modify a toolchain''s supported targets')
                [CompletionResult]::new('component', 'component', [CompletionResultType]::ParameterValue, 'Modify a toolchain''s installed components')
                [CompletionResult]::new('override', 'override', [CompletionResultType]::ParameterValue, 'Modify directory toolchain overrides')
                [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Run a command with an environment configured for a given toolchain')
                [CompletionResult]::new('which', 'which', [CompletionResultType]::ParameterValue, 'Display which binary will be run for a given command')
                [CompletionResult]::new('doc', 'doc', [CompletionResultType]::ParameterValue, 'Open the documentation for the current toolchain')
                [CompletionResult]::new('self', 'self', [CompletionResultType]::ParameterValue, 'Modify the rustup installation')
                [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Alter rustup settings')
                [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate tab-completion scripts for your shell')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'rustup;dump-testament' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;show' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('active-toolchain', 'active-toolchain', [CompletionResultType]::ParameterValue, 'Show the active toolchain')
                [CompletionResult]::new('home', 'home', [CompletionResultType]::ParameterValue, 'Display the computed value of RUSTUP_HOME')
                [CompletionResult]::new('profile', 'profile', [CompletionResultType]::ParameterValue, 'Show the current profile')
                [CompletionResult]::new('keys', 'keys', [CompletionResultType]::ParameterValue, 'Display the known PGP keys')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'rustup;show;active-toolchain' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;show;home' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;show;profile' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;show;keys' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;show;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;install' {
                [CompletionResult]::new('--profile', 'profile', [CompletionResultType]::ParameterName, 'profile')
                [CompletionResult]::new('--no-self-update', 'no-self-update', [CompletionResultType]::ParameterName, 'Don''t perform self-update when running the `rustup install` command')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Force an update, even if some components are missing')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;uninstall' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;update' {
                [CompletionResult]::new('--no-self-update', 'no-self-update', [CompletionResultType]::ParameterName, 'Don''t perform self update when running the `rustup update` command')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Force an update, even if some components are missing')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;check' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;default' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;toolchain' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed toolchains')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Install or update a given toolchain')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall a toolchain')
                [CompletionResult]::new('link', 'link', [CompletionResultType]::ParameterValue, 'Create a custom toolchain by symlinking to a directory')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'rustup;toolchain;list' {
                [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Enable verbose output with toolchain information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enable verbose output with toolchain information')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;toolchain;install' {
                [CompletionResult]::new('--profile', 'profile', [CompletionResultType]::ParameterName, 'profile')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Add specific components on installation')
                [CompletionResult]::new('--component', 'component', [CompletionResultType]::ParameterName, 'Add specific components on installation')
                [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterName, 'Add specific targets on installation')
                [CompletionResult]::new('--target', 'target', [CompletionResultType]::ParameterName, 'Add specific targets on installation')
                [CompletionResult]::new('--no-self-update', 'no-self-update', [CompletionResultType]::ParameterName, 'Don''t perform self update when running the`rustup toolchain install` command')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Force an update, even if some components are missing')
                [CompletionResult]::new('--allow-downgrade', 'allow-downgrade', [CompletionResultType]::ParameterName, 'Allow rustup to downgrade the toolchain to satisfy your component choice')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;toolchain;uninstall' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;toolchain;link' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;toolchain;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;target' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed and available targets')
                [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add a target to a Rust toolchain')
                [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove a target from a Rust toolchain')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'rustup;target;list' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--installed', 'installed', [CompletionResultType]::ParameterName, 'List only installed targets')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;target;add' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;target;remove' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;target;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;component' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed and available components')
                [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add a component to a Rust toolchain')
                [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove a component from a Rust toolchain')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'rustup;component;list' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--installed', 'installed', [CompletionResultType]::ParameterName, 'List only installed components')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;component;add' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--target', 'target', [CompletionResultType]::ParameterName, 'target')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;component;remove' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--target', 'target', [CompletionResultType]::ParameterName, 'target')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;component;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;override' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List directory toolchain overrides')
                [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set the override toolchain for a directory')
                [CompletionResult]::new('unset', 'unset', [CompletionResultType]::ParameterValue, 'Remove the override toolchain for a directory')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'rustup;override;list' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;override;set' {
                [CompletionResult]::new('--path', 'path', [CompletionResultType]::ParameterName, 'Path to the directory')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;override;unset' {
                [CompletionResult]::new('--path', 'path', [CompletionResultType]::ParameterName, 'Path to the directory')
                [CompletionResult]::new('--nonexistent', 'nonexistent', [CompletionResultType]::ParameterName, 'Remove override toolchain for all nonexistent directories')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;override;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;run' {
                [CompletionResult]::new('--install', 'install', [CompletionResultType]::ParameterName, 'Install the requested toolchain if needed')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;which' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;doc' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--path', 'path', [CompletionResultType]::ParameterName, 'Only print the path to the documentation')
                [CompletionResult]::new('--alloc', 'alloc', [CompletionResultType]::ParameterName, 'The Rust core allocation and collections library')
                [CompletionResult]::new('--book', 'book', [CompletionResultType]::ParameterName, 'The Rust Programming Language book')
                [CompletionResult]::new('--cargo', 'cargo', [CompletionResultType]::ParameterName, 'The Cargo Book')
                [CompletionResult]::new('--core', 'core', [CompletionResultType]::ParameterName, 'The Rust Core Library')
                [CompletionResult]::new('--edition-guide', 'edition-guide', [CompletionResultType]::ParameterName, 'The Rust Edition Guide')
                [CompletionResult]::new('--nomicon', 'nomicon', [CompletionResultType]::ParameterName, 'The Dark Arts of Advanced and Unsafe Rust Programming')
                [CompletionResult]::new('--proc_macro', 'proc_macro', [CompletionResultType]::ParameterName, 'A support library for macro authors when defining new macros')
                [CompletionResult]::new('--reference', 'reference', [CompletionResultType]::ParameterName, 'The Rust Reference')
                [CompletionResult]::new('--rust-by-example', 'rust-by-example', [CompletionResultType]::ParameterName, 'A collection of runnable examples that illustrate various Rust concepts and standard libraries')
                [CompletionResult]::new('--rustc', 'rustc', [CompletionResultType]::ParameterName, 'The compiler for the Rust programming language')
                [CompletionResult]::new('--rustdoc', 'rustdoc', [CompletionResultType]::ParameterName, 'Generate documentation for Rust projects')
                [CompletionResult]::new('--std', 'std', [CompletionResultType]::ParameterName, 'Standard library API documentation')
                [CompletionResult]::new('--test', 'test', [CompletionResultType]::ParameterName, 'Support code for rustc''s built in unit-test and micro-benchmarking framework')
                [CompletionResult]::new('--unstable-book', 'unstable-book', [CompletionResultType]::ParameterName, 'The Unstable Book')
                [CompletionResult]::new('--embedded-book', 'embedded-book', [CompletionResultType]::ParameterName, 'The Embedded Rust Book')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;self' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Download and install updates to rustup')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall rustup.')
                [CompletionResult]::new('upgrade-data', 'upgrade-data', [CompletionResultType]::ParameterValue, 'Upgrade the internal data format.')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'rustup;self;update' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;self;uninstall' {
                [CompletionResult]::new('-y', 'y', [CompletionResultType]::ParameterName, 'y')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;self;upgrade-data' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;self;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;set' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('default-host', 'default-host', [CompletionResultType]::ParameterValue, 'The triple used to identify toolchains when not specified')
                [CompletionResult]::new('profile', 'profile', [CompletionResultType]::ParameterValue, 'The default components installed')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'rustup;set;default-host' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;set;profile' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;set;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;completions' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
            'rustup;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
        })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}

# $script:ElapsedTime = $script:StartTime.Elapsed
# Write-Host $(
#     [string]::Format(
#         "Loaded in {0}sec, {1:d2}ms",
#         $script:ElapsedTime.Seconds,
#         $script:ElapsedTime.Milliseconds
#     )
# )
