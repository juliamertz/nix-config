local rosepine = {
  main = {
    base = "#191724",
    surface = "#1f1d2e",
    overlay = "#26233a",
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ebbcba",
    pine = "#31748f",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
    highlightLow = "#21202e",
    highlightMed = "#403d52",
    highlightHigh = "#524f67",
  },
  moon = {
    base = "#232136",
    surface = "#2a273f",
    overlay = "#393552",
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ea9a97",
    pine = "#3e8fb0",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
    highlightLow = "#2a283e",
    highlightMed = "#44415a",
    highlightHigh = "#56526e",
  },
  dawn = {
    base = "#faf4ed",
    surface = "#fffaf3",
    overlay = "#f2e9e1",
    muted = "#9893a5",
    subtle = "#797593",
    text = "#575279",
    love = "#b4637a",
    gold = "#ea9d34",
    rose = "#d7827e",
    pine = "#286983",
    foam = "#56949f",
    iris = "#907aa9",
    highlightLow = "#f4ede8",
    highlightMed = "#dfdad9",
    highlightHigh = "#cecacd",
  },
}

---@param colors table pass in either: rosepine.main, rosepine.moon, or rosepine.dawn
local function rose_pine_template(colors)
  return {
    normal = {
      a = { bg = colors.iris, fg = colors.base, gui = "bold" },
      b = { bg = colors.surface, fg = colors.subtle },
      c = { bg = "none", fg = colors.subtle },
    },
    insert = {
      a = { bg = colors.love, fg = colors.text, gui = "bold" },
      b = { bg = colors.surface, fg = colors.subtle },
      c = { bg = "none", fg = colors.subtle },
    },
    visual = {
      a = { bg = colors.pine, fg = colors.text, gui = "bold" },
      b = { bg = colors.foam, fg = colors.base },
      c = { bg = "none", fg = colors.subtle },
    },
    replace = {
      a = { bg = colors.base, fg = colors.text, gui = "bold" },
      b = { bg = colors.surface, fg = colors.muted },
      c = { bg = "none", fg = colors.subtle },
    },
    command = {
      a = { bg = colors.base, fg = colors.text, gui = "bold" },
      b = { bg = colors.surface, fg = colors.muted },
      c = { bg = "none", fg = colors.subtle },
    },
    inactive = {
      a = { bg = colors.highlightLow, fg = colors.muted, gui = "bold" },
      b = { bg = colors.highlightLow, fg = colors.muted },
      c = { bg = "none", fg = colors.muted },
    },
  }
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
  config = function()
    require("lualine").setup({
      options = {
        theme = rose_pine_template(rosepine.moon),
        component_separators = "|",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "" }, right_padding = 2 },
        },
        lualine_b = { "filename", "branch" },
        lualine_c = { "fileformat" },
        lualine_x = {
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end
              return "recording to " .. reg
            end,
          },
        },
        lualine_y = { "filetype", "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {},
      extensions = {},
    })
  end,
}
