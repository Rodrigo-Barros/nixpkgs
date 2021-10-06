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

in
pkgs.neovim.override {
  vimAlias = true;
  configure={
    customRC = ''
	  luafile $HOME/.config/nixpkgs/packages/nvim/init.lua
    '';
    packages.myPlugins = with pkgs.vimPlugins; {
	start = [ 
			nvim-autopairs
			nvim-lspconfig
			lsp_signature-nvim
			nvim-compe
			gitsigns-nvim
			nvim-treesitter
			dbext
			nvim-tree-lua
			barbar-nvim
			lazygit
			taskwarrior
			vim-commentary
			vim-surround
			indentLine
			nvim-dap
			nvim-dap-ui
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
