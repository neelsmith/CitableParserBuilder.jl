
@testset "Test analyzing a corpus" begin
    f = joinpath("data","gettysburgcorpus.cex")
    c = fromcex(f, CitableTextCorpus, FileReader)
    ortho = simpleAscii()
    parser = CitableParserBuilder.gettysburgParser()
    wdlist = tokenvalues(c, ortho)
    tokenized = tokenizedcorpus(c, ortho)
    analyses = parsecorpus(tokenized, parser; data = parser.data)
    @test length(analyses) == 1313
end

@testset "Test serializing an analysis list" begin
    f = "data/gettysburgcorpus.cex"
    c = fromcex(f, CitableTextCorpus, FileReader)
    ortho = simpleAscii()
    parser = CitableParserBuilder.gettysburgParser()
  

    registry = Dict(
        "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
        "gburgform" => "urn:cite2:citedemo:gburgform.v1:",
        "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
        "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
    )
end