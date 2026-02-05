# mark-comments.nvim

a lua plugin for managing your marks *automatically* using buffer comments

> early stage todo
[x] internal structure
[ ] telescope integration
[ ] config options
[ ] header types
[ ] is it any good

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

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "shateq/mark-comments.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
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

### Features

> completed only

### Integrations

- Treesitter for comment detection

TODO: telescope choose only defined marks/headers

### Pairs well with

- [dimtion/guttermarks.nvim](https://github.com/dimtion/guttermarks.nvim)
