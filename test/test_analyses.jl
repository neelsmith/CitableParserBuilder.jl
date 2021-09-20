
@testset "Test serializing analysis object" begin
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule)
    expected = "et,ls.n16278,morphforms.1000000001,stems.example1,rules.example1" 
    @test cex(a, ",") == expected
    piped  = "et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1"
    @test cex(a, "|") == piped
end

@testset "Test serializing analysis using a URN registry" begin
  dict = Dict(
    "ls" => "urn:cite2:citedemo:ls.v1:",
    "morphforms" => "urn:cite2:citedemo:morphforms.v1:",
    "rules" => "urn:cite2:citedemo:rules.v1:",
    "stems" => "urn:cite2:citedemo:stems.v1:"
  )
  str = "et"
  form = FormUrn("morphforms.1000000001")
  lex = LexemeUrn("ls.n16278")
  rule = RuleUrn("rules.example1")
  stem = StemUrn("stems.example1")
  a = Analysis(str, lex, form, stem, rule)
  expected = "et,urn:cite2:citedemo:ls.v1:n16278,urn:cite2:citedemo:morphforms.v1:1000000001,urn:cite2:citedemo:rules.v1:example1,urn:cite2:citedemo:stems.v1:example1"
  @test cex(a, ","; registry = dict) == expected
  piped  = "et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:rules.v1:example1|urn:cite2:citedemo:stems.v1:example1"
  @test cex(a; registry = dict) == piped
end




