@testset "Test generic functions on Parser subtypes" begin
   
    struct FakeParser <: CitableParser
        label
        stringparser
    end
    function fakestringparser(token) 
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
    

    r = FakeParser("Parser generating nothing but nothing", fakestringparser)
    
    parse = parsetoken(r, "token")
    @test length(parse) == 1
    @test  parse[1].token == "token"
    

    listparse = parsewordlist(r, ["token1", "token2"])
    @test length(listparse) == 2
    p1 = listparse[1][1]
    @test p1.token == "token1"


#    @test_broken parselistfromfile(r,"not even looking at a file") |> isnothing
#    @test_broken parselistfromurl(r,"no url involved") |> isnothing

end