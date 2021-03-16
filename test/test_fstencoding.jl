
@testset "Test fst encdoing of URNs" begin
    au = LexemeUrn("lexicon.lex123")
    fst = fstsafe(au)
    @test fst == "<u>lexicon\\.lex123</u>"
end