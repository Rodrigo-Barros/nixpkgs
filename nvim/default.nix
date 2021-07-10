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

  telescope-media-files = pkgs.vimUtils.buildVimPlugin{
    name="telescope-media-files";
    src = pkgs.fetchFromGitHub{
      owner = "nvim-telescope";
      repo = "telescope-media-files.nvim";
      rev = "85f6cf21ae49cc8291a07728498a64ae67fef503";
      sha256 = "160y1yc2b0xy2p1nqxzmaw76fvrh66jqzb5pi4mj0nh432jk639a";
    };
  };

  dbext = pkgs.vimUtils.buildVimPlugin{
    name="dbext";
    src = pkgs.fetchFromGitHub{
      owner = "vim-scripts";
      repo = "dbext.vim";
      rev = "14f3d530b6189dc3f97edfa70b7a36006e21148c";
      sha256 = "03mrqrf689ww8ci80mwlz87zyijdrfnz57qq4n9waavjl9lbhpmn";
    };
  };

  taskwarrior = pkgs.vimUtils.buildVimPlugin{
    name="taskwarrior";
    src = pkgs.fetchFromGitHub{
      owner = "xarthurx";
      repo = "taskwarrior.vim";
      rev = "c77eac74a5ae9d8fd72d5d07aa284b053c51f982";
      sha256 = "037f9k6pg22yg641yp92bfqnschy5vj692a3bimj75gdkrp16dbj";
    };
  };

in
pkgs.neovim.override {
  configure={
    customRC = builtins.readFile ./vimrc;
    packages.myPlugins = with pkgs.vimPlugins; {
      start = [ 
        telescope-media-files
				telescope-nvim
        #vim-gitgutter
				vim-startify
        nvim-web-devicons
        barbar-nvim
        galaxyline-nvim
        onedark-vim
      ];
      opt = [ 
        gitsigns-nvim
        auto-pairs
        dbext
        fugitive 
        fzf-vim
        lazygit 
        MatchTagAlways
				nvim-lspconfig
        taskwarrior
        vim-nix
        vim-surround
        vimwiki
        whichKey
        nvim-tree-lua
      ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
    };
  };
}

