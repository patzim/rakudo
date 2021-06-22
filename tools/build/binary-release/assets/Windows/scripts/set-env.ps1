Write-Host -NoNewline "Adding Rakudo to PATH ... "

$script_path = split-path -parent $MyInvocation.MyCommand.Definition

$rakudo_path0 = (Resolve-Path "$script_path\..\bin").Path
$rakudo_path1 = (Resolve-Path "$script_path\..\share\perl6\site\bin").Path

if ($env:PATH -NotLike "*$rakudo_path1*") {
    $Env:PATH = "$rakudo_path1;$Env:PATH"
    $done_stuff = $true
}

if ($env:PATH -NotLike "*$rakudo_path0*") {
    $Env:PATH = "$rakudo_path0;$Env:PATH"
    $done_stuff = $true
}

if ($done_stuff) {
    Write-Host "Done."
}
else {
    Write-Host "Already done. Nothing to do."
}

Write-Host @'

You can now start an interactive Raku by typing `raku.exe` and run a Raku
program by typing `raku.exe path\to\my\program.raku`.

To install a Raku module using the Zef module manager type
`zef install Some::Module`.

Happy hacking!
'@