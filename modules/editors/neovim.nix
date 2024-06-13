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
        python311Packages.python-lsp-server
        tailwindcss-language-server
        typst-lsp
        vscode-langservers-extracted
        yaml-language-server

        # Formatters
        nixfmt-rfc-style
        stylua
        typstyle

        # Requirements
        charm-freeze
        nodejs
        tree-sitter
        gotools
    ];

    environment.shellAliases = mkIf cfg.vimAlias {
      vim = "nvim";
    };

    env.EDITOR = (if cfg.vimAlias then "vim" else "nvim");
  };
}
