

"""Compute pct of tokens in corpus analyzed by parser.
$(SIGNATURES)
"""
function coverage(tokencorpus::CitableTextCorpus, p::CitableParser, data)
    parses = parsecorpus(p, tokencorpus, p.data)
    resultcount = filter(a -> ! isempty(a.analyses), parses) |> length
    resultcount / length(tokencorpus.passages)
end

"""Compute pct of words in list of words analyzed by parser.
$(SIGNATURES)
"""
function coverage(vocablist, p::CitableParser, data)
    parses = parsewordlist(p, vocablist, p.data)
    resultcount = filter(a -> ! isempty(a), parses) |> length
    resultcount / length(vocablist)
end

"""True if `atkn` can be analyzed to more than one lexeme.
$(SIGNATURES)
"""
function lexically_ambiguous(atkn::AnalyzedToken)
    if isempty(atkn.analyses) || length(atkn.analyses) < 2
        false
    else
        uniquelexemes = map(a -> a.lexeme, atkn.analyses) |> unique
        length(uniquelexemes) > 1
    end
end

"""Compute lexical ambiguity in corpus analyzed by parser.
$(SIGNATURES)
"""
function lexical_ambiguity(c::CitableTextCorpus, p::CitableParser, data)
    @warn("Not yet implemented")
    nothing
end


"""Compute lexical ambiguity in list of words analyzed by parser.
$(SIGNATURES)
"""
function lexical_ambiguity(vocablist, p::CitableParser, data)
    @warn("Not yet implemented")
    nothing
end


"""Compute morphological ambiguity in corpus analyzed by parser.
$(SIGNATURES)
"""
function formal_ambiguity(c::CitableTextCorpus, p::CitableParser, data)
    @warn("Not yet implemented")
    nothing
end


"""Compute morphological ambiguity in list of words analyzed by parser.
$(SIGNATURES)
"""
function formal_ambiguity(vocablist, p::CitableParser, data)
    @warn("Not yet implemented")
    nothing
end




"""Compute frequencies of lexemes in corpus analyzed by parser.
$(SIGNATURES)
"""
function lexical_frequencies(c::CitableTextCorpus, p::CitableParser, data)
    @warn("Not yet implemented")
    nothing
end

"""Compute frequencies of forms in corpus analyzed by parser.
$(SIGNATURES)
"""
function formal_frequencies(c::CitableTextCorpus, p::CitableParser, data)
    @warn("Not yet implemented")
    nothing
end