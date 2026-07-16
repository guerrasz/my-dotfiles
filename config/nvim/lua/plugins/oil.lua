return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      columns = {
        {
          "icon",
          directory = "",
          add_padding = false,
        },
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
      view_options = {
        show_hidden = true,
      },
    })

    -- Open oil with <leader>ee
    vim.keymap.set("n", "<leader>ee", "<cmd>Oil<cr>", { desc = "Open parent directory" })
  end,
}
