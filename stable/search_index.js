var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#ChainRecursive.chain-Tuple{Any}",
    "page": "Home",
    "title": "ChainRecursive.chain",
    "category": "Method",
    "text": "@chain(e)\n\nWill chain all eligible block in your code, recursively.\n\nWithin each block, lines are reduced with link. link has two behaviors. It will call bare functions on the result of the previous line.\n\njulia> using ChainRecursive\n\njulia> @chain begin\n           1\n           vcat\n        end\n1-element Array{Int64,1}:\n 1\n\nIt will reinterpret _ within expressions as the result of the previous line.\n\njulia> using ChainRecursive\n\njulia> @chain begin\n           1\n           vcat(2, _)\n       end\n2-element Array{Int64,1}:\n 2\n 1\n\nIt will recur.\n\njulia> using ChainRecursive\n\njulia> @chain begin\n           1\n           if _ == 1\n               _ + 1\n               vcat(_, 3)\n           end\n       end\n2-element Array{Int64,1}:\n 2\n 3\n\nCannot chain blocks with assignments, bindings, or updates. They will be skipped. Once you give a name to something, use it! If your chains get too long, I highly recommend breaking them up with descriptive assignments.\n\njulia> using ChainRecursive\n\njulia> @chain begin\n           a = 1\n           _\n       end\nERROR: UndefVarError: _ not defined\n\njulia> @chain begin\n            a += 1\n            _\n       end\nERROR: UndefVarError: _ not defined\n\njulia> @chain begin\n           function test_function(x) 1 end\n           _\n       end\nERROR: UndefVarError: _ not defined\n\njulia> @chain begin\n           type cant_chain_types end\n           _\n       end\nERROR: UndefVarError: _ not defined\n\nHowever, assignments, bindings, and updates will not prevent recursion.\n\njulia> using ChainRecursive\n\njulia> @chain begin\n           a = 1\n           begin\n               a + 1\n               vcat(_, 3)\n           end\n       end\n2-element Array{Int64,1}:\n 2\n 3\n\nIn addition, type definitions will not be recurred into.\n\njulia> using ChainRecursive\n\njulia> @chain type test_type\n           a\n           b::_\n       end\nERROR: UndefVarError: _ not defined\n\n\n\n"
},

{
    "location": "index.html#ChainRecursive.@chain",
    "page": "Home",
    "title": "ChainRecursive.@chain",
    "category": "Macro",
    "text": "See documentation of chain\n\n\n\n"
},

{
    "location": "index.html#ChainRecursive.jl-1",
    "page": "Home",
    "title": "ChainRecursive.jl",
    "category": "section",
    "text": "Documentation for ChainRecursive.jlModules = [ChainRecursive]"
},

]}
