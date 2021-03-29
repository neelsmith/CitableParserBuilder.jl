
@testset "Test generic functions on Stem subtypes" begin
    struct FakeStem <: Stem
        label
    end
    s = FakeStem("empty")
    @test CitableParserBuilder.id(s) |> isnothing
    @test CitableParserBuilder.lexeme(s) |> isnothing
    @test CitableParserBuilder.inflectiontype(s) |> isnothing
end



@testset "Test generic functions on Rule subtypes" begin
    struct FakeRule <: Rule
        label
    end
    r = FakeRule("empty")
    @test CitableParserBuilder.id(r) |> isnothing
    @test CitableParserBuilder.inflectiontype(r) |> isnothing
end