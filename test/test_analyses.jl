
@testset "Test serializing analysis object" begin
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule)
    expected = "et,ls.n16278,morphforms.1000000001,rules.example1,stems.example1" 
    @test cex(a) == expected
end


@testset "Test serializing analyzed token" begin
    
end