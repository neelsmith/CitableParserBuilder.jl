@testset "Test Citable trait for AnalyzedToken type" begin
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    mform = "et"
    a = Analysis(str, lex, form, stem, rule, mform)

    u = CtsUrn("urn:cts:demo:latin.sample:1")
    cn = CitablePassage(u, "Et")
    ctkn = CitableToken(cn, LexicalToken())
    atkn = AnalyzedToken(ctkn, [a]) 
    
    
    @test citable(atkn)
    @test label(atkn) == "<urn:cts:demo:latin.sample:1> Et (LexicalToken): 1 analysis."
    @test urntype(atkn) == CtsUrn
end