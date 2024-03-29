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
parsepassage
parsecorpus
```



## Working with vectors of `AnalyzedToken`s

```@docs
lexemes
stringsforlexeme
lexemedictionary
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
relationsblock
delimited
cex
```
