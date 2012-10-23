module(..., package.seeall)

-- REPL

function repl() 
   package.path = package.path .. ';3rdParty/lua-repl/?.lua'
   local ok, repl = pcall(require, 'repl.linenoise')

   if not ok then
      repl = require 'repl.console'
   end

   repl:run()
end

