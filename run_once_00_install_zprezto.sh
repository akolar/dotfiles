#!/usr/bin/env zsh

target="${ZDOTDIR:-$HOME}/.zprezto"
if [[ -e "$target" ]]; then
    echo ":: $target already exists, exiting, not reinstalling"
    exit 0
fi

echo ":: cloning zprezto"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "$target"

echo ":: linking rc files"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    homerc="${ZDOTDIR:-$HOME}/.${rcfile:t}"
    if [[ -e "$homerc" ]]; then
        echo "skipping $homerc, already exists"
        continue
    fi

    ln -s "$rcfile" "$homerc"
done
