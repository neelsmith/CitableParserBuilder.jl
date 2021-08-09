# User's guide

## The `Analysis` type

Each individual `Analysis` associates four features, identified by URN, with a string value for a token:

1. the lexeme 
2. the form
3. the stem
4. the inflectional rule

For a morphologically ambiguous token, there will be multiple valid `Analysis` objects with the same string value.

## `Stem`s and `Rule`s

The `CitableParserBuilder` assumes a typical model of computational morphological analysis that crosses a lexicon of stems with a set of inflectional patterns to create a comprehensive set of recognized forms.  The stem and rule  of an `Analysis`  explain how the analysis' lexeme and form were arrived at.

## Abbreviated URNs

The package defines an abstract `AbbreviatedUrn` structure, with four implementations:  the `LexemeUrn`, `FormUrn`, `StemUrn` and `RuleUrn` structures.

An `AbbreviatedUrn` has a collection identifier, and an object identifier.  You can construct an `AbbreviatedUrn` from a dot-delimited string.

```jldoctest loaded
using CitableParserBuilder
lexurn = LexemeUrn("lsj.n125")
lexurn.collection

# output

"lsj"
```
```jldoctest loaded
lexurn.objectid

# output

"n125"
```


### Abbreviated URNs and `Cite2Urn`s

You can use the `abbreviate` function to create an abbreviation string from a `Cite2Urn` using the collection identifier and the object identifer of the `Cite2Urn`.




```jldoctest loaded
using CitableObject
conjunctionurn = Cite2Urn("urn:cite2:kanones:morphforms.v1:1000000001")
abbreviate(conjunctionurn)

# output

"morphforms.1000000001"
```

Of course you can use this string in turn to instantiate an `AbbreviatedUrn` structure.

```jldoctest loaded
formurn = abbreviate(conjunctionurn) |> FormUrn
formurn.objectid

# output

"1000000001"
```

To convert an `AbbreviatedUrn` to a full `Cite2Urn`, give the `expand` function a dictionary mapping collection identifiers to full URN strings for the collection



```jldoctest loaded
registry = Dict(
    "morphforms" => "urn:cite2:kanones:morphforms.v1:"
)
expanded = expand(formurn, registry)
expanded.urn

# output

"urn:cite2:kanones:morphforms.v1:1000000001"
```    



### Abbreviated URNs and SFST-PL

Some characters that are valid in URNs are reserved in the Stuttgart FST toolkit.  The `fstsafe` function composes an expression in SFST-PL for `AbbrevatiedUrn`s.



```jldoctest loaded
rule = RuleUrn("nouninfl.h_hs1")
fst = fstsafe(rule)

# output

"<u>nouninfl\\.h\\_hs1</u>"
```    