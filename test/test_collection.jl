@testset "Test collection of AnalyzedTokenCollection" begin
    atkn = "urn:cts:demo:latin.sample:1|Et|et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1|et|LexicalToken"
    analysiscollection = [fromcex(atkn, AnalyzedToken)]
end