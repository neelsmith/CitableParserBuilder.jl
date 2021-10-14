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

## Profiling parsed results

```@docs
vocabulary_density
token_coverage
vocabulary_coverage
lexical_density
form_density_incorpus
form_density_invocabulary
form_density_inlexicon
formal_ambiguity
lexical_ambiguity
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
delimited
cex
```
