"""Compute pct of tokens in corpus analyzed by parser.
$(SIGNATURES)
"""
function coverage(tokencorpus::CitableTextCorpus, p::CitableParser; data = nothing)
    parses = parsecorpus(tokencorpus, p; data = data)
    resultcount = filter(a -> ! isempty(a.analyses), parses) |> length
    resultcount / length(tokencorpus.passages)
end

"""Compute pct of words in list of words analyzed by parser.
$(SIGNATURES)
"""
function coverage(vocablist, p::CitableParser; data = nothing)
    parses = parsewordlist(vocablist, p, data)
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


"""True if  `Analysis` items in a vector of analyses identify more than one lexeme.
$(SIGNATURES)
"""
function lexically_ambiguous(vect)
    if isempty(vect) || length(vect) < 2
        false
    else
        uniquelexemes = map(a -> a.lexeme, vect) |> unique
        length(uniquelexemes) > 1
    end
end

"""Compute lexical ambiguity in corpus analyzed by parser.
$(SIGNATURES)
"""
function lexical_ambiguity(c::CitableTextCorpus, p::CitableParser; data)
    parses = parsecorpus(p, c; data = data)
    ambiguous = filter(p -> lexically_ambiguous(p), parses)
    length(ambiguous) / length(c.passages)
end

"""Compute lexical ambiguity in list of words analyzed by parser.
$(SIGNATURES)
"""
function lexical_ambiguity(vocablist, p::CitableParser; data)
    parses = parsewordlist(p, vocablist, data)
    ambiguous = filter(p -> lexically_ambiguous(p), parses)
    length(ambiguous) / length(vocablist)
end




"""True if `atkn` can be analyzed to more than one form.
$(SIGNATURES)
"""
function formally_ambiguous(atkn::AnalyzedToken)
    if isempty(atkn.analyses) || length(atkn.analyses) < 2
        false
    else
        uniqueforms = map(a -> a.form, atkn.analyses) |> unique
        length(uniqueforms) > 1
    end
end

"""True if  `Analysis` items in a vector of analyses identify more than one form.
$(SIGNATURES)
"""
function formally_ambiguous(vect)
    if isempty(vect) || length(vect) < 2
        false
    else
        uniqueforms = map(a -> a.form, vect) |> unique
        length(uniqueforms) > 1
    end
end


"""Compute morphological ambiguity in corpus analyzed by parser.
$(SIGNATURES)
"""
function formal_ambiguity(c::CitableTextCorpus, p::CitableParser; data = nothing)
    parses = parsecorpus(p, c; data = data)
    ambiguous = filter(p -> formally_ambiguous(p), parses)
    length(ambiguous) / length(c.passages)
end


"""Compute morphological ambiguity in list of words analyzed by parser.
$(SIGNATURES)
"""
function formal_ambiguity(vocablist, p::CitableParser; data = nothing)
    parses = parsewordlist(p, vocablist; data = data)
    ambiguous = filter(p -> formally_ambiguous(p), parses)
    length(ambiguous) / length(vocablist)
end

"""Compute frequencies of lexemes in corpus analyzed by parser.
$(SIGNATURES)
"""
function lexical_frequencies(c::CitableTextCorpus, p::CitableParser; data = nothing)
    @warn("Not yet implemented")
    nothing
end

"""Compute frequencies of forms in corpus analyzed by parser.
$(SIGNATURES)
"""
function formal_frequencies(c::CitableTextCorpus, p::CitableParser; data = nothing)
    @warn("Not yet implemented")
    nothing
end