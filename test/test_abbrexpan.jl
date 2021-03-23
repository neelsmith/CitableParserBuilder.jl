@testset "Create abbreviated urn string from a Cite2Urn" begin
    conjunctionurn = Cite2Urn("urn:cite2:kanones:morphforms.v1:1000000001")
    @test abbreviate(conjunctionurn) == "morphforms.1000000001"
    formurn = abbreviate(conjunctionurn)  |> FormUrn
    @test isa(formurn,FormUrn)
end



@testset "Use Dict to expand AbbreviatedUrn" begin
    registry = Dict(
        "morphforms" => "urn:cite2:kanones:morphforms.v1:"
    )
    formurn = FormUrn("morphforms.1000000001")
    expanded = expand(formurn, registry)
    expectedurn = Cite2Urn("urn:cite2:kanones:morphforms.v1:1000000001")
    @test expanded == expectedurn
end

@testset "Compose abbreviation string for an AbbreviatedUrn" begin
    formurn = FormUrn("morphforms.1000000001")
    @test abbreviation(formurn) == "morphforms.1000000001"
end

@testset "In abbreviation string, preserve FST reserved characters without escaping" begin
    rule = RuleUrn("nouninfl.h_hs2")
    @test abbreviation(rule) == "nouninfl.h_hs2"
end