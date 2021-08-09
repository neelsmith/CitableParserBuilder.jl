@testset "Test generic functions on Parser subtypes" begin
    struct FakeParser <: CitableParser
        label
    end
    r = FakeParser("Parser generating nothing but nothing")
    @test parsetoken(r, "token") |> isnothing
    @test parsewordlist(r,["token1", "token2"]) |> isnothing
    @test parselistfromfile(r,"not even looking at a file") |> isnothing
    @test parselistfromurl(r,"no url involved") |> isnothing
end