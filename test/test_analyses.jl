
@testset "Test serializing analysis object" begin
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule)
    expected = "et,ls.n16278,morphforms.1000000001,rules.example1,stems.example1" 
    @test cex(a, ",") == expected
    piped  = "et|ls.n16278|morphforms.1000000001|rules.example1|stems.example1"
    @test cex(a, "|") == piped
end


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
    expected = "urn:cts:demo:latin.sample:1|Et|et|ls.n16278|morphforms.1000000001|rules.example1|stems.example1"
    @test cex(tkn)[1] == expected
end

@testset "Test parsing a serialized AnalyzedToken" begin
  cexsrc = "urn:cts:demo:latin.sample:1|Et|et|ls.n16278|morphforms.1000000001|rules.example1|stems.example1"
  atkn = CitableParserBuilder.analyzedtokenabbr_fromcex(cexsrc, "|" )
  @test isa(atkn, AnalyzedToken)
  @test length(atkn.analyses) == 1
  a = atkn.analyses[1]
  @test a.lexeme == LexemeUrn("ls.n16278")
  @test a.form == FormUrn("morphforms.1000000001")
  @test a.rule == RuleUrn("rules.example1")
  @test a.stem == StemUrn("stems.example1")
end


@testset "Test parsing analyses from file" begin
  @test_broken 1 == 2
end