local opt = vim.o
local cmd = vim.cmd
local bo = vim.bo
local map = vim.api.nvim_set_keymap 
local var = vim.g

-- Found at: https://icyphox.sh/blog/nvim-lua/
function create_augroup(autocmds, name)
	cmd('augroup ' .. name)
    cmd('autocmd!')
    for _, autocmd in ipairs(autocmds) do
        cmd('autocmd ' .. table.concat(autocmd, ' '))
    end
    cmd('augroup END')
end

function dump(dump_obj)
	print(vim.inspect(dump_obj))
end

-- Settings
-- {{{
opt.tabstop = 4
opt.shiftwidth = 4
opt.relativenumber = true
opt.number = true
opt.autoindent = true
opt.cindent=true
opt.termguicolors = true -- enable devicons, found at :https://github.com/nvim-telescope/telescope.nvim/issues/652#issuecomment-798766661
opt.signcolumn = "yes"
opt.updatetime = 1000
opt.mouse = "n"
opt.completeopt = "menuone,noselect"
cmd("colorscheme onedark")
-- }}}

-- Hooks
-- {{{
-- Startup
-- {{{
create_augroup({
	{'FileType','php,javascript,python,sql,lua','DBSetOption','profile=mySQL'},
},"startup")

-- }}}
-- }}}

-- Plugins
-- {{{

-- LSP
-- {{{

local nvim_lsp = require('lspconfig')
local lsp_server = require'lspconfig/configs'
local util = nvim_lsp.util

-- Custom servers

-- sumneko_lua not register setup function for some strange reason
lsp_server.sumneko = {
	default_config = {
		cmd = {'lua-language-server'};
		filetypes = {'lua'};
		root_dir = function(fname)
      	return util.find_git_ancestor(fname) or util.path.dirname(fname)
    end;
	};
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	-- highlight LSP
	-- local cmd=vim.api.nvim_command

	if client.resolved_capabilities.document_highlight then
     vim.api.nvim_exec([[
         hi LspReferenceRead cterm=bold ctermbg=red guibg=Purple
         hi LspReferenceText cterm=bold ctermbg=red guibg=Purple
         hi LspReferenceWrite cterm=bold ctermbg=red guibg=Purple
     ]], false)
     cmd 'autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()'
     cmd 'autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()'
     cmd 'autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
	end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- Signature Help
  local lsp_signature=require('lsp_signature')
  lsp_signature.on_attach()

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'bashls','intelephense','sumneko' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
-- }}}

-- Treesiter
-- {{{
local ts = require('nvim-treesitter.configs')
ts.setup{
	ensure_installed = "maintained",
	highlight = {
		enable = true,
	}
}
-- }}}

-- Compe
-- {{{
compe=require('compe')
compe.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
end


function _G.smart_shift_tab()
    return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
end

map('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
map('i', '<C-j>', 'v:lua.smart_tab()', {expr = true, noremap = true})

map('i', '<S-Tab>', 'v:lua.smart_shift_tab()', {expr = true, noremap = true})
map('i', '<C-k>', 'v:lua.smart_shift_tab()', {expr = true, noremap = true})

-- }}}

-- Git Signs
-- {{{
gitsigns = require('gitsigns')
gitsigns.setup()
-- }}}

-- NVIM AUTOPAIRS
-- {{{
require('nvim-autopairs').setup{}
require("nvim-autopairs.completion.compe").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = false,  -- auto select first item
})
-- }}}

-- Telescope
-- {{{
local telescope = require('telescope')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')
local actions = require('telescope.actions')

-- local set = require('telescope.actions.set')
-- local prompt_bufnr = vim.api.nvim_get_current_buf()

telescope.load_extension('media_files')
telescope.setup{
  defaults = {
	color_devicons = true,
	mappings = {
		i = {
			["<esc>"] = actions.close,
			["<C-j>"] = actions.preview_scrolling_down,
			["<C-k>"] = actions.preview_scrolling_up,
		}
	}
  },
  extensions = {
	  media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = {"png", "webp", "jpg", "jpeg"},
      find_cmd = "rg" -- find command (defaults to `fd`)
    }
  }
}

--}}}

-- Dbext
-- {{{
var.dbext_default_profile_mySQL = 'type=MYSQL:user=admin:passwd=admin:dbname=programador_junior'
-- }}}

-- Windline
-- {{{
require('wlsample.bubble')
-- }}}

-- }}}

-- Mappings
-- {{{
local opts = { noremap=true, silent=true}

-- Insert mode
-- {{{
-- Exi on jj
map('i','jj','<ESC>',opts)

-- Move lines
map('i','<M-j>','<ESC>:m .+1<CR>==gi',opts)
map('i','<M-k>','<ESC>:m .-2<CR>==gi',opts)
-- }}}

-- Normal mode
-- {{{
-- Leader key
map('n', '<Space>', '', {}) 
vim.g.mapleader=' '
-- Moving between splits
map('n','<C-M-L>','<C-W><C-L>',opts)
map('n','<C-M-H>','<C-W><C-H>',opts)
map('n','<C-M-J>','<C-W><C-J>',opts)
map('n','<C-M-K>','<C-W><C-K>',opts)

-- Disable arrows
map('n','<UP>','<NOP>',opts)
map('n','<DOWN>','<NOP>',opts)
map('n','<LEFT>','<NOP>',opts)
map('n','<RIGTH>','<NOP>',opts)

-- Move lines
map('n','<M-j>',':m .+1<CR>==',opts)
map('n','<M-k>',':m .-2<CR>==',opts)

-- }}}

-- Visual mode
-- {{{
-- Move lines
map('v','<M-j>',"<ESC>:m '>+1<CR>gv=gv",opts)
map('v','<M-k>',"<ESC>:m '<-2<CR>gv=gv",opts)

-- Copy to clipboard
map('v','<C-C>','"+y :echo "Copied to clipboard"<CR>',opts)
-- }}}

-- Telescope
-- {{{

map('n','<leader>to',':Telescope find_files<CR>',opts)
map('n','<leader>t/',':Telescope current_buffer_fuzzy_find<CR>',opts)
map('n','<leader>tr',':Telescope registers<CR>',opts)
map('n','<leader>tc',':Telescope commands<CR>',opts)
map('n','<leader>tk',':Telescope keymaps<CR>',opts)
map('n','<leader>tru',':Telescope oldfiles<CR>',opts)

-- }}}

-- }}}

-- vim: set foldmethod=marker:
