[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, Position = 1, ValueFromRemainingArguments = $true)]
    [array]
    $Arguments
)

$RustcSysroot = rustc --print=sysroot
$RustcEtc = "$RustcSysroot\lib\rustlib\etc"

WinDbgX -c ".nvload $RustcEtc\intrinsic.natvis; .nvload $RustcEtc\liballoc.natvis; .nvload $RustcEtc\libcore.natvis;" @Arguments
