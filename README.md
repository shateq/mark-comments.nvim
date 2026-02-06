# mark-comments.nvim

a lua plugin for managing your marks *automatically* using buffer comments

> [!CAUTION]
> early stage, expect incompatible plugins & things breaking

### Why

I had to manage multiple files of the same structure and edit only the headers below the comments, so I had to overemploy the search feature. mark-comments drastically improves workflow with a loads of auto-generated files that may include marked comments.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Integrations](#integrations)
<!-- - [Changelog](https://github.com/shateq/mark-comments.nvim/blob/master/doc/changelog.txt) -->

## Installation

- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) is required

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "shateq/mark-comments.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- lazy loading support
  -- event = { "BufWinEnter", "BufEnter" },
  opts = {},
}
```

## Usage

The `:MarkComments` command reloads the plugin

- initial commit: every line starting with // becomes a comment
every `m:` (`M:`) symbol is mark denominator
first letter (a-z) after the denominator is a mark name

### Examples
```typst
// M: b
May mark be set on the first columen of the line above, use `b
```

## Features

> [!NOTE] 
> TODO

- [x] internal structure
- [ ] telescope integration
- [ ] config options
- [ ] header types
- [ ] is it any good
- [ ] docs

### Integrations

> [!NOTE] 
> TODO telescope choose only defined marks/headers

- Treesitter for comment detection

## Pairs well with

- [dimtion/guttermarks.nvim](https://github.com/dimtion/guttermarks.nvim)
