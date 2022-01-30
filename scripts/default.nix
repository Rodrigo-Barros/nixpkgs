{
	pkgs ? import <nixpkgs> {},
    vscode-php-debug ? import ../packages/nvim/dap/vscode-php-debug {}
}:
{

	bindPrinter = pkgs.writeScriptBin "bind-printer.sh" "${builtins.readFile ./bind-printer.sh }";

	remind-notifier = pkgs.writeScriptBin "remind-notifier" "${builtins.readFile ./remind-notifier}";
	taskremind = pkgs.writeScriptBin "taskremind" "${builtins.readFile ./taskremind }";

	post = pkgs.writeScriptBin "post" "${builtins.readFile ./jekyll }";

	rofi-launcher = pkgs.writeScriptBin "rofi-launcher" "${builtins.readFile ./rofi-launcher }";

    encrypt-tool = pkgs.writeScriptBin "encrypt" ''
    #!${pkgs.bash}/bin/bash
    ${builtins.getEnv "HOME"}/.config/nixpkgs/scripts/encrypt "$@"
    '';
	nix-build-env = pkgs.writeScriptBin "build-env" "${builtins.readFile ./nix-env-builder}";

    vscode-php-debug = pkgs.writeScriptBin "vscode-php-debug" ''
        NODE_PATH=${pkgs.nodejs}/lib/node_modules/npm/node_modules ${pkgs.nodejs}/bin/node ${vscode-php-debug}/lib/phpDebug.js
    '';
}
