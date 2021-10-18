{
	pkgs ? import <nixpkgs> {}
}:
{
	bindPrinter = pkgs.writeScriptBin "bind-printer.sh" ''                                                                                   
		${builtins.readFile ./bind-printer.sh }                                                                                          
	'';

	remind = pkgs.writeScriptBin "remind.sh" ''                                                                                   
		${builtins.readFile ./remind.sh }                                                                                          
	'';
	taskremind = pkgs.writeScriptBin "taskremind" ''                                                                                   
		${builtins.readFile ./taskremind }                                                                                          
	'';

	post = pkgs.writeScriptBin "post" ''
		${builtins.readFile ./jekyll }                                                                                          
	'';

}