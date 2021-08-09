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
AnalyzedToken
```


## Functions for working with `AbbreviatedUrn`s

```@docs
abbreviate
expand
fstsafe
abbreviation
```

## Functions for working with `Stem`s and `Rule`s

```@docs
CitableParserBuilder.lexeme
CitableParserBuilder.id
CitableParserBuilder.inflectiontype
```

## Reading FST output from a file


```@docs
readfst
```


## Parsers and analyses


```@docs
parsetoken
parsewordlist
parselistfromfile
parselistfromurl
cex
```