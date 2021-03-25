push!(LOAD_PATH,"../")
import Pkg
Pkg.activate(".")
Pkg.instantiate()

using Documenter
using CitableParserBuilder
using CitableObject

makedocs(
    sitename="CitableParserBuilder.jl",
    pages = [
        "Home" => "index.md",
        "Guide" => [
            "guide/guide.md"
        ],
        "API documentation" => [
            "man/index.md"
        ]
    ]
    )

deploydocs(
    repo = "github.com/neelsmith/CitableParserBuilder.jl.git",
)