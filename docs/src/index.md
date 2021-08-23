# CitableParserBuilder

The `CitableParserBuilder` package offers common functions and structures used by the `Kanones` and `Tabulae` packages for building ancient Greek and Latin morphological parsers, respectively.  Since both `Kanones` and `Tabulae` build finite state transducers with the [Stuttgart Finite State Transducer](https://github.com/santhoshtr/sfst), `CitableParserBuilder` includes utilities for transcoding string values to and from URN values and SFST-PL expressions.

!!! note
    `Kanones.jl` is not yet registered with juliahub.  For now, to use it, you'll have to add the package from its github repository.

## Shared structures

- `Analysis`.  URN values define the four components of an Analysis:
    1. the lexeme
    2. the morphological form
    3. the stem used to arrive at the analysis
    4. the inflectional rule used to arrive at the analysis
- `Stem` and `Rule`.  Abstract types for specific stem and rule types identified by `AbbreviatedUrn`s.  `Stem`s     
- `AbbreviatedUrn`.  An abstract type supporting an abbreviated notation for `Cite2Urn`s.  The package includes implementations of the `AbbrevatedUrn` for each uniquely identified component of an `Analysis`:
    1. `LexemeUrn`
    2. `FormUrn`
    3. `StemUrn`
    4. `RuleUrn`

