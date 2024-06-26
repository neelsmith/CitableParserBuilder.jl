
@testset "Test analyzing a corpus" begin
    f = joinpath("data","gettysburgcorpus.cex")
    c = fromcex(f, CitableTextCorpus, FileReader)
    ortho = simpleAscii()


    parser = CitableParserBuilder.gettysburgParser(pwd() |> dirname)

    wdlist = tokenvalues(c, ortho)
    tokenized = tokenizedcorpus(c, ortho, filterby = LexicalToken())
    analyses = parsecorpus(tokenized, parser; data = parser.data)
    @test length(analyses) == 1313

    @test orthography(parser) isa SimpleAscii
end

@testset "Test serializing an analysis list" begin
    f = "data/gettysburgcorpus.cex"
    c = fromcex(f, CitableTextCorpus, FileReader)
    ortho = simpleAscii()

    parser = CitableParserBuilder.gettysburgParser(pwd() |> dirname)

    
  

    registry = Dict(
        "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
        "gburgform" => "urn:cite2:citedemo:gburgform.v1:",
        "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
        "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
    )
end