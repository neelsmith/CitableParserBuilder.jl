@testset "Test roundtripping serializing of analyses" begin
    f = joinpath(pwd(), "data","gburgerrors.cex")
    corpus = fromcex(f, CitableTextCorpus, FileReader)
    tc = tokenizedcorpus(corpus, simpleAscii())
    
    parser = CitableParserBuilder.gettysburgParser(pwd() |> dirname)

    parsed =  parsecorpus(tc, parser)
    @test parsed isa  AnalyzedTokenCollection
    @test length(parsed) == 64

    cexout = cex(parsed)
    roundtripped = fromcex(cexout, AnalyzedTokenCollection)
    @test_broken roundtripped == parsed
    @test typeof(roundtripped) == typeof(parsed)
    @test_broken length(roundtripped) == length(parsed)
    
    # This part is broken:
    urndict = Dict(
    "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
    "pennpos"  => "urn:cite2:citedemo:pennpos.v1:",
    "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
    "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
    )
    cexfile = mktemp()[1]
    open(cexfile,"w") do io
        write(io, cex(parsed; registry = urndict))
    end
    roundtrippedurns = fromcex(read(cexfile, String), AnalyzedTokenCollection)
    @test typeof(roundtrippedurns) == typeof(parsed)
    @test_broken length(roundtrippedurns) == length(parsed)
    rm(cexfile)
end