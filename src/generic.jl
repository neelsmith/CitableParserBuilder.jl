"""Parse a list of tokens with a `CitableParser`.

$(SIGNATURES)

Returns a Dict mapping strings to a (possibly empty) vector of `Analysis` objects. Blank lines in input are silently ignored.
"""
function parselist(vocablist::Vector{S}, p::P; data = nothing, countinterval = 100) where {P <: CitableParser, S <: AbstractString}
    @debug("Vocabulary size: ", length(vocablist))
    counter = 0
    parses = []
    for vocab in filter(s -> !isempty(s), vocablist)
        counter = counter + 1
        if mod(counter, countinterval) == 0
            @info("Parsing ", counter)
        end
        push!(parses, (vocab, parsetoken(vocab, p; data)))
    end
    parses |> Dict
end

"""Read a list of tokens from file `f` and parse with `p`.

$(SIGNATURES)

Returns a Dict mapping strings to a (possibly empty) vector of `Analysis` objects.
"""
function parselist(f, p::T, reader::Type{FileReader}; 
    data = nothing, countinterval = 100) where {T <: CitableParser}
    wordlist = readlines(f) 
    parselist(wordlist, p, data = data, countinterval = countinterval)
end


"""Read a list of tokens from URL `u` and parse with `p`.

$(SIGNATURES)

Returns a Dict mapping strings to a (possibly empty) vector of `Analysis` objects.
"""
function parselist(u, p::T, reader::Type{UrlReader}; 
    data = nothing, countinterval = 100) where {T <: CitableParser}
    wordlist = split(String(HTTP.get(u).body) , "\n")
    parselist(wordlist, p; data = data, countinterval = countinterval)
end


"""Parse a `CitablePassage` with text for a single token with a `CitableParser`.

$(SIGNATURES)

Returns a single `AnalyzedToken`.
"""
function parsepassage(cn::CitablePassage, p::T;  data = nothing) where {T <: CitableParser}
    AnalyzedToken(CitableToken(cn, LexicalToken()), parsetoken(cn.text, p; data = data))
end


"""Parse a `CitablePassage` with text for a single token with a `CitableParser`.

$(SIGNATURES)

Returns a single `AnalyzedToken`.
"""
function parsepassage(ct::CitableToken, p::T;  data = nothing) where {T <: CitableParser}
    AnalyzedToken(ct, parsetoken(ct.passage.text, p; data = data))
end


"""Use a `CitableParser` to parse a `CitableTextCorpus` with each citable node containing containg a single token of type `LexicalToken`.

$(SIGNATURES)

Returns an`AnalyzedTokens` object.
"""
function parsecorpus(c::CitableTextCorpus, p::T; data = nothing, countinterval = 100) where {T <: CitableParser}
    wordlist = map(psg -> psg.text, c.passages) |> unique
    @info("Corpus size (tokens): ", length(c.passages))
    parsedict = parselist(wordlist, p; data = data, countinterval = countinterval)
    keylist = keys(parsedict)
    results = AnalyzedToken[]
    for psg in c.passages
        if psg.text in keylist
            at = AnalyzedToken(CitableToken(psg, LexicalToken()), parsedict[psg.text])
            push!(results, at)
        else
            at = AnalyzedToken(CitableToken(psg, LexicalToken()), AnalyzedToken[])
            push!(results, at)
        end
    end
    results |> AnalyzedTokens
end
