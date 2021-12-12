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

	nix-build-env = pkgs.writeScriptBin "build-env" "${builtins.readFile ./nix-env-builder}";

    vscode-php-debug = pkgs.writeScriptBin "vscode-php-debug" ''
        ${pkgs.nodejs}/bin/node ${vscode-php-debug}/lib/phpDebug.js
    '';
}
