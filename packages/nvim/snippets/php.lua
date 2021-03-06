local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local rec_ls

local function capitalize(args)
    local input_string = args[1][1]
    return input_string:gsub("^%l",string.upper)
end

ls.snippets = {
    php = {
        -- class
        s("class",
            {
                t("class "),i(1,"ClassName"),
                t({"", "{" }),
                t({"","\t"}),
                i(0),
                t({"","}"}),
            }
        ),

        -- public function
        s("pf",{
            i(1,"public") ,t(" function "),i(2,"functionName"),
            t("("),
            i(3,"$argumento"),
            t(")"),

            t({"","{"}),
            t({"","\t"}),
            i(4),
            t({"","}"}),
            i(0)
        }),

        -- get and setter
        s("sg",{
            t("public function set"),f(capitalize,1),t("($"),i(1,"name"),t(")"),
            t({"","{"}),
            t({"","\t"}),
            t("$this->"),rep(1),t(" = $"),rep(1),t(";"),
            t({"","}","",""}),

            t("public function get"),f(capitalize,1),t("($"),rep(1),t(")"),
            t({"","{"}),
            t({"","\t"}),
            t("return $this->get"),rep(1),t(";"),
            t({"","}"}),
            t({"","",""})
        })
    }
}
