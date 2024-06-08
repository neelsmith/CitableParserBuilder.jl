
@testset "Test fst encdoing of URNs" begin
    au = LexemeUrn("lexicon.lex123")
    fst = fstsafe(au)
    @test fst == "<u>lexicon\\.lex123</u>"
end

@testset "Test protecting underscores" begin
    rule = RuleUrn("nouninfl.h_hs1")
    fst = fstsafe(rule)
    @test fst == "<u>nouninfl\\.h\\_hs1</u>"
end