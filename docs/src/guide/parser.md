# Users' guide: using a `CitableParser`

The `CitableParser` is an abstract type with associated functions for analyzing individual tokens or lists of tokens.

The module includes a sample implementation of the parser, designed to parse a corpus of all the known versions of Lincoln's Gettysburg Address, and to identify the form of tokens with the [part of speech code used by the Penn treebank project](https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html).

```jldoctest parsing
using CitableParserBuilder
parser = CitableParserBuilder.gettysburgParser()
typeof(parser) |> supertype

# output

CitableParser
```


```jldoctest parsing
registry = Dict(
        "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
        "gburgform" => "urn:cite2:citedemo:gburgform.v1:",
        "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
        "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
    )

1 + 1

# output

2
```