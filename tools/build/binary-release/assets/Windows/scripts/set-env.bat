@ECHO off

<NUL SET /p="Adding Rakudo to PATH ... "

FOR /F "tokens=*" %%I IN ("%~dp0..") DO SET "RAKUDO_BASE=%%~fI"

SET "RAKUDO_PATH0=%RAKUDO_BASE%\bin"
SET "RAKUDO_PATH1=%RAKUDO_BASE%\share\perl6\site\bin"

SET "DONE_STUFF=false"

PATH|find /i "%RAKUDO_PATH1%" >NUL || (
    SET "PATH=%RAKUDO_PATH1%;%PATH%"
    SET "DONE_STUFF=true"
)

path|find /i "%RAKUDO_PATH0%" >NUL || (
    SET "PATH=%RAKUDO_PATH0%;%PATH%"
    SET "DONE_STUFF=true"
)

IF %DONE_STUFF% == true (
    ECHO Done.
) ELSE (
    ECHO Already done. Nothing to do.
)

ECHO.
ECHO You can now start an interactive Raku by typing `raku.exe` and run a Raku
ECHO program by typing `raku.exe path\to\my\program.raku`.
ECHO To install a Raku module using the Zef module manager type
ECHO `zef install Some::Module`.
ECHO.
ECHO Happy hacking!
