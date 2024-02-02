# Todolist.nvim

This is a neovim plugin, to manage your todos.

When you are working on a project and want to note something and come back to it later, you can add a todolist item. This will be stored and available for checking off/deletion later.

## Features:

1. add todo
2. get all todos that were added from the current file / current project / anywhere
3. marka todo as completed
4. delete a todo

### Add todos
<img src="./assets/add_todo.png" height="400" width="300">

### Display all todos
<img src="./assets/all_todos.png" width="600" height="400">

### Display current file related todos
<img src="./assets/file_todos.png" alt="Display File Related Todos" width="600" height="400">

### Display current project related todos
<img src="./assets/project_todos.png" alt="Display All Todos" width="600" height="400">

## Installation:

```lua
  {
    'swims-hjkl/todolist.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },


  require("todolist")
```

## Keymaps

if you want to change the configuration for keymaps, send these keymaps to the setup 

```lua
  require("todolist").setup({
    add_todo = "<Leader>at",
    show_todo_all = "<Leader>t",
    show_todo_project = "<Leader>pt",
    show_todo_file = "<Leader>ft",
  })
```
