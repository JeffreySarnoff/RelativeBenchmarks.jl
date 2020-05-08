
 BenchmarkDefaults =
     BenchmarkTools.Parameters(
       seconds = 4.0,
       samples = 7_500,
       evals = 1,
       overhead = BenchmarkTools.estimate_overhead(),
       gctrial = true,
       gcsample = false,
       time_tolerance = 1.25e-11,
       memory_tolerance = 1/4096, # was 1/1024,
     );

BenchmarkTools.DEFAULT_PARAMETERS.overhead = BenchmarkTools.estimate_overhead()
BenchmarkTools.DEFAULT_PARAMETERS.evals = 1
BenchmarkTools.DEFAULT_PARAMETERS.samples = 7_500
BenchmarkTools.DEFAULT_PARAMETERS.time_tolerance = 1.35e-11
BenchmarkTools.DEFAULT_PARAMETERS.memory_tolerance = 1/4096

# introduce `@refd` benchmarking assist (`@refd @btime ..`)

walk(x, inner, outer) = outer(x)
walk(x::Expr, inner, outer) = outer(Expr(x.head, map(inner, x.args)...))
MacroTools.postwalk(f, x) = walk(x, x -> postwalk(f, x), f)

function _refd(expr::Expr)
    if expr.head == :$
        :($(Expr(:$, :(Ref($(expr.args...)))))[])
    else
        expr
    end
end
_refd(x) = x

macro refd(expr)
    out = postwalk(_refd, expr) |> esc
end
