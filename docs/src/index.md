# CitableParserBuilder:  overview

The `CitableParserBuilder` module offers common functions and data structures for working with citable morphological analyses of citable texts.  

At the center of the module are the abstract `CitableParser`, and the concrete `Analysis` and `AnalyzedToken` types. 

Parsing functions use a `CitableParser` to operate either on string values for individual tokens, or on passages of text citable with CTS URNs at the token level.  This harmonizes nicely with the `Orthography` module's functions for tokenizing strings and citable text structures.

Parsing a string value returns a (possibly empty) list of `Analysis` objects.  Parsing a citable passage returns an `AnalyzedToken`, which pairs the citable passage with the analyses resulting from parsing the passage's text content.


!!! tip
    You can use an `OrthographicSystem` to create a complete tokenized edition from a citable edition. See the documentation for [the `Orthography` module](https://hcmid.github.io/Orthography.jl/stable/guide/corpora/).



## Shared functions for parsing: the `CitableParser` abstraction

Subtypes of the `CitableParser` abstraction must implement the `parsetoken` function.  This enables the `CitableParserBuilder` module to include concrete implementations of:

- `parselist`: parse a list of string values
- `parsepassage`: parse the text component of a `CitablePassage` as a single token
- `parsecorpus`: parse the text components of all nodes in a `CitableCorpus` as individual tokens



## Shared structures: the `Analysis` and the `AnalyzedToken` 

Every analysis of a string value identifies a valid pairing of a *lexeme* and a *form* for the token.  The `Analysis` also includes a stem and rule that explain how the analysis' lexeme and form were arrived at.  The structure of an `Analysis` therefore consists of a string value (the token) and four URN values:

1. the *lexeme*
2. the *morphological form*
3. the *stem* used to arrive at the analysis
4. the *inflectional rule* used to arrive at the analysis

The `AnalyzedToken` type associates a Vector of `Analysis` objects with a citable token.


## Shared functions for working with results of parsing

1. `lexemes` 
1. `stringsforlexeme` 
1. `lexemedictionary`

## Examples

The following sections illustrate parsing with a sample implementation of a `CitableParser` designed to parse a corpus of all the known versions of Lincoln's Gettysburg Address, and to identify the form of tokens with the [part of speech code used by the Penn treebank project](https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html).


