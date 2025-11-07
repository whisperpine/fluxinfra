{
  description = "A Nix-flake-based development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import inputs.nixpkgs { inherit system; }; }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              # --- general purpose --- #
              cocogitto # conventional commit toolkit
              git-cliff # generate changelog
              typos # check misspelling
              husky # manage git hooks

              # --- kubernetes ecosystem --- #
              fluxcd # GitOps solution for kubernetes

              # --- dependencies of ./scripts/validate.sh --- #
              kubeconform # kubernetes manifests validator
              kustomize # customization of kubernetes yaml
              yq-go # command-line yaml processor
            ];
            # The shell script executed when the environment is activated.
            shellHook = ''
              # Print the last modified date of "flake.lock".
              stat flake.lock | grep "Modify" |
                awk '{printf "\"flake.lock\" last modified on: %s", $2}' &&
                echo " ($((($(date +%s) - $(stat -c %Y flake.lock)) / 86400)) days ago)"
              # install git hook managed by husky
              if [ ! -e "./.husky/_" ]; then
                husky install
              fi
            '';
          };
        }
      );
    };
}
