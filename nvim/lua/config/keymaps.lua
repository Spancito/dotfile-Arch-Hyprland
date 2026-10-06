local map = vim.keymap.set

map({ "n", "v" }, "i", "k", { desc = "Mover arriba" })
map({ "n", "v" }, "k", "j", { desc = "Mover abajo" })
map({ "n", "v" }, "j", "h", { desc = "Mover izquierda" })
map({ "n", "h" }, "h", "i", { desc = "Insertar texto" })
