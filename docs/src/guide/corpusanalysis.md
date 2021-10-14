# Analyzing a corpus

The `CitableParserBuilder` defines a number of functions that draw on a concrete implementation of the `parsetoken` function to analyze a citable corpus.

We'll load a citable corpus from a file in this repository's `test/data` directory.

```@example corpus
using CitableCorpus
repo = dirname(pwd()) # hide
f = joinpath(repo,"test","data","gettysburgcorpus.cex") # hide
corpus = read(f) |> corpus_fromcex
```

We'll use an orthography to prepare a tokenized corpus.


```@example corpus
using Orthography
tc = tokenizedcorpus(corpus, simpleAscii())
```

```@example corpus
dictcsv = joinpath(repo, "test", "data", "posdict.csv") # hide
using CSV # hide
morphdict = CSV.File(dictcsv) |> Dict
using CitableParserBuilder
parser = CitableParserBuilder.gettysburgParser(dict = morphdict)
parsed =  parsecorpus(tc, parser; data = parser.data)
length(parsed)
```

How good is your coverage?
```@example corpus
 coverage(tc, parser; data = parser.data)
```


With that in mind, let's take some standard measures

```@example corpus
 lexical_ambiguity(tc, parser; data = parser.data)
```


```@example corpus
 formal_ambiguity(tc, parser; data = parser.data)
```