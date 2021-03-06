{ pkgs ? import <nixpks> {} }:
let
  aliases = ''
    alias ls="ls --color"
    alias ssh="TERM=xterm-color ssh"
    alias dotfiles="$(which git) --git-dir=$DOTFILES --work-tree=$HOME"
    alias icat="kitty +kitten icat"
    alias grep="grep --color"
    alias j="z"

	lib="$(nix-build --no-out-link '<nixpkgs>' -A stdenv.cc.cc.lib)/lib64"
	alias nvim="LD_LIBRARY_PATH=$lib nvim"
	alias vim="LD_LIBRARY_PATH=$lib vim"
	unset lib
  '';
  sources = ''
	source $HOME/.nix-profile/etc/profile.d/command-not-found.sh
  '';
  profileText = pkgs.writeText "profile" ''
    export PATH=$PATH:$HOME/.local/bin:$HOME/.nix-profile/bin

    export EDITOR="nvim"
    export BROWSER="firefox"

    export XDG_CACHE_HOME="$HOME/.local/cache"
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"

    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    export FNM_DIR="$XDG_DATA_HOME/fnm"
    #export COC_NODE_PATH=$FNM_DIR/aliases/default/bin/node

    export HISTSIZE=10000
    export SAVEHIST=10000
    export HISTFILE=$XDG_CACHE_HOME/zsh-history

    export TASKRC=$XDG_CONFIG_HOME/taskrc
    export TIMEWARRIORDB=$XDG_DATA_HOME/timewarrior
    export KEYTIMEOUT=1

    export DOTFILES=$( [ -e $HOME/Documentos/Git/Personal/dotfiles ] && echo  $HOME/Documentos/Git/Personal/dotfiles || echo $HOME/.dotfiles )

    #LOCALE_ARCHIVE=/home/rodrigo/.nix-profile/lib/locale/locale-archive
    export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
	export LANG=pt_BR.UTF-8

    # ALIASES
    ${aliases}
	# SOURCES
	${sources}

	# FIX SYSTEM GTK APPS NOT OPENNING
	unset GI_TYPELIB_PATH
	unset GDK_PIXBUF_MODULE_FILE
  '';
in {
 profile = pkgs.runCommand "profile" {}  ''
  mkdir -p  $out/etc/profile.d
  cp ${profileText} $out/etc/profile.d/profile.sh
 '';
}
