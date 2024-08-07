@testset "Test generating via dispatch to abstract dataframe-backed parser" begin
    f = joinpath(pwd(), "data", "gbparses.csv")
    df = CSV.read(f, DataFrame)
    tinyparser = MinimumDFParser(df)
    @test tinyparser isa MinimumDFParser

    lex = LexemeUrn("gburglex.come")
    mform = FormUrn("pennpos.VBN")
    matches = generate(lex, mform, tinyparser)

    @test length(matches) == 1
    @test matches[1] isa Analysis
   
end


@testset "Test generating via dispatch to abstract string-backed parser" begin
    f = joinpath(pwd(), "data", "gbparses.csv")
    datavals = readlines(f)[2:end]

    tinyparser = MinimumSParser(datavals)

    @test tinyparser isa MinimumSParser

    lex = LexemeUrn("gburglex.come")
    mform = FormUrn("pennpos.VBN")
    matches = generate(lex, mform, tinyparser; delim = ",")

    @test length(matches) == 1
    @test matches[1] isa Analysis
end