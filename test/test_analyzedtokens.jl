@testset "Test serializing analyzed token" begin
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule)

    u = CtsUrn("urn:cts:demo:latin.sample:1")
    cn = CitablePassage(u, "Et")
    tkn = AnalyzedToken(cn, [a]) 
    # Note that this 
    expected = "urn:cts:demo:latin.sample:1|Et|et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1"
    @test cex(tkn)[1] == expected
end

@testset "Test serializing analyzed token with a registry" begin
    dict = Dict(
      "ls" => "urn:cite2:citedemo:ls.v1:",
      "morphforms" => "urn:cite2:citedemo:morphforms.v1:",
      "stems" => "urn:cite2:citedemo:stems.v1:",
      "rules" => "urn:cite2:citedemo:rules.v1:"
    )
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule)
  
    u = CtsUrn("urn:cts:demo:latin.sample:1")
    cn = CitablePassage(u, "Et")
    tkn = AnalyzedToken(cn, [a]) 
end

@testset "Test parsing a serialized AnalyzedToken with abbreviated URNs" begin
    cexsrc = "urn:cts:demo:latin.sample:1|Et|et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1"
    atkn = CitableParserBuilder.analyzedtoken_fromabbrcex(cexsrc, "|" )
    @test isa(atkn, AnalyzedToken)
    @test length(atkn.analyses) == 1
    a = atkn.analyses[1]
    @test a.lexeme == LexemeUrn("ls.n16278")
    @test a.form == FormUrn("morphforms.1000000001")
    @test a.stem == StemUrn("stems.example1")
    @test a.rule == RuleUrn("rules.example1")
end

@testset "Test parsing a serialized AnalyzedToken using full URNs" begin
    cexsrc =  "urn:cts:demo:latin.sample:1|Et|et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1"
    atkn = CitableParserBuilder.analyzedtoken_fromcex(cexsrc, "|" )
    @test isa(atkn, AnalyzedToken)
    @test length(atkn.analyses) == 1
    a = atkn.analyses[1]
    @test a.lexeme == LexemeUrn("ls.n16278")
    @test a.form == FormUrn("morphforms.1000000001")
    @test a.stem == StemUrn("stems.example1")
    @test a.rule == RuleUrn("rules.example1")
end




@testset "Test parsing multiple analyses" begin
    f = "data/ambiganalysis.cex"
    cexsrc = read(f, String)
    atokens = analyzedtokens_fromcex(cexsrc)
    @test length(atokens) == 2
    @test length(atokens[2].analyses) == 3
end
