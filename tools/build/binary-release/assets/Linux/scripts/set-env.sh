#!/bin/sh

# Sourced from https://stackoverflow.com/a/29835459/1975049
rreadlink() (
  target=$1 fname= targetDir= CDPATH=
  { \unalias command; \unset -f command; } >/dev/null 2>&1
  [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on
  while :; do
      [ -L "$target" ] || [ -e "$target" ] || { command printf '%s\n' "ERROR: '$target' does not exist." >&2; return 1; }
      command cd "$(command dirname -- "$target")" || exit 1
      fname=$(command basename -- "$target")
      [ "$fname" = '/' ] && fname=''
      if [ -L "$fname" ]; then
        target=$(command ls -l "$fname")
        target=${target#* -> }
        continue
      fi
      break
  done
  targetDir=$(command pwd -P)
  if [ "$fname" = '.' ]; then
    command printf '%s\n' "${targetDir%/}"
  elif  [ "$fname" = '..' ]; then
    command printf '%s\n' "$(command dirname -- "${targetDir}")"
  else
    command printf '%s\n' "${targetDir%/}/$fname"
  fi
)

EXEC=$(rreadlink "$0")
DIR=$(dirname $(dirname "$EXEC"))

NEW_PATH=$PATH
RAKUDO_PATH0="$DIR/bin"
RAKUDO_PATH1="$DIR/share/perl6/site/bin"
STUFF_DONE=false
for RPATH in $RAKUDO_PATH1 $RAKUDO_PATH0 ; do
    if echo "$NEW_PATH" | /bin/grep -vEq "(^|:)$RPATH($|:)" ; then
        NEW_PATH="$RPATH:$NEW_PATH"
        STUFF_DONE=true
    fi
done

if $STUFF_DONE ; then
    echo "echo -n 'Adding Rakudo to PATH ... ';"
    if [ "$1" = "--fish" ] ; then
        NEW_PATH=$(echo "$NEW_PATH" | sed "s/:/ /g")
        echo "set -x PATH $NEW_PATH;"
    else
        echo "export PATH='$NEW_PATH';"
    fi
    echo "echo 'Done.';"
else
    echo "echo 'Adding Rakudo to PATH ... Already done. Nothing to do.';"
fi

echo "echo '';
echo 'You can now start an interactive Raku by typing \`raku\` and run a Raku';
echo 'program by typing \`raku path/to/my/program.raku\`.';
echo 'To install a Raku module using the Zef module manager type';
echo '\`zef install Some::Module\`.';
echo '';
echo 'Happy hacking!'
"
