return {
  {
    "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = {
        flavour = "mocha",
        transparent_background = true,
        styles = {
          keywords = { "italic" },
          booleans = { "italic" },
          loops = { "bold" },
          functions = { "italic", "bold" },
        },
        color_overrides = {
          all = {
            rosewater = "#a6e3a1",
            flamingo = "#f2cdcd",
            pink = "#a5bef0",
            mauve = "#94e2d5",
            red = "#f38ba8",
            maroon = "#eba0ac",
            peach = "#fab387",
            yellow = "#f5c2e7",
            green = "#f5e0dc",
            teal = "#cba6f7",
            sky = "#89dceb",
            sapphire = "#74c7ec",
            blue = "#b4befe",
            lavender = "#f9e2af",
            text = "#cdd6f4",
            subtext1 = "#bac2de",
            subtext0 = "#a6adc8",
            overlay2 = "#9399b2",
            overlay1 = "#7f849c",
            overlay0 = "#6c7086",
            surface2 = "#585b70",
            surface1 = "#45475a",
            surface0 = "#313244",
            mantle = "#12121c",
            base = "#181825",
            crust = "#11111b",
          },
        },
        custom_highlights = function(colors)
          local custom_colors = {
            bg = "#10101a",
            bright_bg = "#666666",
            fg = "#D7D5EA",
            dim_fg = "#272727",
            bright_fg = "#cdcdcd",
          }
        return {
          -- FLOATS --
            NormalFloat = { bg = colors.mantle },
          FloatBorder = { bg = colors.mantle, fg = colors.mantle },
          FloatTitle = { bg = "#293543", fg = colors.mauve, bold = true, italic = true },
          Pmenu = { bg = colors.mantle },
          PmenuSbar = { bg = colors.overlay0 },
          PmenuThumb = { bg = colors.overlay0 },

          -- STATUS COL --
            FoldColumn = { bg = "none", fg = custom_colors.bright_bg },
          LineNr = { fg = custom_colors.fg, bold = true },
          LineNrAbove = { fg = "#454545" },
          LineNrBelow = { fg = "#454545" },

          -- SEPARATORS --
            WinSeparator = { fg = "#404040" },
          NeoTreeTabSeparatorInactive = { bg = "none", fg = "#202020" },
          NeoTreeWinSeparator = { fg = custom_colors.dim_fg },

          -- SYNTAX --
            ["@property"] = { fg = colors.text, bold = true },
          ["@parameter"] = { fg = colors.text, italic = true },
          ["@keyword.function"] = { fg = colors.blue, italic = true, bold = true },
          ["@keyword.return"] = { fg = colors.blue, italic = true, bold = true },
          ["@markup.quote"] = { fg = colors.text, italic = true },
          ["@module"] = { fg = colors.yellow },
          ["@variable.member"] = { fg = "#D7D5EA", bold = true },
          ["@variable.builtin"] = { fg = colors.sky },
          ["@function.builtin"] = { fg = colors.sky, bold = true, italic = true },
          Constant = { fg = colors.lavender },
          ["@constant.builtin"] = { fg = colors.lavender, italic = true },
          Operator = { fg = colors.green },
          Label = { fg = colors.blue, bold = true },

          Cursor = { bg = "#F0F0F0" },
          TermCursor = { bg = "#F0F0F0" },

          -- STATUS LINE --
            HeirlineNormal = { fg = colors.blue, bg = colors.blue },
          HeirlineVisual = { fg = colors.rosewater, bg = colors.rosewater },
          HeirlineInsert = { fg = colors.yellow, bg = colors.yellow },
          HeirlineTerminal = { fg = colors.pink, bg = colors.pink },
          HeirlineReplace = { fg = colors.subtext0, bg = colors.subtext0 },
          HeirlineCommand = { fg = colors.flamingo, bg = colors.flamingo },
          HeirlineInactive = { fg = "#777777", bg = "#777777" },
          StatusNormal = { fg = colors.blue, bg = colors.blue },
          StatusVisual = { fg = colors.rosewater, bg = colors.rosewater },
          StatusInsert = { fg = colors.yellow, bg = colors.yellow },
          StatusTerminal = { fg = colors.pink, bg = colors.pink },
          StatusReplace = { fg = colors.subtext0, bg = colors.subtext0 },
          StatusCommand = { fg = colors.flamingo, bg = colors.flamingo },
          StatusInactive = { fg = "#777777", bg = "#777777" },

          -- GITSIGNS --
            GitSignsAdd = { fg = "#94cbba" },
          GitSignsChange = { fg = "#EFD0A3" },
          GitSignsDelete = { fg = "#E68F8F" },

          -- DIFF --
            DiffAdd = { bg = "#2D453F" },
          DiffDelete = { bg = "#6B373F" },
          diffNewFile = { fg = colors.yellow },
          diffAdded = { fg = colors.rosewater },
          DiffviewFilePanelInsertions = { fg = colors.rosewater },
          DiffviewFilePanelSelected = { fg = colors.text, bold = true, italic = true },
          DiffviewHash = { fg = colors.mauve },
          DiffviewFilePanelCounter = { fg = colors.yellow },
          gitDate = { fg = colors.text, italic = true },

          -- SNACKS --
            snacksDashboardDir = { fg = "#afafaf", italic = true },
          SnacksDashboardFile = { fg = colors.yellow },
          SnacksDashboardIcon = { fg = colors.yellow },
          SnacksDashboardKey = { fg = colors.pink },
          SnacksDashboardDesc = { fg = custom_colors.bright_fg },
          SnacksDashboardHeader = { fg = custom_colors.bright_fg },
          SnacksDashboardFooter = { fg = custom_colors.bright_fg },
          SnacksDashboardTitle = { fg = custom_colors.bright_fg },
          SnacksDashboardSpecial = { fg = custom_colors.bright_fg },
          SnacksIndent = { bg = "none", fg = custom_colors.dim_fg },
          SnacksIndentScope = { bg = "none", fg = colors.blue },
          SnacksNotifierHistory = { link = "NormalFloat" },

          -- DIAGNOSTICS --
            DiagnosticSignError = { fg = colors.red },
          DiagnosticVirtualTextError = { fg = colors.red, bg = "#31272a", bold = true, italic = true },
          DiagnosticSignWarn = { fg = colors.lavender },
          DiagnosticUnderlineWarn = { sp = colors.lavender },
          DiagnosticVirtualTextWarn = { fg = colors.lavender, bg = "#312f27", bold = true, italic = true },
          DiagnosticWarn = { fg = colors.lavender },
          DiagnosticSignInfo = { fg = colors.blue },
          DiagnosticVirtualTextInfo = { fg = colors.blue, bg = "#272931", bold = true, italic = true },
          DiagnosticInfo = { fg = colors.blue },
          DiagnosticSignHint = { fg = colors.mauve },
          DiagnosticVirtualTextHint = { fg = colors.mauve, bg = "#27312F", bold = true, italic = true },
          DiagnosticHint = { fg = colors.mauve },
          DiagnosticSignOk = { fg = colors.rosewater },
          DiagnosticUnderlineOk = { sp = colors.rosewater },
          DiagnosticVirtualTextOk = { fg = colors.rosewater, bg = "#283127", bold = true, italic = true },
          DiagnosticUnnecessary = { fg = "#777777", italic = true },

          -- TELESCOPE / FZF --
            TelescopeNormal = { bg = colors.mantle },
          TelescopeBorder = { fg = colors.mantle, bg = colors.mantle },
          TelescopeResultsTitle = { bg = colors.yellow, fg = colors.mantle, italic = true, bold = true },
          TelescopePreviewTitle = { bg = colors.rosewater, fg = colors.mantle, italic = true, bold = true },
          TelescopePromptTitle = { bg = colors.yellow, fg = colors.mantle, italic = true, bold = true },
          FzfNormal = { bg = colors.mantle },
          FzfBorder = { fg = colors.mantle, bg = colors.mantle },

          -- NEOTEST --
            NeotestAdapterName = { fg = colors.mauve, bold = true },
          NeotestRunning = { fg = colors.text },
          NeotestTest = { fg = colors.text, italic = true },
          NeotestDir = { fg = colors.blue, underline = true },
          NeotestPassed = { fg = colors.rosewater, bold = true },
          NeotestFailed = { fg = colors.red, bold = true },
          NeotestFile = { fg = colors.yellow },
          NeotestFocused = { bold = true },

          -- FLASH --
            FlashMatch = { bg = colors.red, bold = true },
          FlashLabel = { fg = colors.text, bold = true },

          -- FLOG --
            flogBranch0 = { fg = colors.rosewater },
          flogBranch1 = { fg = colors.rosewater },
          flobBranch2 = { fg = colors.lavender },
          flogBranch3 = { fg = colors.peach },
          flogBranch4 = { fg = colors.red },
          flogBranch5 = { fg = colors.yellow },
          flogBranch6 = { fg = colors.teal },
          flogBranch7 = { fg = colors.pink },
          flogBranch8 = { fg = colors.sky },
          flogDate = { fg = colors.blue, italic = true },

          -- WHICHKEY --
            WhichKeyDesc = { fg = colors.text },

          -- MASON --
            MasonHeader = { bg = colors.green, fg = colors.mantle, italic = true, bold = true },
          MasonHighlight = { fg = colors.pink, bold = true },

          -- LAZY --
            LazyButton = { fg = colors.text, italic = true, bold = true },
          LazyButtonActive = { bg = colors.mauve, fg = colors.mantle, bold = true, italic = true },

          -- UFO --
            UfoFoldedEllipsis = { bg = "NONE", fg = colors.subtext1 },

          -- MARKDOWN --
            -- RenderMarkdownCode = { bg = colors.mantle },
          -- RenderMarkdownH1Bg = { bg = "#272D31", fg = colors.pink, bold = true },
          -- RenderMarkdownH2Bg = { bg = "#312730", fg = colors.yellow, bold = true },
          -- RenderMarkdownH3Bg = { bg = "#273127", fg = colors.rosewater, bold = true },
          -- RenderMarkdownH4Bg = { bg = "#312f27", fg = colors.lavender, bold = true },
          -- RenderMarkdownH5Bg = { bg = "none" },
          -- RenderMarkdownH6Bg = { bg = "none" },
        }
        end,
      },
      config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
      end,
  },
}
