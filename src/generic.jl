"""Parse a list of tokens with a `CitableParser`.

$(SIGNATURES)

Returns a Dict mapping strings to a (possibly empty) vector of `Analysis` objects.
"""
function parselist(vocablist::Vector{S}, p::P; data = nothing, countinterval = 100) where {P <: CitableParser, S <: AbstractString}
    @info("Vocabulary size: ", length(vocablist))
    counter = 0
    parses = []
    for vocab in vocablist
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
    AnalyzedToken(cn, parsetoken(cn.text, p; data))
end




"""Parse a `CitableTextCorpus` with each citable node containing containg a single token using `p`.

$(SIGNATURES)

Should return a list of `AnalyzedToken`s.
"""
function parsecorpus_brute(c::CitableTextCorpus, p::T; data = nothing) where {T <: CitableParser}
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
function parsecorpus(c::CitableTextCorpus, p::T; data = nothing, countinterval = 100) where {T <: CitableParser}
    wordlist = map(psg -> psg.text, c.passages) |> unique
    @info("Corpus size (tokens): ", length(c.passages))
    parsedict = parselist(wordlist, p; data = data, countinterval = countinterval)
    keylist = keys(parsedict)
    results = AnalyzedToken[]
    for psg in c.passages
        if psg.text in keylist
            at = AnalyzedToken(psg, parsedict[psg.text])
            push!(results, at)
        else
            at = AnalyzedToken(psg, AnalyzedToken[])
            push!(results, at)
        end
    end
    results
end



#=
"""Use a `CitableParser` to parse a `CitableTextCorpus` with each citable node containing containg a single token.

$(SIGNATURES)

Should return a list of `AnalyzedToken`s.
"""
function parsedocument_brute(doc::CitableDocument, p::T; data = nothing, countinterval = 100) where {T <: CitableParser}
    counter = 0
    results = AnalyzedToken[]
    for cn in doc.passages
        counter = counter + 1
        if mod(counter, countinterval) == 0
            @info(counter)
        end
        push!(results, AnalyzedToken(cn, parsetoken(cn.text, p; data = data)))
    end
    results
end
=#


#=
"""Use a `CitableParser` to parse a `CitableTextCorpus` with each citable node containing containg a single token.

$(SIGNATURES)

Should return a list of `AnalyzedToken`s.
"""
function parsedocument(doc::CitableDocument, p::T; data = nothing, countinterval = 100) where {T <: CitableParser}
    wordlist = map(psg -> psg.text, doc.passages) |> unique
    parsedict = parselist(wordlist, p; data = data, countinterval = countinterval)
    keylist = keys(parsedict)

    results = AnalyzedToken[]
    for psg in doc.passages
        if psg.text in keylist
            at = AnalyzedToken(psg, parsedict[psg.text])
            push!(results, at)
        else
            at = AnalyzedToken(psg, AnalyzedToken[])
            push!(results, at)
        end
    end
    results
end
=#