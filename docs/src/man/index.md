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
parsenode
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

## Reading FST output from a file


```@docs
readfst
```


## Serialization

```@docs
cex
```