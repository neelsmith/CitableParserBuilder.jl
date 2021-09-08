# User's guide: working with analyses

The `Analysis` type represents the results of a purely morphological analyis.

The `AnalyzedToken` type associates `Analysis` objects with a token in a specific context.

Notable points:

- the `AnalyzedToken` should cite the text at the level of individual token, normally by expanding the citation hierarchy on level to identify tokens within a canonically citable unit
- the Vector of analyses associated with an `AnalyzedToken` may be empty. This means that no analyis was found for the given token.
- the string value for the token in an `AnalyzedToken`  represents the string as it appears in the cited text.  The string for the token in an `Analysis` represents the string that was analyzed.  These two values may or may not be identical.  If the token was normalized in some way before analysis (e.g., adjusting case or accent) they may differ.




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
typeof(formurn)

# output

FormUrn
```


```jldoctest loaded
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
typeof(expanded)

# output

Cite2Urn
```    

```jldoctest loaded
expanded.urn

# output

"urn:cite2:kanones:morphforms.v1:1000000001"
```

### Abbreviated URNs and SFST-PL

The `fstsafe` function composes an expression in SFST-PL for `AbbrevatiedUrn`s.  It assumes that your SFST alphabet includes tokens `<u>` and `</u>` to mark beginning and ending boundaries of URN values. It escapes characters that are valid in URNs but reserved in the Stuttgart FST toolkit.  


```jldoctest loaded
rule = RuleUrn("nouninfl.h_hs1")
fst = fstsafe(rule)

# output

"<u>nouninfl\\.h\\_hs1</u>"
```    