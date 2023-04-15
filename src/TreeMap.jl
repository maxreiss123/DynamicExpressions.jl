module TreeMapModule

import ..EquationModule: Node

"""
    tree_map(f, tree)

Map a function over a tree and return a flat array of the results in depth-first order.
"""
function tree_map(f::F, tree::Node) where {F<:Function}
    if tree.degree == 0
        return [f(tree)]
    elseif tree.degree == 1
        return [f(tree), tree_map(f, tree.l)...]
    else
        return [f(tree), tree_map(f, tree.l)..., tree_map(f, tree.r)...]
    end
end

"""
    tree_mapreduce(f, op, tree)

Map a function over a tree and aggregate the result using an operator `op`.
The operator will take the result of `f` on the current node, as well
as on the left node. For binary nodes, `op` will receive the result of
`f` on the current node, and both the left and right nodes (three arguments).

# Examples
```jldoctest
julia> operators = OperatorEnum(; binary_operators=[+, *]);

julia> tree = Node(; feature=1) + Node(; feature=2) * 3.2;

julia> tree_mapreduce(t -> 1, +, tree)  # count nodes
5

julia> tree_mapreduce(vcat, tree) do t
    t.degree == 2 ? [t.op] : Int[]
end  # Get list of binary operators used
2-element Vector{Int64}:
 1
 2

julia> tree_mapreduce(vcat, tree) do t
    (t.degree == 0 && t.constant) ? [t.val] : Float64[]
end  # Get list of constants
1-element Vector{Float64}:
 3.2
```
"""
function tree_mapreduce(f::F, op::G, tree::Node) where {F<:Function,G<:Function}
    if tree.degree == 0
        return f(tree)
    elseif tree.degree == 1
        return op(f(tree), tree_mapreduce(f, op, tree.l))
    else
        return op(f(tree), tree_mapreduce(f, op, tree.l), tree_mapreduce(f, op, tree.r))
    end
end

end