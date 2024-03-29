# Users' guide: using a `CitableParser`

Any implementation of a `CitableParser` works in basically the same way.  The parsing functions all have a common pair of signatures:

- `function(textcontent, parser)`
- `function(content, parser, parserdata)`

The sample parser we will use requires the third, data parameter: check the documentation for your specific parser to see how it works.



Here we instantiate the sample parser, and verify that it is indeed a subtype of `CitableParser`.

```@example parsing
using CitableParserBuilder
parser = CitableParserBuilder.gettysburgParser()
typeof(parser) |> supertype
```

## Parsing string values

When we parse a string token, the result is a Vector of `Analysis` objects. Our parser produces only one analysis for *score*.

```@example parsing
scoreparses = parsetoken("score", parser; data = parser.data)
length(scoreparses)
```
```@example parsing
typeof(scoreparses[1])
```

The analysis object associates with the token a URN value, in abbreviated format, for each of the four properties of an analysis.

```@example parsing
scoreparses[1].token

```

```@example parsing
scoreparses[1].form
```

`NN` is the Penn Tree Bank code for *Noun, singular or mass*.

We can also parse a list of words. Here, parsing four words produces a Vector containing four Vectors of `Analysis` objects.

```@example parsing
wordsparsed = parselist(split("Four score and seven"), parser; data =  parser.data)
length(wordsparsed)
```


!!! tip
    You can use an `OrthographicSystem` to create generate a list of unique lexical tokens for an entire citable corpus. See the documentation for [the `Orthography` module](https://hcmid.github.io/Orthography.jl/stable/guide/corpora/).




## Parsing citable text content


You can also parse citable text structures: passages, documents and corpora.  Here we illustrate parsing a citable passage.

```@example parsing
using CitableText, CitableCorpus
urn = CtsUrn("urn:cts:demo:gburg.hays.v2:1.2")
psg = CitablePassage(urn, "score")
psg_analysis = parsepassage(psg, parser; data = parser.data)
typeof(psg_analysis)
```

The result is a new kind of object, the `AnalyzedToken`, which associates a Vector of `Analysis` objects with a citable passage.


```@example parsing
psg_analysis.passage
```

```@example parsing
psg_analysis.analyses == scoreparses
```

## Exporting to CEX format

When we export analyses to CEX format, we want to use full CITE2 URNs, rather than the abbreviated URNs of the `Analysis` structure.  You need a dictionary mapping collection names to full CITE2 URN values for the collection.

```@example parsing
registry = Dict(
        "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
        "gburgform" => "urn:cite2:citedemo:gburgform.v1:",
        "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
        "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
    )
length(registry)
```

Use the `cex` function (from `CitableBase`) to format your analyzes as delimited text.  To expand abbreviated URNs to full CTS and CITE2 URNs while formatting as deliimted text, use the `delimited` function. You can use normal Julia IO to write the results to a file, for example.

```@example parsing
cex_output = delimited(psg_analysis, registry = registry)
open("outfile.cex", "w") do io
    write(io, cex_output)
end
```