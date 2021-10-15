# CitableParserBuilder:  overview

The `CitableParserBuilder` module offers common functions and data structures for working with citable morphological analyses of citable texts.  

At the center of the module are the abstract `CitableParser`, and the concrete `Analysis` and `AnalyzedToken` types. 

Parsing functions use a `CitableParser` to operate either on string values for individual tokens, or on passages of text citable with CTS URNs at the token level.  This harmonizes nicely with the `Orthography` module's functions for tokenizing strings and citable text structures.

Parsing a string value returns a (possibly empty) list of `Analysis` objects.  Parsing a citable passage returns an `AnalyzedToken`, which pairs the citable passage with the analyses resulting from parsing the passage's text content.


!!! tip
    You can use an `OrthographicSystem` to create a complete tokenized edition from a citable edition. See the documentation for [the `Orthography` module](https://hcmid.github.io/Orthography.jl/stable/guide/corpora/).



## Shared functions for parsing: the `CitableParser` abstraction

Types implementing the `CitableParser` abstraction must have a member function named `stringparser(tkn::AbstractString)` that returns a list of `Analysis` objects.  That makes possible a `parsetoken` function with the following signature:


    parsetoken(p::T, t::AbstractString) where {T <: CitableParser}

`parsetoken` simply invokes `p.stringparser(t)` to parse the string value for a single token.  With this in place, the `CitableParserBuilder` can include concrete implementations of the following functions:

- `parsetoken`: parse a string value
- `parsewordlist`: parse a list of string values
- `parselistfromfile`: parse a list of string values in a local file
- `parselistfromurl`: parse a list of string values from the contents of a URL
- `parsepassage`: parse the text component of a `CitablePassage` as a single token
- `parsecorpus`: parse the text components of all nodes in a `CitableCorpus` as individual tokens




## Shared structures: the `Analysis` and the `AnalyzedToken` 

Every analysis of a string value identifies a valid pairing of a *lexeme* and a *form* for the token.  The `Analysis` further supports a typical model of computational morphological analysis that crosses a lexicon of stems with a set of inflectional patterns to create a comprehensive set of recognized forms. The stem and rule of an Analysis explain how the analysis' lexeme and form were arrived at.  The structure of the `Analysis` therefore consists of four URN values:

1. the *lexeme*
2. the *morphological form*
3. the *stem* used to arrive at the analysis
4. the *inflectional rule* used to arrive at the analysis

The `AnalyzedToken` type associates a Vector of `Analysis` objects with a citable token.


## Examples

The following sections illustrate parsing with a sample implementation of a `CitableParser` designed to parse a corpus of all the known versions of Lincoln's Gettysburg Address, and to identify the form of tokens with the [part of speech code used by the Penn treebank project](https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html).


## Contents

```@contents
Pages = [
    "guide/parser.md",
    "guide/analyses.md",
    "guide/corpusanalysis.md",
    "guide/abbrurns.md",
    "guide/utils.md",
    "guide/parsers.md",
    "guide/gburg.md",
    "man/index.md"
]
```