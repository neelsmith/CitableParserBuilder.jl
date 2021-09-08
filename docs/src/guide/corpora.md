# Analyzing text corpora

Use an `OrthographicSystem` together with a `CitableParser` to analyze a full text corpus.  Implementations of the `OrthographicSystem` abstraction can parse a citable text corpus into a list of tokens.  Since `CitableParser`s can parse citable tokens, the `analyzecorpus` function trivially composes these functions to create a list of analyses for each token in a citable corpus.

## Example of analyzing a citable text corpus

Let's instantiate a dummy parser that just analyzes all tokens the same way.

```jldoctest corpus
using CitableParserBuilder
struct FakeParser <: CitableParser
    stringparser
end
function fakestringparser(token, data...) 
    # Returns only nothing values no matter
    # what the token is
    [
        Analysis(
        token,
        LexemeUrn("fakeparser.nothing"),
        FormUrn("fakeparser.nothing"),
        StemUrn("fakeparser.nothing"),
        RuleUrn("fakeparser.nothing")
    )
    ]
end
fp = FakeParser(fakestringparser)
typeof(fp)

# output

FakeParser
```

Now let's create a text corpus.

```jldoctest corpus
using CitableText, CitableCorpus
 mred = CitableTextCorpus([
        CitableNode(CtsUrn("urn:cts:docstrings:mred.themesong:1"),"A horse is a horse, of course, of course,"),
        CitableNode(CtsUrn("urn:cts:docstrings:mred.themesong:2"),"And no one can talk to a horse of course,"),
        CitableNode(CtsUrn("urn:cts:docstrings:mred.themesong:3"),"That is, of course, unless the horse is the famous Mr. Ed."),
])
typeof(mred)

# output

CitableTextCorpus
```

We'll use the `Orthography` module's sample `simpleAscii` orthography.



```jldoctest corpus
using Orthography
analyses = analyzecorpus(fp, simpleAscii(), mred)
analyses |> length

# output

31
```


Each analysis pairs a `CitableNode` with a list of `Analysis` objects.


```jldoctest corpus
tkn1 = analyses[1]
tkn1[1]

# output

CitableNode(CtsUrn("urn:cts:docstrings:mred.themesong:1.1"), "A")
```

```jldoctest corpus
analysisvector = tkn1[2]
length(analysisvector)

# output

1
```


```jldoctest corpus
analysisvector[1]

# output

Analysis("A", LexemeUrn("fakeparser", "nothing"), FormUrn("fakeparser", "nothing"), StemUrn("fakeparser", "nothing"), RuleUrn("fakeparser", "nothing"))
```