abstract type CitableParser end

"""Required function to parse a single token with a `CitableParser`.

$(SIGNATURES)

Should return a (possibly empty) Vector of Analyses.
"""
function parsetoken(p::T, t::AbstractString, data...) where {T <: CitableParser}
    p.stringparser(t, data)
end


"""Parse a list of tokens with a `CitableParser`.

$(SIGNATURES)

Should return a (possibly empty) Vector of Analyses.
"""
function parsewordlist(p::T, tokens, data...) where {T <: CitableParser}
    parses = []
    for t in tokens
        push!(parses, parsetoken(p,t, data))
    end
    parses
end


"""Parse a list of tokens in a file with a `CitableParser`.

$(SIGNATURES)

Should return pairings of tokens with a (possibly empty) Vector of Analyses.
"""
function parselistfromfile(p::T, f, delim = '|', data...) where {T <: CitableParser}
    words = readdlm(f, delim)
    parsewordlist(p, words, data)
end

"""Parse a list of tokens at a given url with a `CitableParser`.

$(SIGNATURES)

Should return pairings of tokens with a (possibly empty) Vector of Analyses.
"""
function parselistfromurl(p::T, u, data...) where {T <: CitableParser}
    words = split(String(HTTP.get(u).body) , "\n")
    parsewordlist(p,words, data)
end


"""Parse a `CitableNode` with text for a single token with a `CitableParser`.

$(SIGNATURES)

Should return a pairing of the CitableNode with a list of analyses.
"""
function parsenode(p::T, cn::CitableNode, data...) where {T <: CitableParser}
    (cn, p.stringparser(cn.text, data))
end

"""Use a `CitableParser` to parse a `CitableTextCorpus` with each citable node containing containg a single token.

$(SIGNATURES)

Should return a list of pairings of a CitableNode with a list of analyses.
"""
function parsecorpus(p::T, c::CitableTextCorpus, data...) where {T <: CitableParser}
    results = []
    for cn in c.corpus
        push!(results, (cn, p.stringparser(cn.text, data)))
    end
    results
end