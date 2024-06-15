@testset "Create CITE I/O patterns on Analysis type" begin
    str = "Et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    mform = "et"
    a = Analysis(str, lex, form, stem, rule, mform)

    # Analysis type should be CEXSerializable!
end

@testset "Create CITE I/O patterns on AnalyzedToken type" begin
    cexsrc =  "urn:cts:demo:latin.sample:1|Et|Et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1|et|LexicalToken"
    atkn = fromcex(cexsrc, AnalyzedToken)
    # Why is this a *Vector* of anlayzed tokens instead of a single instance?
    @test_broken atkn isa AnalyzedToken
    
    # This hsould be CEXSerializable!
end


@testset "Test CITE I/O patterns on AnalyzedTokenCollection" begin
    f = joinpath(pwd(), "data", "ambiganalysis.cex")
    tokncoll = fromcex(f, AnalyzedTokenCollection, FileReader)
    collectioncex = cex(tokncoll)
    tkncoll2 = fromcex(collectioncex, AnalyzedTokenCollection)
    @test tokncoll == tkncoll2
end
