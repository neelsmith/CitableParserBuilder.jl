# Worked example: build your own `CitableParser`


## 1. Define your parser type

Import `CitableParserBuilder`, and define your parser as a subtype of `CitableParser`.
```doctest buildone
using CitableParserBuilder
struct FakeParser <: CitableParser
    label
end
fakeParser = FakeParser("Parser generating dummy values")

# output

FakeParser("Parser generating dummy values")
```


## 2. Implement `parsetoken`

Be sure to import `CitableParserBuilder: parsetoken` before defining a method of `parsetoken` for your parser's type.  You're done!  You can now use `parsetoken` and all the other functions of the `ParserTrait`.

```doctest buildone
import CitableParserBuilder: parsetoken
function parsetoken(s::AbstractString, parser::FakeParser) 
    # Returns only the same analysis no matter
    # what the token is
    [
        Analysis(
        s,
        LexemeUrn("fakeparser.nolexemeanalysis"),
        FormUrn("fakeparser.noformanalysis"),
        StemUrn("fakeparser.nostemanalysis"),
        RuleUrn("fakeparser.noruleanalysis")
    )
    ]
end
tokenparses = parsetoken("word", fakeParser)
tokenparses[1].token

# output

"word"
```

```doctest buildone
wordlist = split("More than one word")
listparses = parsewordlist(wordlist, fakeParser)
length(listparses)

# output

4
```
    
