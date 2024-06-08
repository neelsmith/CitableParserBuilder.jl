function generate(0)
    delim = "|"
    lex = LexemeUrn("gburglex.come")
    mform = FormUrn("pennpos.VBN")
    ptrn = string(delim, lex, delim, mform, delim)
    reslts =  filter(ln -> occursin(ptrn, ln), datasource(parser)) .|> analysis
end