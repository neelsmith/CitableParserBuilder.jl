
@testset "Test analyzing a corpus" begin
    f = "data/gettysburgcorpus.cex"
    c = read(f, String) |> corpus_fromcex
    ortho = simpleAscii()
    parser = CitableParserBuilder.gettysburgParser()
    wdlist = tokenvalues(ortho, c)
    tokenized = tokenizedcorpus(ortho,c)
    analyses = parsecorpus(parser, tokenized, parser.data)
end

@testset "Test serializing an analysis list" begin
    f = "data/gettysburgcorpus.cex"
    c = read(f, String) |> corpus_fromcex
    ortho = simpleAscii()
    parser = CitableParserBuilder.gettysburgParser()
  

    registry = Dict(
        "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
        "gburgform" => "urn:cite2:citedemo:gburgform.v1:",
        "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
        "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
    )
end