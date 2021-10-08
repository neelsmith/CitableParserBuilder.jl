# Abbreviated URN values

The `AbbreviatedUrn` is an abstract type supporting an abbreviated notation for `Cite2Urn`s. It allows you to work with objects uniquely identified by collection identifier and object identifier, when the collection is registered in a dictionary that can expand the collection identifier to a full `Cite2Urn`.

The modules implements the `AbbrevatedUrn` for each uniquely identified component of an `Analysis`:

1. `LexemeUrn`
2. `FormUrn`
3. `StemUrn`
4. `RuleUrn`



## Abbreviated URNs and `Cite2Urn`s

You can use the `abbreviate` function to create an abbreviation string from a `Cite2Urn` using the collection identifier and the object identifer of the `Cite2Urn`.


```jldoctest loaded
using CitableParserBuilder, CitableObject
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