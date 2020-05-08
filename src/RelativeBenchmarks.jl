module RelativeBenchmarks

using Random
using LinearAlgebra

import MacroTools: postwalk
using MacroTools: MacroTools, prewalk, postwalk, @capture
using BenchmarkTools

include("setup.jl")

end  # RelativeBenchmarks
