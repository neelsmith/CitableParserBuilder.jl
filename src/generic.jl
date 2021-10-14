"""Parse a list of tokens with a `CitableParser`.

$(SIGNATURES)

Should return a (possibly empty) Vector of Vectors Analysis objects.
Each outer Vector corresponds to one vocabulary item.
"""
function parsewordlist(vocablist, p::T; data = nothing) where {T <: CitableParser}
    parses = []
    for vocab in vocablist
        push!(parses, parsetoken(vocab, p; data))
    end
    parses
end

"""Parse a list of tokens in a file with a `CitableParser`.

$(SIGNATURES)

Should return pairings of tokens with a (possibly empty) Vector of Analyses.
"""
function parselistfromfile(f, p::T, delim = '|'; data = nothing) where {T <: CitableParser}
    words = readdlm(f, delim)
    parsewordlist(words, p; data = data)
end




"""Parse a list of tokens at a given url with a `CitableParser`.

$(SIGNATURES)

Should return pairings of tokens with a (possibly empty) Vector of Analyses.
"""
function parselistfromurl(u, p::T, data = nothing) where {T <: CitableParser}
    words = split(String(HTTP.get(u).body) , "\n")
    parsewordlist(words, p; data)
end




"""Parse a `CitablePassage` with text for a single token with a `CitableParser`.

$(SIGNATURES)

Should return an AnalyzedToken.
"""
function parsepassage(cn::CitablePassage, p::T;  data = nothing) where {T <: CitableParser}
    AnalyzedToken(cn, parsetoken(cn.text, p; data))
end




"""Use a `CitableParser` to parse a `CitableTextCorpus` with each citable node containing containg a single token.

$(SIGNATURES)

Should return a list of `AnalyzedToken`s.
"""
function parsecorpus(c::CitableTextCorpus, p::T; data = nothing) where {T <: CitableParser}
    results = AnalyzedToken[]
    for cn in c.passages
        push!(results, AnalyzedToken(cn, parsetoken(cn.text, p; data = data)))
    end
    results
end

"""Use a `CitableParser` to parse a `CitableTextCorpus` with each citable node containing containg a single token.

$(SIGNATURES)

Should return a list of `AnalyzedToken`s.
"""
function parsedocument(doc::CitableDocument, p::T; data = nothing) where {T <: CitableParser}
    results = AnalyzedToken[]
    for cn in doc.passages
        push!(results, AnalyzedToken(cn, parsetoken(cn.text, p; data = data)))
    end
    results
end