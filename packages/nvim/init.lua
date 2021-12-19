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

function dump(var)
	print(vim.inspect(var))
end

-- Settings
-- {{{
opt.tabstop = 4
opt.shiftwidth = 4
opt.relativenumber = true
opt.number = true
-- opt.autoindent = true
-- opt.cindent=true
opt.expandtab=true
opt.termguicolors = true -- enable devicons, found at :https://github.com/nvim-telescope/telescope.nvim/issues/652#issuecomment-798766661
opt.signcolumn = "yes"
opt.updatetime = 1000
opt.mouse = "n"
opt.completeopt = "menu,menuone,noselect"
cmd("colorscheme onedark")
-- }}}

-- Hooks
-- {{{
-- Startup
-- {{{
create_augroup({
	{'FileType','php,javascript,python,sql,lua','DBSetOption','profile=mySQL'},
	{'BufEnter','*nix','set','filetype=nix'},
	{'BufEnter','*php','set','autoindent','cindent'},
},"startup")

-- create_augroup({
-- 	{'BufEnter','*nix','set','filetype=nix'}
-- },"fixnix")

-- }}}
-- }}}

-- Plugins
-- {{{

-- LSP
-- {{{

local nvim_lsp = require('lspconfig')
local lsp_server = require'lspconfig/configs'
local util = nvim_lsp.util
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	-- highlight LSP
	-- local cmd=vim.api.nvim_command

	-- if client.resolved_capabilities.document_highlight then
    --  vim.api.nvim_exec([[
    --      hi LspReferenceRead cterm=bold ctermbg=red guibg=Purple
    --      hi LspReferenceText cterm=bold ctermbg=red guibg=Purple
    --      hi LspReferenceWrite cterm=bold ctermbg=red guibg=Purple
    --  ]], false)
    --  cmd 'autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()'
    --  cmd 'autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()'
    --  cmd 'autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
	-- end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definiinition()<CR>', opts)
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
local servers = { 'bashls','intelephense','rnix' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- Custom servers

-- sumneko_lua not register setup function for some strange reason
nvim_lsp.sumneko_lua.setup{
        capabilities= capabilities,
        on_attach = on_attach,
		cmd = {'lua-language-server'},
		filetypes = {'lua'},
		root_dir = function(fname)
      		return util.find_git_ancestor(fname) or util.path.dirname(fname)
    	end,
	settings = {
		Lua = {
			workspace = {
				library = {
					['/nix/store/mgjmb01qnnmivwj1q4bh0zf87dxbzm5j-awesome-4.3/share/awesome/lib'] = true
				}
			}
		}
	}
}
-- }}}

-- Treesiter
-- {{{
local ts = require('nvim-treesitter.configs')
ts.setup{
	ensure_installed = "maintained",
	highlight = {
		enable = true,
		disable = {"bash"},
        additional_vim_regex_highlighting = {"php"}
	},
	indent ={
		enable = {"php"}
	},
}
-- }}}

-- Compe
-- {{{
-- local compe=require('compe')
-- compe.setup {
--   enabled = true;
--   autocomplete = true;
--   debug = false;
--   min_length = 1;
--   preselect = 'enable';
--   throttle_time = 80;
--   source_timeout = 200;
--   resolve_timeout = 800;
--   incomplete_delay = 400;
--   max_abbr_width = 100;
--   max_kind_width = 100;
--   max_menu_width = 100;
--   documentation = {
--     border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
--     winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
--     max_width = 120,
--     min_width = 60,
--     max_height = math.floor(vim.o.lines * 0.3),
--     min_height = 1,
--   };
-- 
--   source = {
--     path = true;
--     buffer = true;
--     calc = true;
--     nvim_lsp = true;
--     nvim_lua = true;
--     vsnip = true;
--     ultisnips = true;
--     luasnip = true;
--   };
-- }
-- 

-- }}}


-- nvim-cmp / luasnip
-- {{{

local luasnip = require('luasnip')

local cmp = require('cmp')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
--
function _G.smart_tab(fallback)
    -- return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    elseif cmp.visible() then
        cmp.select_next_item()
    elseif has_words_before() then
        cmp.confirm()
    else
        fallback()
    end
end
--
function _G.smart_shift_tab(fallback)
    -- return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end
--
--map('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
--map('i', '<C-j>', 'v:lua.smart_tab()', {expr = true, noremap = true})
----
--map('i', '<S-Tab>', 'v:lua.smart_shift_tab()', {expr = true, noremap = true})
--map('i', '<C-k>', 'v:lua.smart_shift_tab()', {expr = true, noremap = true})


local function prequire(...)
local status, lib = pcall(require, ...)
if (status) then return lib end
    return nil
end

local luasnip = prequire('luasnip')
local cmp = prequire("cmp")

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
end
_G.s_tab_complete = function()
    if cmp and cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip and luasnip.jumpable(-1) then
        return t("<Plug>luasnip-jump-prev")
    else
        return t "<S-Tab>"
    end
    return ""
end

cmp.setup({
    snippet = {
        expand = function (args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
      { name = 'path' },
      -- { name = 'buffer' },
    }),
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping(smart_tab, {'i','s'}),
      ['<S-Tab>'] = cmp.mapping(smart_shift_tab, { "i", "s" }),
      ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','s'}),
      ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','s'})
    }
})


  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

-- }}}

-- Git Signs
-- {{{
local gitsigns = require('gitsigns')
gitsigns.setup()
-- }}}

-- NVIM AUTOPAIRS
-- {{{
require('nvim-autopairs').setup{}
-- require("nvim-autopairs.completion.compe").setup({
--   map_cr = true, --  map <CR> on insert mode
--   map_complete = true, -- it will auto insert `(` after select function or method item
--   auto_select = false,  -- auto select first item
-- })
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
cmd("let $LD_LIBRARY_PATH=''")
var.dbext_default_profile_mySQL = 'type=MYSQL:user=admin:passwd=admin:dbname=programador_junior'
var.dbext_default_history_file = "$HOME/.local/cache/dbext_sql_history.txt"
-- }}}

-- Windline
-- {{{
require('wlsample.bubble')
-- }}}

-- Indentline
-- {{{
var.indentLine_char_list = { '|', }
var.indentLine_concealcursor = 'inc'
var.indentLine_conceallevel = 2
-- }}}

-- Which key nvim
-- {{{
local wk = require('which-key')
wk.setup{}
-- }}}

-- barbar
-- {{{
var.bufferline = {
	auto_hide = true,
    exclude_name = { '[dap-repl]' }
}
-- }}}

-- Nvim-DAP
-- {{{
-- var.vdebug_options = {
--     ['port'] = 9003
-- }

dap=require('dap')

dap.adapters.php = {
  type = 'executable',
  command = 'vscode-php-debug'
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003,
    log=true
  },
  {
    name = "Launch currently open script",
    type = "php",
    request = "launch",
    program = "${file}",
    cwd = "${fileDirname}",
    port = 9003,
    runtimeArgs = { "-dxdebug.start_with_request=yes" },
    env = {
      [ "XDEBUG_MODE" ] = "debug,develop",
      [ "XDEBUG_CONFIG" ] = "client_port=${port}",
      [ "PATH" ] = os.getenv("PATH")
    }
  }
}

vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
-- }}}

-- Nvim-Dap-Ui
-- {{
dapui=require("dapui")
dapui.setup()
-- }}

--- }}}

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

-- Nvim-DAP
-- {{{
map('n','<F5>',':lua dap.continue()<CR>',opts)
map('n','<F10>',':lua dap.step_over()<CR>',opts)
map('n','<F11>',':lua dap.step_into()<CR>',opts)
map('n','<F12>',':lua dap.step_out()<CR>',opts)
map('n','<leader>d',':lua dap.toggle_breakpoint()<CR>',opts)
map('n','<leader>B',':lua dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',opts)
map('n','<leader>lp',':lua dap.set_breakpoint(nil,nil,vim.fn.input("Log point message: "))<CR>',opts)
map('n','<leader>dr',':lua dapui.toggle()<CR>',opts)
map('n','<leader>dl',':lua dap.run_last()<CR>',opts)
-- }}}

-- Telescope
-- {{{

wk.register({
	t = {
		name = "Telescope",
		o = { ":Telescope find_files<CR>", "Find Files" },
		["/"] = {":Telescope current_buffer_fuzzy_find<CR>", "Search In File"},
		r = {":Telescope registers<CR>","Registers"},
		c = {":Telescope commands<CR>","Commands"},
		k = {":Telescope keymaps<CR>","Keymaps"},
	}
},{prefix='<leader>'})

wk.register({
	u = {":Telescope oldfiles<CR>","Recent Used"}
},{prefix="<Leader>tr"})

-- }}}

--  Nvim tree
-- {{{
local barbar = require('bufferline.state')
local nvim_tree = require('nvim-tree')
nvim_tree.setup{}
local opened=false

tree ={}
tree.open = function()
   barbar.set_offset(31, 'FileTree')
   nvim_tree.find_file(true)
end

tree.close = function()
   barbar.set_offset(0)
   nvim_tree.close()
end

tree.toggle = function()
	opened = not opened
	if opened then
		tree.open()
	else
		tree.close()
	end
end

function maplua(vimcmd)
	return ':lua ' .. vimcmd .. '<CR>'
end
map('n','<leader>b',maplua('tree.toggle()'),opts)

-- }}}

-- Vim commentary
-- {{{
map('n','gc',':Commentary<CR>',opts)
map('v','gc',':Commentary<CR>',opts)
-- }}}

-- Lazygit
-- {{{
map('n','<leader>lg',':LazyGit<CR>',opts)
-- }}}

-- }}}

-- vim: set foldmethod=marker:
