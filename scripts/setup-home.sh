#!/usr/bin/env sh

DIR=$HOME

mkdir -vp $DIR/projects/$(date +%Y)
mkdir -vp $DIR/notes
mkdir -vp $DIR/screenshots
mkdir -vp $DIR/wallpapers

if [[ ! -d $DIR/dotfiles ]]; then
  git clone https://github.com/juliamertz/dotfiles $DIR/dotfiles
fi


