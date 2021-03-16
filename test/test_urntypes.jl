@testset "Create FormUrn" begin
    formurn = FormUrn("morphforms.1000000001")
    @test isa(formurn, FormUrn)
    @test formurn.collection == "morphforms"
    @test formurn.objectid == "1000000001"
end

@testset "Create RuleUrn" begin
    formurn = RuleUrn("nouninfl.h_hs1")
    @test isa(formurn, RuleUrn)
    @test formurn.collection == "nouninfl"
    @test formurn.objectid == "h_hs1"
end


@testset "Create StemUrn" begin
    formurn = StemUrn("nounstems.n22502")
    @test isa(formurn, StemUrn)
    @test formurn.collection == "nounstems"
    @test formurn.objectid == "n22502"
end

@testset "Create LexemeUrn" begin
    formurn = LexemeUrn("lexent.n22502")
    @test isa(formurn, LexemeUrn)
    @test formurn.collection == "lexent"
    @test formurn.objectid == "n22502"
end