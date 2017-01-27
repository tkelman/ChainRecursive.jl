module ChainRecursive

import NumberedLines
import CreateMacrosFrom

link(head, tail::Symbol) = begin
    wrapped_head = NumberedLines.wrap(head)
    :( $tail( $wrapped_head) )
end

link(head, tail::Expr) = begin
    wrapped_head = NumberedLines.wrap(head)
    :(let _ = $wrapped_head; $tail; end)
end

link(head, tail::NumberedLines.NumberedLine) =
    NumberedLines.without_line_number(tail -> link(head, tail), tail)

const assignments = :function, :(=), :const, :local, :global, :(+=), :(-=),
    :(*=), :(/=), :(\=), :(÷=), :(%=), :(^=), :(&=), :(|=), :($=), :(>>>=),
    :(>>=), :(<<=), :type

is_assignment(e) = false
is_assignment(e::Expr) = e.head in assignments
is_assignment(n::NumberedLines.NumberedLine) = is_assignment(n.line)

const unrecurrables = [:type]

chain_recursive(e) = e
chain_recursive(e::Expr) = if e.head in unrecurrables
    e
else
    recurred = Expr(e.head, map(chain_recursive, e.args)...)
    if recurred.head == :block && !any( is_assignment.(recurred.args) )
        foldl(link, recurred.args) |> NumberedLines.wrap
    else
        recurred
    end
end

chain_recursive(n::NumberedLines.NumberedLine) =
    NumberedLines.without_line_number(chain_recursive, n)

export chain
"""
    @chain(e)

Will `chain` all eligible block in your code, recursively.

Within each block, lines are reduced with `link`. `link` has two behaviors.
It will call bare functions on the result of the previous line.

```jldoctest
julia> using ChainRecursive

julia> @chain begin
           1
           vcat
        end
1-element Array{Int64,1}:
 1
```

It will reinterpret `_` within expressions as the result of the previous line.

```jldoctest
julia> using ChainRecursive

julia> @chain begin
           1
           vcat(2, _)
       end
2-element Array{Int64,1}:
 2
 1
```

It will recur.

```jldoctest
julia> using ChainRecursive

julia> @chain begin
           1
           if _ == 1
               _ + 1
               vcat(_, 3)
           end
       end
2-element Array{Int64,1}:
 2
 3
```

Cannot chain blocks with assignments, bindings, or updates. They will be
skipped. Once you give a name to something, use it!

```jldoctest
julia> using ChainRecursive

julia> @chain begin
           a = 1
           _
       end
ERROR: UndefVarError: _ not defined

julia> @chain begin
           function test_function(x) 1 end
           _
       end
ERROR: UndefVarError: _ not defined

julia> @chain begin
           type cant_chain_types end
           _
       end
ERROR: UndefVarError: _ not defined

julia> let a = 1
           @chain begin
               a += 1
               _
           end
       end
ERROR: UndefVarError: _ not defined
```

However, assignments, bindings, and updates will not prevent recursion.

```jldoctest
julia> using ChainRecursive

julia> @chain begin
           a = 1
           begin
               a + 1
               vcat(_, 3)
           end
       end
2-element Array{Int64,1}:
 2
 3
```

In addition, type definitions will not be recurred into.
```jldoctest
julia> using ChainRecursive

julia> @chain type test_type
           a
           _
       end
ERROR: UndefVarError: _ not defined
```
"""
chain(e) = NumberedLines.with_numbered_lines(chain_recursive, e)

CreateMacrosFrom.@create_macros_from chain

export @chain

end
