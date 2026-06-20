{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    opts = {
      tabstop = 4;
    };
    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
    plugins.neo-tree.enable = true;
    plugins.web-devicons.enable = true;
    plugins.mini.enable = true;
    plugins.smear-cursor = {
      enable = true;
    };
    plugins.presence = {
      enable = true;
    };
    plugins.java = {
      enable = true;
      settings = {
        spring_boot_tools = {
          enable = false;
        };
        root_markers = [
          "settings.gradle"
          "settings.gradle.kts"
          "pom.xml"
          "build.gradle"
          "mvnw"
          "gradlew"
          "build.gradle"
          "build.gradle.kts"
          ".git"
        ];
      };
    };

    plugins.lsp = {
      enable = true;
      servers.jdtls = {
        enable = true;
      };
    };

    # Rust: rustaceanvim manages rust-analyzer directly
    plugins.rustaceanvim.enable = true;

    # Cargo.toml dependency management
    plugins.crates.enable = true;

    # Completion
    plugins.cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        };
      };
    };
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-path.enable = true;
    plugins.luasnip.enable = true;

    # Format on save with rustfmt
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft.rust = [ "rustfmt" ];
        format_on_save = {
          timeout_ms = 500;
          lsp_fallback = true;
        };
      };
    };

    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "<A-CR>";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code actions";
      }
    ];

    extraPlugins = [
      # pkgs.vimPlugins.quick-scope
    ];
  };
}
