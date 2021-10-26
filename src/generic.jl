"""Parse a list of tokens with a `CitableParser`.

$(SIGNATURES)

Returns a Dict mapping strings to a (possibly empty) vector of `Analysis` objects.
"""
function parsewordlist(vocablist, p::T; data = nothing, countinterval = 100) where {T <: CitableParser}
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

"""Parse a list of tokens in a file with a `CitableParser`.

$(SIGNATURES)
"""
function parselistfromfile(f, p::T, delim = '|'; data = nothing) where {T <: CitableParser}
    words = readdlm(f, delim)
    parsewordlist(words, p; data = data)
end




"""Parse a list of tokens at a given url with a `CitableParser`.

$(SIGNATURES)
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
    parsedict = parsewordlist(wordlist, p; data = data, countinterval = countinterval)
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

"""Use a `CitableParser` to parse a `CitableTextCorpus` with each citable node containing containg a single token.

$(SIGNATURES)

Should return a list of `AnalyzedToken`s.
"""
function parsedocument(doc::CitableDocument, p::T; data = nothing, countinterval = 100) where {T <: CitableParser}
    wordlist = map(psg -> psg.text, doc.passages) |> unique
    parsedict = parsewordlist(wordlist, p; data = data, countinterval = countinterval)
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