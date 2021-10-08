# User's guide: working with analyses

The `Analysis` type represents the results of analyzing a string morphologically.

The `AnalyzedToken` type associates a Vector of `Analysis` objects with a citable token.

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

