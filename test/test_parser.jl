@testset "Test generic functions on Parser subtypes" begin
    module FakeParseModule
        using CitableParserBuilder
        import CitableParserBuilder: parsewordlist
        export parsewordlist
        struct FakeParser <: CitableParser
            label
        end
        function parsetoken(p::FakeParser, token) 
            # Returns only nothing values no matter
            # what the token is
            [
                Analysis(
                token,
                LexemeUrn("fakeparser.nothing"),
                FormUrn("fakeparser.nothing"),
                StemUrn("fakeparser.nothing"),
                RuleUrn("fakeparser.nothing")
            )
            ]
        end
    end

    r = FakeParser("Parser generating nothing but nothing")
    
    parse = parsetoken(r, "token")
    @test length(parse) == 1
    @test  parse[1].token == "token"
    

    listparse = parsewordlist(r, ["token1", "token2"])
    @test length(listparse) == 2
    @test listparse[1].token == "token1"


    @test_broken parselistfromfile(r,"not even looking at a file") |> isnothing
    @test_broken parselistfromurl(r,"no url involved") |> isnothing
end