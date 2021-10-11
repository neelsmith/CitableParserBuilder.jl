# Users' guide: using a `CitableParser`

Any implementation of a `CitableParser` works in basically the same way.  The parsing functions all have a common pair of signatures:

- `function(parser, content)`
- `function(parser, content, parserdata)`

The sample parser we will use requires the third, data parameter: check the documentation for your specific parser to see how it works.



Here we instantiate the sample parser, and verify that it is indeed a subtype of `CitableParser`.

```jldoctest parsing
using CitableParserBuilder
parser = CitableParserBuilder.gettysburgParser()
typeof(parser) |> supertype

# output

CitableParser
```

## Parsing string values

When we parse a string token, the result is a Vector of `Analysis` objects. Our parser produces only one analysis for *score*.

```jldoctest parsing
scoreparses = parsetoken("score", parser,  parser.data)
length(scoreparses)

# output

1
```
```jldoctest parsing
typeof(scoreparses[1])

# output

Analysis
```

The analysis object associates with the token a URN value, in abbreviated format, for each of the four properties of an analysis.

```jldoctest parsing
scoreparses[1].token

# output

"score"
```

```jldoctest parsing
scoreparses[1].form

# output

gburgform.NN
```

`NN` is the Penn Tree Bank code for *Noun, singular or mass*.

We can also parse a list of words. Here, parsing four words produces a Vector containing four Vectors of `Analysis` objects.

```jldoctest parsing
wordsparsed = parsewordlist(parser, split("Four score and seven"), parser.data)
length(wordsparsed)

# output

4
```


!!! tip
    You can use an `OrthographicSystem` to create generate a list of unique lexical tokens for an entire citable corpus. See the documentation for [the `Orthography` module](https://hcmid.github.io/Orthography.jl/stable/guide/corpora/).




## Parsing citable text content


You can also parse citable text structures: passages, documents and corpora.  Here we illustrate parsing a citable passage.

```jldoctest parsing
using CitableText, CitableCorpus
urn = CtsUrn("urn:cts:demo:gburg.hays.v2:1.2")
psg = CitablePassage(urn, "score")
psg_analysis = parsepassage(psg, parser, parser.data)
typeof(psg_analysis)

# output

AnalyzedToken
```

The result is a new kind of object, the `AnalyzedToken`, which associates a Vector of `Analysis` objects with a citable passage.


```jldoctest parsing
psg_analysis.passage

# output

<urn:cts:demo:gburg.hays.v2:1.2> score
```

```jldoctest parsing
psg_analysis.analyses == scoreparses

# output

true
```

## Exporting to CEX format

When we export analyses to CEX format, we want to use full CITE2 URNs, rather than the abbreviated URNs of the `Analysis` structure.  You need a dictionary mapping collection names to full CITE2 URN values for the collection.

```jldoctest parsing
registry = Dict(
        "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
        "gburgform" => "urn:cite2:citedemo:gburgform.v1:",
        "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
        "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
    )
length(registry)

# output

4
```

Include the dictionary along with your list of analyses as parameters to the `cex` function to expand abbreviated URNs to their full form.  You can use normal Julia IO to write the results to a file, for example.

```julia
cex_output = cex(psg_analysis, registry = registry)
open("outfile.cex", "w") do io
    write(io, cex_output)
end

# output

186
```