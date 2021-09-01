# Run this from repository root, e.g. with
#
#    julia --project=docs/ docs/make.jl
#
# Run this from repository root to serve:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'julia -e 'using LiveServer; serve(dir="docs/build")'

using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Documenter
using CitableParserBuilder
using CitableObject

makedocs(
    sitename="CitableParserBuilder.jl",
    pages = [
        "Overview" => "index.md",
        "User's guide" => [

            "guide/parser.md",
            "guide/analyses.md",
            "guide/parsers.md"
        ],
        "API documentation" => [
            "man/index.md"
        ]
    ]
    )

deploydocs(
    repo = "github.com/neelsmith/CitableParserBuilder.jl.git",
)