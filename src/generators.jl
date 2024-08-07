"""Create a dataframe-backed parser from a string-backed parser.
$(SIGNATURES)
"""
function DFParser(sp::StringParser)
    DFParser(dataframe(sp), orthography(sp))
end



"""Generate all possible morphological analyses for a given lexeme and form.
$(SIGNATURES)
"""
function generate(lex::LexemeUrn, mform::FormUrn, parser::AbstractStringParser; delim = "|") 
    @info("Generating from string-backed parser")
    ptrn = string(delim, lex, delim, mform, delim)
    @info("Ptr $(ptrn)")
    matches = filter(ln -> occursin(ptrn, ln), datasource(parser)) 
    map(ln -> fromcex(ln, Analysis; delimiter = delim), matches)
    # .|> analysis
end



"""Generate all possible morphological analyses for a given lexeme and form.
$(SIGNATURES)
"""
function generate(lex::LexemeUrn, mform::FormUrn, parser::AbstractDFParser)
    rows = filter(row -> row.Lexeme == string(lex) && row.Form == string(mform), datasource(parser))
    resultarray = Analysis[]

    for r in eachrow(rows)
        a =  Analysis(
            r.Token, 
            LexemeUrn(r.Lexeme),
            FormUrn(r.Form),
            StemUrn(r.Stem),
            RuleUrn(r.Rule),
            r.MToken,
            r.MTokenID

        )
        push!(resultarray, a)
    end
    resultarray
    
end
