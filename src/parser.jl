abstract type CitableParser end

"""Required function to parse a single token with a `CitableParser`.

$(SIGNATURES)
"""
function parsetoken(p::T, t::AbstractString) where {T <: CitableParser}
    #@warn("parsetoken function not defined for type ", typeof(p))
    #nothing
    p.stringparser(t)
end


"""Parse a list of tokens with a `CitableParser`.

$(SIGNATURES)

Should return a (possibly empty) Vector of Analyses.
"""
function parsewordlist(p::T, tokens) where {T <: CitableParser}
    parses = []
    for t in tokens
        push!(parses, parsetoken(p,t))
    end
    parses
end


"""Parse a list of tokens in a file with a `CitableParser`.

$(SIGNATURES)

Should return pairings of tokens with a (possibly empty) Vector of Analyses.
"""
function parselistfromfile(p::T, f; delim = '|') where {T <: CitableParser}
    words = readdlm(f, delim)
    parsewordlist(p, words)
end


"""Parse a list of tokens at a given url with a `CitableParser`.

$(SIGNATURES)

Should return pairings of tokens with a (possibly empty) Vector of Analyses.
"""
function parselistfromurl(p::T, u) where {T <: CitableParser}
    words = split(String(HTTP.get(u).body) , "\n")
    parsewordlist(p,words)
end