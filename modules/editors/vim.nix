{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.editors.vim;
  configDir = config.my.configDir;
in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;

    supportLSP = mkOpt' [] ''
      List of programming languages for which activate LSP support.

      Supported languages:
      - bash (not sure)
      - go
      - nix
      - python
      - svelte (not sure)
      '' (types.listOf types.str);

    supportTreesitter = mkOpt' [] ''
      List of programming languages for which activate Tree-sitter support.

      Supported languages are all that has the prefix `tree-sitter-` in
      https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars.
      '' (types.listOf types.str);
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      (mkIf (elem "bash" cfg.supportLSP)   nodePackages.bash-language-server)
      (mkIf (elem "go" cfg.supportLSP)     gopls)
      (mkIf (elem "nix" cfg.supportLSP)    rnix-lsp)
      (mkIf (elem "python" cfg.supportLSP) pyright)
      (mkIf (elem "svelte" cfg.supportLSP) nodePackages.svelte-language-server)
    ];

    programs.neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      vimAlias = true;
      configure = let
        nvimConfigDir = "${config.user.home}/.config/nvim";
      in {
        customRC = ''
          source ${nvimConfigDir}/init.vim
          ${if (elem "bash" cfg.supportLSP)   then "source ${nvimConfigDir}/lang/bash.vim"   else ""}
          ${if (elem "go" cfg.supportLSP)     then "source ${nvimConfigDir}/lang/go.vim"     else ""}
          ${if (elem "nix" cfg.supportLSP)    then "source ${nvimConfigDir}/lang/nix.vim"    else ""}
          ${if (elem "python" cfg.supportLSP) then "source ${nvimConfigDir}/lang/python.vim" else ""}
          ${if (elem "svelte" cfg.supportLSP) then "source ${nvimConfigDir}/lang/svelte.vim" else ""}
        '';
        packages.myPlugins = with pkgs.unstable.vimPlugins; {
          start = [
            # Tree-sitter.
            (nvim-treesitter.withPlugins (
              plugins: map (x: plugins."${x}") (
                map (x: "tree-sitter-" + x) cfg.supportTreesitter)
            ))
            nvim-treesitter-textobjects
            playground # View tree-sitter information directly in Neovim!

            # LSP & Autocompletion.
            nvim-lspconfig
            nvim-cmp
            cmp-nvim-lsp
            cmp_luasnip
            luasnip

            # Theme and airline.
            nord-vim
            vim-monokai
            vim-airline
            vim-airline-themes

            # Telescope.
            nvim-web-devicons
            plenary-nvim
            telescope-nvim

            # TODO: remove when https://github.com/cstrahan/tree-sitter-nix/issues/17 is solved.
            vim-nix
          ];
        };
      };
    };

    home.configFile = {
      "nvim" = {
        source = "${configDir}/nvim";

        # Match the directory structure of `${configDir}/nvim` and symlink only
        # leaf nodes (files).
        recursive = true;
      };
    };

    env.EDITOR = "vim"; # Symlinked to nvim with `vimAlias` option.
  };
}
