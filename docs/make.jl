using Documenter
using ChainRecursive

makedocs(
    modules = [ChainRecursive],
    format = :html,
    sitename = "ChainRecursive.jl",
    pages = Any["Home" => "index.md"],
    strict = true
)

# for successful deployment, make sure to
# - add a gh-pages branch on github
# - run `import Documenter; Documenter.Travis.genkeys("ChainRecursive")` in a
#       *REPL* and follow instructions. For Windows, run from inside
#       git-bash.
deploydocs(
    repo = "github.com/bramtayl/ChainRecursive.jl.git",
    target = "build",
    deps = nothing,
    make = nothing
)
