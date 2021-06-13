{ 
  pkgs? import <nixpkgs> {}, 
  stdenv ? pkgs.stdenv,
  vim_configurable ? pkgs.vim_configurable
}:
let 
  lazygit = pkgs.vimUtils.buildVimPlugin{
    name = "lazygit";
    src = pkgs.fetchFromGitHub{
      owner = "kdheepak";
      repo = "lazygit.nvim";
      rev = "71db1e8403dfce884480185be4145eae180b9c77";
      sha256 = "1ji23i43x3bhzph14c5cxqavjbhy4xry5yg8886d3i3hh89yy1zr";
    };
  };

  whichKey = pkgs.vimUtils.buildVimPlugin{
    name="whichKey";
    src = pkgs.fetchFromGitHub{
      owner = "liuchengxu";
      repo = "vim-which-key";
      rev = "da2934fcd36350b871ed8ccd54c8eae3a0dfc8ae";
      sha256 = "18n5mqwgkjsf67jg2r24d4w93hadg7fnqyvmqq6dd5bsmqwp9v14";
    };
  };
in
pkgs.neovim.override {
  configure={
    packages.myPlugins = with pkgs.vimPlugins; {
      start = [ 
        vim-gitgutter
      ];
      opt = [ 
        whichKey
        vim-surround
        lazygit 
        fzf-vim
        auto-pairs
        onedark-vim 
        fugitive 
        vimwiki
        MatchTagAlways
      ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
    };
    customRC = builtins.readFile ./vimrc;
  };

}
