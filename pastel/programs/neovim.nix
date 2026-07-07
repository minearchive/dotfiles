{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;

    # Space as leader so the <leader>w window-nav fallbacks (see below) are ergonomic.
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      number = true;
      signcolumn = "yes";
      termguicolors = true;
      # Horizontal toggleterm + new splits open below/right.
      splitbelow = true;
      splitright = true;
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

    # Rust: rustaceanvim drives rust-analyzer. The binary is provided by Nix
    # (home.packages → rust-analyzer), so pin server.cmd to the store path
    # instead of relying on mason.nvim / PATH.
    plugins.rustaceanvim = {
      enable = true;
      settings = {
        server = {
          cmd = [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ];
          default_settings = {
            "rust-analyzer" = {
              cargo = {
                allFeatures = true;
                buildScripts.enable = true;
              };
              procMacro.enable = true;
              # Real-time diagnostics via cargo check on save.
              # Swap to `check.command = "clippy"` if clippy is installed.
              checkOnSave = true;
              # Code lenses (Run | Debug | references / implementations).
              lens.enable = true;
              # Inline type hints (the editor toggle itself is enabled in the
              # LspAttach autocmd below).
              inlayHints = {
                bindingModeHints.enable = true;
                closureReturnTypeHints.enable = "always";
                lifetimeElisionHints = {
                  enable = "always";
                  useParameterNames = true;
                };
                parameterHints.enable = true;
                typeHints.enable = true;
              };
            };
          };
        };
      };
    };

    # Cargo.toml dependency management
    plugins.crates.enable = true;

    # Terminal: toggle a horizontal split at the bottom of the screen.
    plugins.toggleterm = {
      enable = true;
      settings = {
        direction = "horizontal";
        size = 15;
        shade_terminals = true;
        start_in_insert = true;
        persist_size = true;
        close_on_exit = true;
      };
    };

    # Fuzzy finding. <C-f> = inside current buffer, <C-S-f> = grep across files
    # (ripgrep is provided by Nix in home.packages).
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<C-f>" = {
          action = "current_buffer_fuzzy_find";
          options.desc = "Find in current buffer";
        };
        "<C-S-f>" = {
          action = "live_grep";
          options.desc = "Grep across all files";
        };
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "List buffers";
        };
      };
    };

    # Buffers shown as tabs along the top.
    plugins.bufferline = {
      enable = true;
      settings.options = {
        diagnostics = "nvim_lsp";
        separator_style = "slant";
        show_buffer_close_icons = true;
        show_close_icon = false;
        offsets = [
          {
            filetype = "neo-tree";
            text = "File Explorer";
            highlight = "Directory";
            separator = true;
          }
        ];
      };
    };

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
          "<C-u>" = "cmp.mapping.scroll_docs(4)";
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

    # Format on save with rustfmt (rustfmt provided by Nix in home.packages)
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

    autoCmd = [
      {
        event = [ "LspAttach" ];
        desc = "Enable inlay hints + code lenses when an LSP attaches";
        callback.__raw = ''
          function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
            if client and client.server_capabilities.codeLensProvider and vim.lsp.codelens then
              if vim.lsp.codelens.enable then
                vim.lsp.codelens.enable(true, { bufnr = bufnr })
              else
                vim.lsp.codelens.refresh()
              end
            end
          end
        '';

      }
    ];

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

      # --- Terminal (toggleterm, horizontal at the bottom) ---
      {
        mode = "n";
        key = "<C-\\>";
        action = "<cmd>ToggleTerm<CR>";
        options.desc = "Toggle terminal";
      }
      {
        mode = "t";
        key = "<C-\\>";
        action = "<cmd>ToggleTerm<CR>";
        options.desc = "Toggle terminal";
      }
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Terminal: leave insert mode";
      }

      # --- Bufferline: tab switching ---
      {
        mode = "n";
        key = "<C-Tab>";
        action = "<cmd>BufferLineCycleNext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<C-S-Tab>";
        action = "<cmd>BufferLineCyclePrev<CR>";
        options.desc = "Previous buffer";
      }
      # Fallbacks
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<CR>";
        options.desc = "Previous buffer";
      }

      # --- Close current buffer ---
      {
        mode = "n";
        key = "<leader>c";
        action = "<cmd>bdelete<CR>";
        options.desc = "Close buffer";
      }
    ];

    extraPlugins = [
      # pkgs.vimPlugins.quick-scope
    ];
  };
}
