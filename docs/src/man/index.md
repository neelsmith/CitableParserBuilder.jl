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

## Parsing

```@docs
parsetoken
parsewordlist
parselistfromfile
parselistfromurl
parsepassage
parsecorpus
```


## Working with `AbbreviatedUrn`s

```@docs
abbreviate
expand
fstsafe
```

## Working with `Stem`s and `Rule`s

```@docs
CitableParserBuilder.lexeme
CitableParserBuilder.id
CitableParserBuilder.inflectiontype
```

## Serialization

```@docs
readfst
analyses_relationsblock
```
