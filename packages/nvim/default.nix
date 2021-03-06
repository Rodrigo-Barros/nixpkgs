{ 
  pkgs? import <nixpkgs> {}, 
  stdenv ? pkgs.stdenv,
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
   vim-inspector = pkgs.vimUtils.buildVimPlugin{
    name ="vim-inspector";
    src = pkgs.fetchFromGitHub{
        owner = "puremourning";
        repo = "vimspector";
        rev = "a371a162c3378bc50b74a4e5536228c2cc2c9c35";
        sha256 = "sha256-gVW9sDsxHKFlFY33eMHuhNIvJoLVjNRwSkhcI1Hc0fM=";
    };
   };
   vdebug = pkgs.vimUtils.buildVimPlugin{
    name ="vdebug";
    src = pkgs.fetchFromGitHub{
        owner = "vim-vdebug";
        repo = "vdebug";
        rev = "6a21b7df2dae9f202c4920655374978e364d2637";
        sha256 = "sha256-kobMC6TRFZcEbgFdOaBgXUzoeWQUrVzUKylN1N9nEnc=";
    };
   };

# 
#   whichKey = pkgs.vimUtils.buildVimPlugin{
#     name="whichKey";
#     src = pkgs.fetchFromGitHub{
#       owner = "liuchengxu";
#       repo = "vim-which-key";
#       rev = "da2934fcd36350b871ed8ccd54c8eae3a0dfc8ae";
#       sha256 = "18n5mqwgkjsf67jg2r24d4w93hadg7fnqyvmqq6dd5bsmqwp9v14";
#     };
#   };
# 
   telescope-media-files = pkgs.vimUtils.buildVimPlugin{
     name="telescope-media-files";
     src = pkgs.fetchFromGitHub{
       owner = "nvim-telescope";
       repo = "telescope-media-files.nvim";
       rev = "ead1249e71356302b511baec93960f8076eba292";
       sha256 = "17xqs7afagha3w4w3nymbxgh1hjf94jdq97j07bdvsv20hi8kbl7";
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
   windline = pkgs.vimUtils.buildVimPlugin{
     name="windline";
     src = pkgs.fetchFromGitHub{
		 owner = "windwp";
		 repo = "windline.nvim";
		 rev = "4129d25a7c0846a5f96d7b21ff6b2d46fe296bba";
		 sha256 = "08zv9gl6aradhv9v9dpg7wi6i97n0amf2kad23pjibjgxbfqfiv6";
	 };
	 buildPhase = ''
		echo $src $out
		mkdir -p $out/share
		cp -r $src $out
		ls $out
	 '';
   };

  onedark = pkgs.vimUtils.buildVimPlugin{
	name="vim-atom-dark";
	src = pkgs.fetchFromGitHub{
	   owner = "joshdick";
	   repo = "onedark.vim";
	   rev = "bd199dfa76cd0ff4abef2a8ad19c44d35552879d";
	   sha256 = "1xh3ypma3kmn0nb8szq14flfca6ss8k2f1vlnvyapa8dc9i731yy";
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

   dap-ui = pkgs.vimUtils.buildVimPlugin{
     name="nvim-dap-ui";
     src = pkgs.fetchFromGitHub{
       owner = "rcarriga";
       repo = "nvim-dap-ui";
       rev = "96813c9a42651b729f50f5d880a8919a155e9721";
       sha256 = "sha256-sAR8hX9tCUMNwmH3TvtysKOXBDvliSePaRQ5A5lbo/w=";
     };
   };
    nvim-treesitter-playground = pkgs.vimUtils.buildVimPlugin{
     name="nvim-blame-line";
     src = pkgs.fetchFromGitHub{
       owner = "nvim-treesitter";
       repo = "playground";
       rev = "787a7a8d4444e58467d6b3d4b88a497e7d494643";
       sha256 = "YMINv064VzuzZLuQNY6HN3oCZvYjNQi6IMliQPTijfg=";
     };
   };

   gitsigns-nvim = pkgs.vimUtils.buildVimPlugin{
     name="gitsigns-nvim";
     src = pkgs.fetchFromGitHub{
       owner = "lewis6991";
       repo = "gitsigns.nvim";
       rev = "4d8a6e0eb38a3715bec45c98c3567b47789e1367";
       sha256="DuJX8bWI7kP9c8vXEA23OxxU1ZDb5efCEktbKlrpSe4=";
     };
     configurePhase = ''
       rm Makefile 
     '';
   };
in
pkgs.neovim.override {
  vimAlias = true;
  configure={
    customRC = ''
	  luafile $HOME/.config/nixpkgs/packages/nvim/init.lua
      luafile $HOME/.config/nixpkgs/packages/nvim/snippets/php.lua
    '';
    packages.myPlugins = with pkgs.vimPlugins; {
	start = [ 
			nvim-autopairs
			nvim-lspconfig
			lsp_signature-nvim
            dart-vim-plugin
            vim-flutter
			#nvim-compe
            
            # cmp env
            nvim-cmp
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp-cmdline
            cmp_luasnip

            luasnip
			gitsigns-nvim
			nvim-treesitter
            nvim-treesitter-playground
			dbext
			nvim-tree-lua
			barbar-nvim
			lazygit
			taskwarrior
			vim-commentary
			vim-surround
			indentLine
			nvim-dap
            dap-ui
			which-key-nvim
			vimwiki
			vim-floaterm

			# Telescope
			plenary-nvim
			nvim-web-devicons
			telescope-nvim
			telescope-media-files

			# Customization

			windline
			onedark
		];
	};
  };
}
