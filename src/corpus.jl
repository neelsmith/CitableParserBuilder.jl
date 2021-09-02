
"""Pair each lexical node in a token-level edition with a list of `Analysis` objects for that token.

$(SIGNATURES)
"""
function analyzecorpus(parser::P, ortho::O, c::CitableTextCorpus) where {P <: CitableParser, O <: OrthographicSystem}
    tknlist = tokenize(ortho, c)
    tokencorpus = map(pr -> pr[1], filter(pr -> pr[2] == LexicalToken(), tknlist)) |> CitableTextCorpus
    parsecorpus(parser, tokencorpus)
end