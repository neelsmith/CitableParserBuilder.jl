# CitableParserBuilder:  overview

The `CitableParserBuilder` module offers common functions and data structures for working with citable morphological analyses of citable texts.  


At the center of the module are the abstract `CitableParser`, and the concrete `Analysis` type. Functions for morphological parsing use a `CitableParser` to operate either on string values for individual tokens, or on passages of text citable with CTS URNs at the token level.  Parsing a token returns a (possibly empty) list of `Analysis` objects, which express the results of the parse with URN values.


## Shared structures: the `Analysis`

Every analysis of a token identifies a valid pairing of a *lexeme* and a *form* for the token.  The `Analysis` further supports a typical model of computational morphological analysis that crosses a lexicon of stems with a set of inflectional patterns to create a comprehensive set of recognized forms. The stem and rule of an Analysis explain how the analysis' lexeme and form were arrived at.  The structure of the `Analysis` therefore consists of four URN values:

1. the lexeme
2. the morphological form
3. the stem used to arrive at the analysis
4. the inflectional rule used to arrive at the analysis


## Shared functions for parsing: the `CitableParser` abstraction

Types implementing the `CitableParser` abstraction must have a member function named `stringparser(tkn::AbstractString)` that returns a list of `Analysis` objects.  That makes possible a `parsetoken` function with the following signature:


    parsetoken(p::T, t::AbstractString) where {T <: CitableParser}

`parsetoken` simply invokes `p.stringparser(t)` to parse the string value for a single token.  With this in place, the `CitableParserBuilder` can include concrete implementations of the following functions:

- `parsetoken`: parse a string value
- `parsewordlist`: parse a list of string values
- `parselistfromfile`: parse a list of string values in a local file
- `parselistfromurl`: parse a list of string values from the contents of a URL
- `parsenode`: parse the text component of a `CitableNode` as a single token
- `parsecorpus`: parse the text components of all nodes in a `CitableCorpus` as individual tokens



## Utilities


### Abbreviated URN values

The `AbbreviatedUrn` is an abstract type supporting an abbreviated notation for `Cite2Urn`s. It allows you to work with objects uniquely identified by collection identifier and object identifier, when the collection is registered in a dictionary that can expand the collection identifier to a full `Cite2Urn`.

The modules implements the `AbbrevatedUrn` for each uniquely identified component of an `Analysis`:

1. `LexemeUrn`
2. `FormUrn`
3. `StemUrn`
4. `RuleUrn`



### SFST utilities

`Kanones` and `Tabulae` are Julia packages for building ancient Greek and Latin morphological parsers, respectively.  Both `Kanones` and `Tabulae` do their parsing behind the scenes using finite state transducers built with the [Stuttgart Finite State Transducer](https://github.com/santhoshtr/sfst) toolkit.  To facilitate this work, `CitableParserBuilder` includes utilities for transcoding string values to and from URN values and expressions in SFST-PL, the programmning language of the Stuttgart Finite State Transducer tooolkit.


### CEX utilities

The module supports export of parsing results in CEX format.