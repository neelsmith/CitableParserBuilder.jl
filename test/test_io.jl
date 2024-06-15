@testset "Create CITE I/O patterns on Analysis type" begin
    str = "Et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    mform = "et"
    a1 = Analysis(str, lex, form, stem, rule, mform)
    analysiscex = cex(a1)
    a2 = fromcex(analysiscex, Analysis)
    @test a1 == a2
end


@testset "Test CITE I/O patterns on AnalyzedTokenCollection" begin
    f = joinpath(pwd(), "data", "ambiganalysis.cex")
    tokncoll = fromcex(f, AnalyzedTokenCollection, FileReader)
    collectioncex = cex(tokncoll)
    tkncoll2 = fromcex(collectioncex, AnalyzedTokenCollection)
    @test tokncoll == tkncoll2
end



@testset "Test CITE I/O patterns on AnalyzedToken type" begin
    atknsrc =  "urn:cts:demo:latin.sample:1|Et|Et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1|et|LexicalToken"
    atkn1 = fromcex(atknsrc, AnalyzedToken)
    
   
    @test atkn1 isa AnalyzedToken
    @test length(analyses(atkn1))  == 1

    atkncex = cex(atkn1)
    atkn2 = fromcex(atkncex, AnalyzedToken)
    @test atkn1 == atkn2



    ambigcex = """urn:cts:demo:latin.sample:2|abducere|abducere|urn:cite2:citedemo:ls.v1:x|urn:cite2:citedemo:morphforms.v1:x|urn:cite2:citedemo:stems.v1:x|urn:cite2:citedemo:rules.v1:x|abducere|LexicalToken
urn:cts:demo:latin.sample:2|abducere|abducere|urn:cite2:citedemo:ls.v1:y|urn:cite2:citedemo:morphforms.v1:y|urn:cite2:citedemo:stems.v1:y|urn:cite2:citedemo:rules.v1:y|abducere|LexicalToken
urn:cts:demo:latin.sample:2|abducere|abducere|urn:cite2:citedemo:ls.v1:z|urn:cite2:citedemo:morphforms.v1:z|urn:cite2:citedemo:stems.v1:y|urn:cite2:citedemo:rules.v1:z|abducere|LexicalToken
"""
    atkn3 = fromcex(ambigcex, AnalyzedToken)
    @test length(analyses(atkn3)) == 3

    multicex = cex(atkn3)
    atkn4 = fromcex(multicex, AnalyzedToken)
    @test atkn3 == atkn4

end

