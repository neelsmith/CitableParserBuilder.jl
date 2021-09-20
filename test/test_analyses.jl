
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
#=
  atkn = CitableParserBuilder.analyzedtokenabbr_fromcex(cexsrc, "," )
  
  a = atkn.analyses
  @test a.lexeme == LexemeUrn("lsj.n76063")
  @test a.form == FormUrn("morphforms.1000000004")
  @test a.stem == StemUrn("litgreek.indeclinable4")
  @test a.rule == RuleUrn("uninflectedstems.n76063")
=#
end


@testset "Test parsing analyses from file" begin
  @test_broken 1 == 2
end