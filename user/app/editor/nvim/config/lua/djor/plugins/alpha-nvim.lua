return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require('alpha.themes.dashboard')

    dashboard.section.header.val = {
      [[                               __                ]],
      [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
      [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
      [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
      [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
      [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    }
    dashboard.section.buttons.val = {
      dashboard.button('e', 'New file'),
      dashboard.button('<leader>pf', 'Find File'),
      dashboard.button('<leader>gs', 'Find word'),
      dashboard.button('<leader>op', 'Harpoon Bookmarks'),
      dashboard.button('<leader>pr', 'Trouble open diagnostics'),
    }

    alpha.setup(dashboard.config)
  end
}
