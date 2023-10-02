{
  description = "A very basic flake";

  inputs.keepassxc-passkey = {
    flake = false;
    url = "github:varjolintu/keepassxc?ref=feature/support_webauthn";
  };
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, keepassxc-passkey }: (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in
    rec {

      packages.keepassxc-passkey = pkgs.keepassxc-passkey;

      defaultPackage = packages.keepassxc-passkey;

    })) // {
    overlay = final: prev: {
      keepassxc-passkey = prev.keepassxc.overrideAttrs (oa: {
        src = keepassxc-passkey;
        checkPhase = "";
        cmakeFlags = oa.cmakeFlags ++ [ "-DWITH_XC_BROWSER_PASSKEYS=ON" ];
      });
      nixosModule = ({ config, pkgs, lib, ... }: { });
    };
  };
}
