{
  inputs = {
    typelevel-nix.url = "github:typelevel/typelevel-nix";
    nixpkgs.follows = "typelevel-nix/nixpkgs";
    flake-utils.follows = "typelevel-nix/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, typelevel-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ typelevel-nix.overlay ];
        };
      in
      {
	PROTOC = "${pkgs.protobuf3_20}/bin/protoc";

        devShell = pkgs.devshell.mkShell {
          imports = [ typelevel-nix.typelevelShell ];
          name = "tc-messenger-previews-shell";
          env = [
	      {
		name = "PROTOC";
		prefix = "${pkgs.protobuf3_20}/bin/protoc";
	      }];
	  packages = [ 
	  	pkgs.protobuf3_20 
		];
          typelevelShell = {
		jdk.package = pkgs.jdk21;
          };
        };
      }
    );
}
