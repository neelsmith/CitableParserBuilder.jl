# Analyzing and profiling a corpus



## Analyzing a corpus

The `CitableParserBuilder` defines a number of functions that draw on a concrete implementation of the `parsetoken` function to analyze a citable corpus.

We'll load a citable corpus from a file in this repository's `test/data` directory (referred to here as `f`).

```@example corpus
using CitableCorpus, CitableBase
repo = dirname(pwd()) |> dirname |> dirname # hide
corpuscexfile = joinpath(repo,"test","data","gettysburgcorpus.cex") 
corpus = fromcex(corpuscexfile, CitableTextCorpus, FileReader)
```

We'll use the `SimpleAscii` orthography from the `Orthography` package to prepare a tokenized corpus.

```@example corpus
using Orthography
tc = tokenizedcorpus(corpus, simpleAscii())
```


We'll build a `GettysburgParser`, a demo parser for the English text of the Gettysburg Address in two steps.  First we'll load a local file with analytical data into a dictionary (here named `morphdict`). Then we'll include that as an optional `dict` parameter when we build the parser.

The result of parsing the corpus is a Vector of `AnalyzedToken`s.  There is one entry for each token in the corpus.
```@example corpus
dictcsv = joinpath(repo, "test", "data", "posdict.csv") 
using CSV
morphdict = CSV.File(dictcsv) |> Dict
using CitableParserBuilder
parser = CitableParserBuilder.gettysburgParser(dict = morphdict)
parsed =  parsecorpus(tc, parser; data = parser.data)
length(parsed)
```

The vector of analyses can be formatted as delimited text with the `delimited` function.  If you include an optional `registry` mapping collection names to full CITE2 collection strings, abbreviated URNs will be expanded in the resulting text.

```@example corpus
urndict = Dict(
    "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
    "gburgform" => "urn:cite2:citedemo:gburgform.v1:",
    "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
    "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
)
delimited_output = tempname()
open(delimited_output, "w") do io
    write(io, delimited(parsed; registry = urndict))
end
```

We can read the file with `analyzedtokens_fromcex` to create a new Vector
of analyses.

```@example corpus
cexoutput = read(delimited_output, String) 
analyzedtokens_fromcex(cexoutput)
```
(We'll be tidy and remove the temporary file.) 
```@example corpus
rm(delimited_output)
```


## Profiling a corpus

TBA in a future release.
