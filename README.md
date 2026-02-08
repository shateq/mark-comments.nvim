# mark-comments.nvim

a lua plugin for managing your marks *automatically* using buffer comments

> [!CAUTION]
> early stage, expect incompatible plugins & things breaking
> Please report incompatible plugin menus in Issues tab

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
  opts = {}, -- required
}
```

Check [integrations](#integrations) to access more functionality.

## Usage

Every commented line that contains `m:letter`, e.g. `m:a` will create a mark on the beginning of that line. 
Denominators are `m:` and `M:`, first letter after a denominator is the name for a new mark

The `:MarkComments` command reloads the plugin
`:MarkCommentsReset` resets generated marks

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

- [x] Set marks automatically
- [x] Pure API
- [x] Telescope.nvim integration
- [ ] config options
- [ ] header comments
- [ ] docs
- [ ] add photo

## Integrations

### **Telescope.nvim integration**

Put the following snippet somewhere after calling `setup()` for telescope.nvim.
To access the generated marks picker you may use `:Telescope mark-comments` command or create a binding.
In order to configure the picker follow [telescope's readme](https://github.com/nvim-telescope/telescope.nvim/blob/master/README.md).

```lua
require "telescope".setup() -- probably already there

require "telescope".load_extension("mark-comments")
```

### **GutterMarks.nvim integration**

Automatically refreshes the gutter if guttermarks.nvim is installed.
No configuration needed.

## Pairs well with

- [dimtion/guttermarks.nvim](https://github.com/dimtion/guttermarks.nvim)
