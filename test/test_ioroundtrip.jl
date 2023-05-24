@testset "Test roundtripping serializing of analyses" begin
    f = joinpath(pwd(), "data","gburgerrors.cex")
    corpus = fromcex(f, CitableTextCorpus, FileReader)
    tc = tokenizedcorpus(corpus, simpleAscii())

    dictcsv = joinpath(pwd(),"data", "posdict.csv")
    dictdata = CSV.File(dictcsv) |> Dict
    parser = CitableParserBuilder.gettysburgParser(dict = dictdata)

    parsed =  parsecorpus(tc, parser; data = parser.data)
    @test isa(parsed, AnalyzedTokens)
    @test length(parsed) == 64

    abbrcexfile = mktemp()[1]
    open(abbrcexfile,"w") do io
        write(io, cex(parsed))
    end
    roundtripped = fromcex(abbrcexfile, AnalyzedTokens, FileReader) #read(abbrcexfile, String) |>  CitableParserBuilder.analyzedtokens_fromabbrcex
    @test typeof(roundtripped) == typeof(parsed)
    @test length(roundtripped) == length(parsed)
    rm(abbrcexfile)
    urndict = Dict(
    "gburglex" => "urn:cite2:citedemo:gburglex.v1:",
    "gburgform" => "urn:cite2:citedemo:gburgform.v1:",
    "gburgrule" => "urn:cite2:citedemo:gburgrule.v1:",
    "gburgstem" => "urn:cite2:citedemo:gburgstem.v1:"
    )
    cexfile = mktemp()[1]
    open(cexfile,"w") do io
        write(io, delimited(parsed; registry = urndict))
    end
    roundtrippedurns = read(cexfile, String) |>  analyzedtokens_fromcex
    @test typeof(roundtrippedurns) == typeof(parsed)
    @test length(roundtrippedurns) == length(parsed)
    rm(cexfile)
end