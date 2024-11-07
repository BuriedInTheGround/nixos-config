{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.editors.neovim;
in {
  options.modules.editors.neovim = {
    enable = mkBoolOpt false;
    vimAlias = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      neovim

      # Language servers
      asm-lsp
      nodePackages.bash-language-server
      clang-tools
      gopls
      lua-language-server
      ltex-ls
      marksman
      nil
      pyright
      rust-analyzer
      tailwindcss-language-server
      tinymist
      vscode-langservers-extracted
      yaml-language-server

      # Formatters
      gofumpt
      nixfmt-rfc-style
      ruff
      rustfmt
      stylua
      typstyle

      # Requirements
      charm-freeze
      gotools
      nodejs
      tree-sitter
      typst
    ];

    environment.shellAliases = mkIf cfg.vimAlias {
      vim = "nvim";
    };

    env.EDITOR = "nvim";
  };
}
