@testset "Test reading FST output from a file" begin
    f = "data/latinexample.fst"
    resultsdict = readfst(f)
    @test length(resultsdict) == 10
    @test resultsdict["abdidit"]  |> isempty
    @test length(resultsdict["abducere"]) == 3
end