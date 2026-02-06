# mark-comments.nvim

a lua plugin for managing your marks *automatically* using buffer comments

> [!CAUTION]
> early stage, expect incompatible plugins & things breaking

### Why
<!-- m:a -->

I had to manage multiple files of the same structure and edit only the headers below the comments, so I had to overemploy the search feature. mark-comments drastically improves workflow with a loads of auto-generated files that may include marked comments.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Integrations](#integrations)
<!-- - [Changelog](https://github.com/shateq/mark-comments.nvim/blob/master/doc/changelog.txt) -->

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "shateq/mark-comments.nvim",
  -- optional, supports more parsers 
  -- dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- lazy loading supported
  event = { "BufWinEnter", "BufEnter", "BufWritePost" },
  opts = {},
}
```

## Usage

Every commented line that contains `m:letter`, e.g. `m:a` will create a mark on the beginning of that line. 
Denominators are `m:` and `M:`, first letter after a denominator is the name for a new mark

The `:MarkComments` command reloads the plugin

### Examples

Got a typst file

```typst
// Title and quick summary M:b
= Heading 1
Mark `b` has been set on the line above Heading because it contains `M:b`

== Summary
// m:s Edit below
Mark `s` created on the line above for quick traversal
```

## Features

> [!NOTE] 
> TODO

- [x] internal structure
- [ ] telescope integration
- [ ] config options
- [ ] header types
- [x] is it any good
- [ ] docs
- [ ] add photo
- [ ] study global marks and number marks

### Integrations

> [!NOTE] 
> TODO telescope choose only defined marks/headers

- Treesitter is strongly recommended for comment detection of all filetypes

## Pairs well with

- [dimtion/guttermarks.nvim](https://github.com/dimtion/guttermarks.nvim)
