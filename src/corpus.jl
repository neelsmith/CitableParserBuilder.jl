
"""Pair each lexical node in a token-level edition with a list of `Analysis` objects for that token.

$(SIGNATURES)
"""
#=
function analyzecorp(parser::P, ortho::O, c::CitableTextCorpus, data...) where {P <: CitableParser, O <: OrthographicSystem} 
    if ! isempty(data)
        @info("VARARG ", data)
    else
        @info("VARARG WAS EMPTY!")
    end
    tknlist = tokenize(ortho, c)
    tokencorpus = map(pr -> pr[1], filter(pr -> pr[2] == LexicalToken(), tknlist)) |> CitableTextCorpus
    parsecorpus(parser, tokencorpus, data)
end
=#