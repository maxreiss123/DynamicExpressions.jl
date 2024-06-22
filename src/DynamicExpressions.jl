module DynamicExpressions

using DispatchDoctor: @stable, @unstable

@stable default_mode = "disable" begin
    include("Utils.jl")
    include("ExtensionInterface.jl")
    include("OperatorEnum.jl")
    include("Node.jl")
    include("NodeUtils.jl")
    include("Strings.jl")
    include("Evaluate.jl")
    include("EvaluateDerivative.jl")
    include("ChainRules.jl")
    include("EvaluationHelpers.jl")
    include("Simplify.jl")
    include("OperatorEnumConstruction.jl")
    include("Expression.jl")
    include("Random.jl")
    include("Parse.jl")
    include("ParametricExpression.jl")
end

import PackageExtensionCompat: @require_extensions
import Reexport: @reexport
macro ignore(args...) end

@reexport import .NodeModule:
    AbstractNode,
    AbstractExpressionNode,
    GraphNode,
    Node,
    copy_node,
    set_node!,
    tree_mapreduce,
    filter_map,
    filter_map!
import .NodeModule:
    constructorof,
    with_type_parameters,
    preserve_sharing,
    leaf_copy,
    branch_copy,
    leaf_hash,
    branch_hash,
    leaf_equal,
    branch_equal
@reexport import .NodeUtilsModule:
    count_nodes,
    count_constants,
    count_depth,
    NodeIndex,
    index_constants,
    has_operators,
    has_constants,
    get_constants,
    set_constants!
@reexport import .StringsModule: string_tree, print_tree
@reexport import .OperatorEnumModule: AbstractOperatorEnum
@reexport import .OperatorEnumConstructionModule:
    OperatorEnum, GenericOperatorEnum, @extend_operators, set_default_variable_names!
@reexport import .EvaluateModule: eval_tree_array, differentiable_eval_tree_array
@reexport import .EvaluateDerivativeModule: eval_diff_tree_array, eval_grad_tree_array
@reexport import .ChainRulesModule: NodeTangent
@reexport import .SimplifyModule: combine_operators, simplify_tree!
@reexport import .EvaluationHelpersModule
@reexport import .ExtensionInterfaceModule: node_to_symbolic, symbolic_to_node
@reexport import .RandomModule: NodeSampler
@reexport import .ExpressionModule:
    AbstractExpression, Expression, with_tree, default_node, node_type
import .ExpressionModule: get_tree, get_operators, get_variable_names, Metadata
@reexport import .ParseModule: @parse_expression, parse_expression
import .ParseModule: parse_leaf
@reexport import .ParametricExpressionModule: ParametricExpression, ParametricNode

@stable default_mode = "disable" begin
    include("Interfaces.jl")
    include("PatchMethods.jl")
end

import .InterfacesModule: ExpressionInterface, NodeInterface

function __init__()
    @require_extensions
end

include("deprecated.jl")

import TOML: parsefile

const PACKAGE_VERSION = let d = pkgdir(@__MODULE__)
    try
        if d isa String
            project = parsefile(joinpath(d, "Project.toml"))
            VersionNumber(project["version"])
        else
            v"0.0.0"
        end
    catch
        v"0.0.0"
    end
end

# To get LanguageServer to register library within tests
@ignore include("../test/runtests.jl")

include("precompile.jl")
do_precompilation(; mode=:precompile)
end
