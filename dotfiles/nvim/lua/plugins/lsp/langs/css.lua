-- https://github.com/hrsh7th/vscode-langservers-extracted
return {
  settings = {
    css = {
      format = {
        spaceAroundSelectorSeparator = true,
        -- enable = false,
      },
      lint = {
        -- Do not warn for Tailwind's @apply rule
        unknownAtRules = "ignore",
      },
    },
  },
}
