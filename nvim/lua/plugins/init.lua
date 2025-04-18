return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  -- CopilotChat plugin
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- For curl, log, and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    cmd = { "CopilotChatOpen", "CopilotChatToggle" },
    opts = {
      -- Configuration options
    },
    config = function()
      require("CopilotChat").setup({
        model = 'o4-mini',
        agent = 'copilot',
        -- Optional configuration for CopilotChat
      })
    end
  },

  {
    "ibhagwan/fzf-lua",
    lazy = false, -- Load immediately
    config = function()
      require('fzf-lua').setup({}) -- You can add custom configurations here if needed
      require('fzf-lua').register_ui_select()
    end,
  },
}
