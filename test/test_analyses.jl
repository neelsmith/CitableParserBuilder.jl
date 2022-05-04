
@testset "Test serializing analysis object" begin
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule)
    expected = "et,ls.n16278,morphforms.1000000001,stems.example1,rules.example1" 
    @test delimited(a, ",") == expected
    piped  = "et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1"
    @test delimited(a, "|") == piped
end

@testset "Test serializing analysis using CITE2 URNs" begin
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
  expected = "et,urn:cite2:citedemo:ls.v1:n16278,urn:cite2:citedemo:morphforms.v1:1000000001,urn:cite2:citedemo:stems.v1:example1,urn:cite2:citedemo:rules.v1:example1"
  @test delimited(a, ","; registry = dict) == expected
  piped  = "et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1"
  @test delimited(a; registry = dict) == piped

  relationblock = relationsblock(Cite2Urn("urn:cite2:citedemo:citableparser.v1:analyses1"), "Vector of 1 analysis to test with", [a], registry=dict)
  length(split(relationblock, "\n")) == 4
end


@testset "Test equality function on Analysis" begin
  a1 = Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2010003100"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i13"))
  a2 = Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2010003100"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i13"))
  a1 == a2
end


@testset "Test formatting string list of tokens from list of Analysis objects" begin
  a1 = Analysis("donorum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19"))
  a2 =   Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19a"))

  resultlist = [a1, a2]

  expected = "donorum, donum"
  @test CitableParserBuilder.tokens(resultlist) == expected
end

@testset "Test member accessor functions" begin
  a = Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2010003100"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i13"))  
  
  @test token(a) == "donum"
end
