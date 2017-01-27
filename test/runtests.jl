using ChainRecursive
using Documenter

makedocs(
    modules = [ChainRecursive],
    format = :html,
    sitename = "ChainRecursive.jl",
    pages = Any["Home" => "index.md"],
    strict = true
)
