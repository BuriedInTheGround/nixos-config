{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let nixBin =
  writeShellScriptBin "nix" ''
    ${nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in mkShell {
  buildInputs = [
    git
    bat
    nix-bash-completions
    nix-zsh-completions
  ];
  shellHook = ''
    export PATH="${nixBin}/bin:$PATH"
  '';
}
