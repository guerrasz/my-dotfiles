return {
  "catppuccin/nvim",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        telescope = true,
        treesitter = true,
        notify = true,
      },
      custom_highlights = function(colors)
        return {
          OilDir = { fg = colors.yellow },
          OilDirIcon = { fg = colors.yellow },
        }
      end,
    })

    vim.cmd("colorscheme catppuccin")
  end,
}
