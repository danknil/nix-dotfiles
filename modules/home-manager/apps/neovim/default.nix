{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.neovim;
  # map' = added: key: action: {
  #   inherit key action;
  # } // added;
  # map = map' { };
  #
  # nmap' = added: map' ({ mode = [ "n" ]; } // added);
  # nmap = nmap' {};

  map = mapping:
    lib.flatten (lib.mapAttrsToList
      (mode: data: (lib.mapAttrsToList
        (key: {
          lua ? false,
          action ? null,
          options ? {},
        }: {
          inherit lua action options mode key;
        })
        data))
      mapping);
in
  with lib;
  with lib.dnix; {
    options.apps.neovim = {
      enable = mkEnableOption "Neovim";
    };

    config = mkIf cfg.enable {
      home.packages = [pkgs.neovide];

      xdg.mimeApps.defaultApplications = valueForEach [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ] "neovide.desktop";

      programs.nixvim = enabled' {
        viAlias = true;
        vimAlias = true;

        defaultEditor = true;

        luaLoader = enabled;
        clipboard.providers.wl-copy = enabled;

        extraPlugins = with pkgs.vimPlugins; [
          gruvbox-material
          nvim-surround
        ];

        # appending here because nixvim doesnt support it rn
        extraConfigLua = ''
          vim.opt.shortmess:append 'FcsIW'
          require'nvim-surround'.setup {}
        '';

        extraConfigVim = ''
          let g:gruvbox_material_background = 'medium'
          colorscheme gruvbox-material
        '';

        globals = {
          mapleader = " ";
          netrw_banner = 0;
        };

        opts = {
          laststatus = 3;
          showmode = false;

          title = true;
          clipboard = "unnamedplus";

          fillchars = {eob = " ";};
          ignorecase = true;
          smartcase = true;
          mouse = "nv";
          mousemodel = "extend";

          # Numbers
          number = true;
          relativenumber = true;
          numberwidth = 2;
          ruler = false;

          signcolumn = "yes";
          splitbelow = true;
          splitright = true;
          tabstop = 8;
          termguicolors = true;
          timeoutlen = 400;
          undofile = true;
          scrolloff = 8;
          sidescrolloff = 8;

          completeopt = ["menu" "noselect"];

          background = config.colorscheme.variant;
        };

        # colorschemes.gruvbox = enabled' {
        #   settings = {
        #     inverse = true;
        #     transparent_mode = true;
        #     italic = {
        #       strings = false;
        #       emphasis = false;
        #       comments = false;
        #       operators = false;
        #       folds = false;
        #     }; };
        # };

        autoGroups.numbs.clear = true;
        autoCmd = [
          {
            event = "InsertEnter";
            group = "numbs";
            callback.__raw = ''
              function()
                  if not vim.tbl_contains({ 'TelescopePrompt', 'netrw', 'zsh' }, vim.bo.filetype) then
                      vim.opt.colorcolumn = "80"
                      vim.opt.number = false
                      vim.opt.relativenumber = false
                  end
              end
            '';
          }

          {
            event = "InsertLeave";
            group = "numbs";
            callback.__raw = ''
              function()
                  if not vim.tbl_contains({ 'TelescopePrompt', 'netrw', 'zsh' }, vim.bo.filetype) then
                      vim.opt.colorcolumn = "80"
                      vim.opt.number = true
                      vim.opt.relativenumber = true
                  end
              end
            '';
          }
        ];

        keymaps = map {
          n = {
            "<space>" = {
              action = "<cmd>noh<cr>";
              options.silent = true;
            };
            "<leader>e" = {
              action = ''
                function()
                    -- TODO: rework to disable in certain situations
                    local bufdir = utils.get_curr_bufdir()
                    return ':e ' .. bufdir
                end
              '';
              lua = true;
              options.expr = true;
            };
            "<C-c>" = {
              action = "<cmd>%y+<cr>";
              options.silent = true;
            };
            "<Tab>" = {
              action = "<cmd>bn<cr>";
              options.silent = true;
            };
            "<S-Tab>" = {
              action = "<cmd>bp<cr>";
              options.silent = true;
            };
            "gr".action = "<cmd>Trouble lsp_references<cr>";
            "<leader>d".action = "<cmd>Trouble workspace_diagnostics<cr>";
            "<leader>D".action = "<cmd>TodoTelescope<cr>";
            "<leader>tp".action = "<cmd>lua require'telescope'.extensions.projects.projects{}<cr>";
          };
          i = {
            "<C-n>".action = "<Plug>(luasnip-next-choice)";
            "<C-p>".action = "<Plug>(luasnip-prev-choice)";

            "<Esc>" = {
              action = ''pumvisible() ? "\<C-e><Esc>" : "\<Esc>"'';
              options = {
                noremap = true;
                expr = true;
                silent = true;
              };
            };
            "<C-c>" = {
              action = ''pumvisible() ? "\<C-e><C-c>" : "\<C-c>"'';
              options = {
                noremap = true;
                expr = true;
                silent = true;
              };
            };
            # "<BS>" = {
            #   action = ''pumvisible() ? "\<C-e><BS>"  : "\<BS>"'';
            #   options = {
            #     noremap = true;
            #     expr = true;
            #     silent = true;
            #   };
            # };
            "<CR>" = {
              action = ''pumvisible() ? (complete_info().selected == -1 ? "\<C-n>" : "\<C-y>") : "\<CR>"'';
              options = {
                noremap = true;
                expr = true;
                silent = true;
              };
            };
            "<Tab>" = {
              action = ''pumvisible() ? (complete_info().selected == -1 ? "\<C-n><C-y>" : "\<C-n>") : "\<Tab>"'';
              options = {
                noremap = true;
                expr = true;
                silent = true;
              };
            };
            "<S-Tab>" = {
              action = ''pumvisible() ? "\<C-p>" : "\<BS>"'';
              options = {
                noremap = true;
                expr = true;
                silent = true;
              };
            };
          };
          s = {
            "<C-n>".action = "<Plug>(luasnip-next-choice)";
            "<C-p>".action = "<Plug>(luasnip-prev-choice)";
          };
        };

        plugins = {
          treesitter = enabled' {
            nixvimInjections = true;
          };

          # ui
          # alpha = enabled' {
          #   iconsEnabled = false;
          #   theme = "dashboard";
          # };
          project-nvim = enabled' {
            enableTelescope = true;
          };
          todo-comments = enabled;
          indent-blankline = enabled;
          gitsigns = enabled;
          trouble = enabled;
          noice = enabled;
          barbecue = enabled' {
            leadCustomSection = ''
              function()
                return { { " ", "WinBar" } }
              end,
            '';
          };
          oil = enabled;
          bufferline = enabled' {
            alwaysShowBufferline = true;
            bufferCloseIcon = null;
            closeIcon = null;
            diagnostics = "nvim_lsp";
            separatorStyle = "thick";
          };
          lualine = enabled' {
            iconsEnabled = false;
            globalstatus = true;
            componentSeparators = {
              left = " ";
              right = " ";
            };
            sectionSeparators = {
              left = " ";
              right = " ";
            };
            sections = {
              lualine_b = [""];
              lualine_c = [""];
              lualine_x = [""];
              lualine_y = [""];
            };
            inactiveSections = {
              lualine_c = [""];
              lualine_x = [""];
            };
          };

          # editing
          comment = enabled;
          leap = enabled;
          inc-rename = enabled;
          sleuth = enabled;

          # lsp
          nvim-jdtls = enabled' {
            data = "${config.xdg.cacheHome}/jdtls/data";
            configuration = "${config.xdg.cacheHome}/jdtls/configuration";
          };
          clangd-extensions = enabled;
          rust-tools = enabled;
          lsp = enabled' {
            servers = {
              # lua
              lua-ls = enabled;
              # nix
              nil_ls = enabled;
              # web
              cssls = enabled;
              html = enabled;
              emmet_ls = enabled;
              tsserver = enabled;
              # rust
              rust-analyzer = enabled' {
                installRustc = true;
                installCargo = true;
              };
              # java
              java-language-server = enabled;
              # c/c++
              clangd = enabled;
              # julia
              julials = enabled;
            };
            keymaps.lspBuf = {
              "gD" = "declaration";
              "gd" = "definition";
              "K" = "hover";
              "gi" = "implementation";
              "<C-k>" = "signature_help";
              "<leader>rn" = "rename";
              "<leader>ca" = "code_action";
            };
            keymaps.extra =
              map
              {
                n."<leader>bf" = {
                  action = ''
                    function()
                        vim.lsp.buf.format { async = true }
                    end
                  '';
                  lua = true;
                };
              };
          };
          none-ls = enabled' {
            sources = {
              formatting = {
                stylua = enabled;

                goimports = enabled;
                golines = enabled;
                gofumpt = enabled;

                prettierd = enabled;
                markdownlint = enabled;

                nixpkgs_fmt = enabled;
              };
              code_actions = {
                statix = enabled;
                refactoring = enabled;
                ts_node_action = enabled;
              };
              diagnostics = {
                dotenv_linter = enabled;
                editorconfig_checker = enabled;
              };
            };
          };

          # cmp
          luasnip = enabled;
          #codeium = enabled;
          coq-nvim = enabled' {
            installArtifacts = true;
            settings = let
              client = name: weight: {
                short_name = name;
                weight_adjust = weight;
              };
            in {
              auto_start = "shut-up";
              keymap.recommended = false;
              clients = {
                snippets = client "SN" 8;
                lsp = client "LSP" 5;
                tree_sitter = client "TS" 4;
                buffers = client "BUF" 2;
              };
              display = {
                icons.mode = "none";
                ghost_text.context = [" " " "];
                statusline.helo = false;
                pum = {
                  y_max_len = 5;
                  y_ratio = 0.1;
                  x_max_len = 40;
                  kind_context = [" [ " " ] "];
                  source_context = [" " " "];
                };
                preview.positions = {
                  north = 2;
                  east = 1;
                  west.__raw = "null";
                  south.__raw = "null";
                };
              };
            };
          };
          coq-thirdparty = enabled' {
            sources = [
              #{ src = "codeium"; short_name = "COD"; }
              {
                src = "bc";
                short_name = "MATH";
                precision = 6;
              }
              {
                src = "nvimlua";
                short_name = "nLUA";
                conf_only = true;
              }
            ];
          };
          # lspkind = enabled;
          # cmp = enabled' {
          #   settings = {
          #     window = {
          #       completion = {
          #         #border = [ " " " " " " " " " " " " " " " " ];
          #         scrollbar = false;
          #         winhighlight = "Normal:pmenu;FloatBorder:pmenu;Search:None";
          #         col_offset = -3;
          #         side_padding = 1;
          #       };
          #       documentation = {
          #         border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
          #         scrollbar = false;
          #       };
          #     };
          #     formatting.fields = [ "kind" "abbr" "menu" ];
          #     snippent.expand = ''
          #       function(args)
          #         require('luasnip').lsp_expand(args.body)
          #       end
          #     '';
          #     sources = [
          #       { name = "path"; priority = 8; max_item_count = 2; }
          #       { name = "luasnip"; priority = 5; max_item_count = 4; }
          #       { name = "nvim_lsp"; priority = 3; max_item_count = 16; }
          #       { name = "buffer"; priority = 1; keyword_length = 2; max_item_count = 8; }
          #     ];
          #     mapping = {
          #       "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          #       "<C-f>" = "cmp.mapping.scroll_docs(4)";
          #       "<CR>" = ''
          #         cmp.mapping.confirm {
          #           behavior = cmp.ConfirmBehavior.Replace,
          #           select = true,
          #         }
          #       '';
          #       "<C-Space>" = ''
          #         cmp.mapping.select_next_item {
          #             behavior = cmp.SelectBehavior.Select,
          #         }
          #       '';
          #       "<Tab>" = ''
          #         cmp.mapping(function(fallback)
          #             if cmp.visible() then
          #                 local entry = cmp.get_selected_entry()
          #                 if not entry then
          #                     if not require'luasnip'.expand_or_locally_jumpable() then
          #                         cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          #                         cmp.confirm { behavior = cmp.ConfirmBehavior.Replace }
          #                     else
          #                         require'luasnip'.expand_or_jump()
          #                     end
          #                 else
          #                     cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          #                 end
          #             elseif require'luasnip'.expand_or_jumpable() then
          #                 require'luasnip'.expand_or_jump()
          #             else
          #                 require'intellitab'.indent()
          #             end
          #         end, { 'i', 's' })
          #       '';
          #       "<S-Tab>" = ''
          #         cmp.mapping(function(fallback)
          #             if cmp.visible() then
          #                 cmp.select_prev_item()
          #             elseif require'luasnip'.jumpable(-1) then
          #                 require'luasnip'.jump(-1)
          #             else
          #                 fallback()
          #             end
          #         end, { 'i', 's' })
          #       '';
          #     };
          #   };
          # };
          telescope = enabled' {
            settings = {
              defaults = {};
              pickers = {
                find_files = {
                  border = false;
                  layout_strategy = "bottom_pane";
                  layout_config = {
                    height = 0.4;
                    prompt_position = "bottom";
                    preview_cutoff = 9999;
                  };
                };
                live_grep = {
                  border = false;
                  layout_strategy = "bottom_pane";
                  layout_config = {
                    height = 0.4;
                    prompt_position = "bottom";
                    preview_cutoff = 20;
                  };
                };
                diagnostics = {
                  border = false;
                  layout_strategy = "bottom_pane";
                  layout_config = {
                    height = 0.4;
                    prompt_position = "bottom";
                    preview_cutoff = 20;
                  };
                };
              };
            };

            extensions = {
              fzf-native = enabled;
              ui-select = enabled;
            };

            keymapsSilent = true;
            keymaps = let
              tmap = action: {inherit action;};
            in {
              "<leader>f" = tmap "find_files";
              "<leader>td" = tmap "diagnostics";
              "<leader>tt" = tmap "treesitter";
              "<leader>tg" = tmap "live_grep";
              "<leader>tb" = tmap "buffers";
            };
          };
        };
      };
    };
  }
