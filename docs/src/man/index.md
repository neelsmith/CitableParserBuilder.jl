# API documentation

## Structures

```@docs
AbbreviatedUrn
Stem
Rule
Analysis
StemUrn
RuleUrn
LexemeUrn
FormUrn
```


## Functions for working with `AbbreviatedUrn`s

```@docs
abbreviate(urn::Cite2Urn)
expand(au::AbbreviatedUrn, registry::Dict)
fstsafe(au::AbbreviatedUrn)
```

## Functions for working with `Stem`s and `Rule`s

```@docs
CitableParserBuilder.lexeme
CitableParserBuilder.id
```



