# hidenv.nvim

*A Neovim plugin that dynamically hides environment variables in your buffer.*

**Features:**

* Real-time hiding of environment variables.

**Installation:**

Add `leonardo-luz/hidenv.nvim` to your Neovim plugin manager (e.g., in your `init.lua` or `plugins/hidenv.lua`).  For example:

```lua
{ 
    'leonardo-luz/hidenv.nvim',
    opts = {
        active = false
    }
}
```

**The plugin is active by default if the `active` option is set to `true` in the configuration.**

**Usage:**

* `:Hidenv`: Hides environment variables in the current buffer.
* `:HidenvStart`: Starts the hidenv plugin.
* `:HidenvStop`: Stops the hidenv plugin.
