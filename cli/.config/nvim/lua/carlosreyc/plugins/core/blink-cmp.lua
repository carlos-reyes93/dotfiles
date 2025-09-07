return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets', 'folke/lazydev.nvim' },
  version = '1.*',
  opts = {

    keymap = { preset = 'default' },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = { documentation = { auto_show = false } },

    -- sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    sources = { default = { 'lsp', 'path', 'snippets', 'lazydev' }, providers = { lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 } } },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
