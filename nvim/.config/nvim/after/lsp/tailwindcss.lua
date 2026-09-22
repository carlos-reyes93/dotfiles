--@type vim.lsp.Config
return {
  filetypes = {
    "css",
    "scss",
    "sass",
    "html",
    "heex",
    "elixir",
    "eruby",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "rust",
    "svelte",
  },
  init_options = {
    userLanguages = {
      rust = "html",
    },
  },
  handlers = {
    ["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr, _)
      vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
    end,
  },
  settings = {
    includeLanguages = {
      rust = "html",
    },
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
      experimental = {
        classRegex = {
          -- 1. Plain string: class="foo bar"
          [[class\s*=\s*"([^"]*)"]],
          -- 2. format!() as attribute value, capturing the first quoted string
          [[class\s*=\s*format!\(\s*"([^"]*)"]],
          -- 3. Tuple/conditional class shorthand: class=("foo bar", some_bool)
          [[class\s*=\s*\(\s*"([^"]*)"]],
          -- 4. class:name=condition (captures the utility name itself)
          [[class:([\w-]+)=]],
          -- 5. class=move || format!("...", ...) — reactive closure wrapping format!
          [[class\s*=\s*move\s*\|\|\s*format!\(\s*"([^"]*)"]],
          -- 6. class=move || "..." — reactive closure returning a plain string
          [[class\s*=\s*move\s*\|\|\s*"([^"]*)"]],
        },

      },
    },
  },
}
