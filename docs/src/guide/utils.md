# Utilities

## SFST utilities

`Kanones` and `Tabulae` are Julia packages for building ancient Greek and Latin morphological parsers, respectively.  Both `Kanones` and `Tabulae` do their parsing behind the scenes using finite state transducers built with the [Stuttgart Finite State Transducer](https://github.com/santhoshtr/sfst) toolkit.  To facilitate this work, `CitableParserBuilder` includes utilities for transcoding string values to and from URN values and expressions in SFST-PL, the programmning language of the Stuttgart Finite State Transducer tooolkit.

