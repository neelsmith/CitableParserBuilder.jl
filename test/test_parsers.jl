@testset "Test converting and serializing parsers" begin
    gp = CitableParserBuilder.gettysburgParser(pwd() |> dirname)
    @test supertype(typeof(gp)) == AbstractDFParser
end