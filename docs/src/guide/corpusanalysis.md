# Analyzing a corpus

The `CitableParserBuilder` defines a number of functions that draw on a concrete implementation of the `parsetoken` function to analyze a citable corpus.

We'll load a citable corpus from a file in this repository's `test/data` directory.

```jldoctest corpus
using CitableCorpus
repo = dirname(pwd())
f = joinpath(repo,"test","data","gettysburgcorpus.cex")
corpus = read(f) |> corpus_fromcex

# output

Corpus with 20 citable passages in 5 documents.
```

We'll use an orthography to prepare a tokenized corpus.


```jldoctest corpus
using Orthography
tc = tokenizedcorpus(corpus, simpleAscii())

# output

Corpus with 1506 citable passages in 5 documents.
```

```jldoctest corpus
using CitableParserBuilder
parser = CitableParserBuilder.gettysburgParser()
parsed =  parsecorpus(tc, parser; data = parser.data)
length(parsed)

# output

1313
```

How good is your coverage?
```jldoctest
 coverage(tc, parser; data = parser.data)

# output

0.9847677075399848
```
