push!(LOAD_PATH,"../")
import Pkg; Pkg.add("CitableObject")
using Documenter, CitableParserBuilder
using CitableObject

makedocs(sitename="CitableParserBuilder.jl Documentation")

deploydocs(
    repo = "github.com/neelsmith/CitableParserBuilder.jl.git",
)