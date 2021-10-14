# Analyzing and profiling a corpus



## Analyizng a corpus

The `CitableParserBuilder` defines a number of functions that draw on a concrete implementation of the `parsetoken` function to analyze a citable corpus.

We'll load a citable corpus from a file in this repository's `test/data` directory (referred to here as `f`).

```@example corpus
using CitableCorpus
repo = dirname(pwd()) |> dirname |> dirname # hide
f = joinpath(repo,"test","data","gettysburgcorpus.cex") # hide
corpus = read(f) |> corpus_fromcex
```

We'll use the `SimpleAscii` orthography from the `Orthography` package to prepare a tokenized corpus.

```@example corpus
using Orthography
tc = tokenizedcorpus(corpus, simpleAscii())
```


We'll build a `GettysburgParser`, a demo parser for the English text of the Gettysburg Address in two steps.  First we'll load a local file with analytical data into a dictionary (here named `morphdict`). Then we'll include that as an optional `dict` parameter when we build the parser.

The result of parsing the corpus is a Vector of `AnalyzedToken`s.  There is one entry for each token in the corpus.
```@example corpus
dictcsv = joinpath(repo, "test", "data", "posdict.csv") # hide
using CSV # hide
morphdict = CSV.File(dictcsv) |> Dict
using CitableParserBuilder
parser = CitableParserBuilder.gettysburgParser(dict = morphdict)
parsed =  parsecorpus(tc, parser; data = parser.data)
length(parsed)
```


## Profiling a corpus

We can get a summary profile of the corpus in a couple of different ways.  At the cost of reparsing the corpus, we can simply use the `profile` function

```@example corpus
profile1 = profile(tc, parser; data = parser.data)
```

Alternatively, we can reuse our existing Vector of `AnalyticalToken`s like this.
```@example corpus
counts = count_analyses(parsed)
label = "Profile of " * string(corpus)
profile2 = profile(counts, label)
```


The profile object has a ton of useful information.



```@example corpus
 vocabulary_density(profile1)
```



```@example corpus
 token_coverage(profile1)
```

See the API documentation for a full list of the functions you can apply to a profile.