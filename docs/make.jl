push!(LOAD_PATH,"../")
using Documenter, CitableParserBuilder
using CitableObject

makedocs(sitename="CitableParserBuilder Documentation")

deploydocs(
    repo = "github.com/neelsmith/CitableParserBuilder.jl.git",
)