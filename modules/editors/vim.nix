{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.editors.vim;
  coqCfg = config.modules.develop.coq;
  configDir = config.my.configDir;
in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;

    supportLSP = mkOpt' [] ''
      List of programming languages for which activate LSP support.

      Supported languages:
      - bash
      - coq
      - css
      - go
      - json
      - latex
      - lua
      - nix
      - python
      - svelte
      - tailwindcss
      - typescript
      - typst
      - vim
      - yaml
      '' (types.listOf types.str);

    supportTreesitter = mkOpt' [] ''
      List of programming languages for which activate Tree-sitter support.

      Supported languages are all that has the prefix `tree-sitter-` in
      https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars.
      '' (types.listOf types.str);
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf (elem "bash" cfg.supportLSP)        nodePackages.bash-language-server)
      (mkIf (elem "coq" cfg.supportLSP)         coqPackages.coq-lsp)
      (mkIf (elem "css" cfg.supportLSP)         nodePackages.vscode-langservers-extracted)
      (mkIf (elem "go" cfg.supportLSP)          gopls)
      (mkIf (elem "json" cfg.supportLSP)        nodePackages.vscode-langservers-extracted)
      (mkIf (elem "latex" cfg.supportLSP)       texlab)
      (mkIf (elem "lua" cfg.supportLSP)         lua-language-server)
      (mkIf (elem "nix" cfg.supportLSP)         rnix-lsp)
      (mkIf (elem "python" cfg.supportLSP)      pyright)
      (mkIf (elem "svelte" cfg.supportLSP)      nodePackages.svelte-language-server)
      (mkIf (elem "tailwindcss" cfg.supportLSP) nodePackages."@tailwindcss/language-server")
      (mkIf (elem "typescript" cfg.supportLSP)  nodePackages.typescript-language-server)
      (mkIf (elem "typst" cfg.supportLSP)       typst-lsp)
      (mkIf (elem "vim" cfg.supportLSP)         nodePackages.vim-language-server)
      (mkIf (elem "yaml" cfg.supportLSP)        nodePackages.yaml-language-server)
    ];

    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      configure = let
        nvimConfigDir = "${config.user.home}/.config/nvim";
        lspServersDir = "${nvimConfigDir}/lua/interrato/lsp/servers";
      in {
        customRC = ''
          luafile ${nvimConfigDir}/init.lua
          ${if (elem "bash" cfg.supportLSP)        then "luafile ${lspServersDir}/bash.lua"        else ""}
          ${if (elem "coq" cfg.supportLSP)         then "luafile ${lspServersDir}/coq.lua"         else ""}
          ${if (elem "css" cfg.supportLSP)         then "luafile ${lspServersDir}/css.lua"         else ""}
          ${if (elem "json" cfg.supportLSP)        then "luafile ${lspServersDir}/json.lua"        else ""}
          ${if (elem "go" cfg.supportLSP)          then "luafile ${lspServersDir}/go.lua"          else ""}
          ${if (elem "latex" cfg.supportLSP)       then "luafile ${lspServersDir}/latex.lua"       else ""}
          ${if (elem "lua" cfg.supportLSP)         then "luafile ${lspServersDir}/lua.lua"         else ""}
          ${if (elem "nix" cfg.supportLSP)         then "luafile ${lspServersDir}/nix.lua"         else ""}
          ${if (elem "python" cfg.supportLSP)      then "luafile ${lspServersDir}/python.lua"      else ""}
          ${if (elem "svelte" cfg.supportLSP)      then "luafile ${lspServersDir}/svelte.lua"      else ""}
          ${if (elem "tailwindcss" cfg.supportLSP) then "luafile ${lspServersDir}/tailwindcss.lua" else ""}
          ${if (elem "typescript" cfg.supportLSP)  then "luafile ${lspServersDir}/typescript.lua"  else ""}
          ${if (elem "typst" cfg.supportLSP)       then "luafile ${lspServersDir}/typst.lua"       else ""}
          ${if (elem "vim" cfg.supportLSP)         then "luafile ${lspServersDir}/vim.lua"         else ""}
          ${if (elem "yaml" cfg.supportLSP)        then "luafile ${lspServersDir}/yaml.lua"        else ""}
        '';
        packages.myPlugins = with pkgs.vimPlugins; let
          lush-nvim-fixed = pkgs.neovimUtils.buildNeovimPlugin {
            pname = "lush.nvim";
            version = "2023-05-01";
            src = pkgs.fetchFromGitHub {
              owner = "BuriedInTheGround";
              repo = "lush.nvim";
              rev = "fe035690c2e98cfba697701fc7026d6a839ceac1";
              sha256 = "117frxw7gwac21y3xbkc1ykwb5d4cj0fsax78m7bl668b6dvxah7";
            };
          };
          coqtail = if coqCfg.enable then Coqtail else null;
        in {
          start = [
            # --- Tree-sitter ---
            (nvim-treesitter.withPlugins (
              plugins: map (x: plugins."${x}") (
                map (x: "tree-sitter-" + x) cfg.supportTreesitter)
            ))
            nvim-treesitter-textobjects
            playground # View tree-sitter information directly in Neovim!

            # --- LSP & related ---
            nvim-lspconfig # Quickstart configurations for LSP.
            cmp-nvim-lsp # nvim-cmp source for LSP.
            cmp-nvim-lua # nvim-cmp source for Neovim Lua APIs.
            cmp-buffer # nvim-cmp source for buffer words.
            cmp-path # nvim-cmp source for path files/directories.
            nvim-cmp # Completion engine.
            cmp_luasnip # nvim-cmp source LuaSnip.
            luasnip # Snippet engine.
            cmp-latex-symbols # nvim-cmp source for latex symbols.
            cmp-emoji # nvim-cmp source for emojis.
            lspkind-nvim # VSCode-like pictograms for LSP.

            # --- Themes ---
            nord-vim
            vim-monokai
            lush-nvim-fixed # Colorscheme creation aid for Neovim.

            # --- Lualine ---
            lualine-nvim
            lualine-lsp-progress

            # --- Telescope ---
            nvim-web-devicons
            plenary-nvim
            telescope-nvim
            telescope-fzf-native-nvim

            # --- Code Commenting ---
            comment-nvim

            # --- Various Tools ---
            markdown-preview-nvim
            coqtail

            # --- Git ---
            vim-fugitive

            # --- Languages ---
            vim-nix # For a good indentation.
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
