{ 
  pkgs? import <nixpkgs> {}, 
  stdenv ? pkgs.stdenv,
  vim_configurable ? pkgs.vim_configurable
}:
vim_configurable.customize {

  name = "vim";

  vimrcConfig={
    customRC = builtins.readFile ./vimrc;
    packages.plugins = with pkgs.vimPlugins; {
      start = [ lightline-vim ];
    };
  };

}
