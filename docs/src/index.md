# `CitableParserBuilder` documentation

The `CitableParser` package offers common functions and structures used by the `Kanones.jl` and `Tabulae.jl` packages for building ancient Greek and Latin morphological parsers, respectively.

## Functions

```@docs
abbreviate(urn::Cite2Urn)
expand(au::AbbreviatedUrn, registry::Dict)
fstsafe(au::AbbreviatedUrn)
```