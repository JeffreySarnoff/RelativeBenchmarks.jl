module RelativeBenchmarks

using Random
using LinearAlgebra

import MacroTools: postwalk
using MacroTools: MacroTools, prewalk, postwalk, @capture
using BenchmarkTools

#=
    You set this directory with the default const or through the environment.
    Ensure `NewImplementation.jl` and `OldImplementation.jl` are kept there.
=#
const DefaultBenchmarkingDir = pwd()
const BenchmarkingDir = haskey(ENV, "BenchmarkingDir") ? ENV["BenchmarkingDir"] : DefaultBenchmarkingDir

cd(BenchmarkingDir)
isfile("NewImplmentation.jl") && isfile("OldImplmentation.jl") ||
    error("Both `NewImplmentation.jl` and `OldImplementation.jl` must be found in the BenchmarkingDir ($BenchmarkingDir)")

include("setup.jl")
include("relspeeds.jl")

end  # RelativeBenchmarks
