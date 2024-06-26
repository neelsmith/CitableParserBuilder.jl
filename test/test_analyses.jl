
@testset "Test serializing analysis object" begin
    str = "Et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    mform = "et"
    a = Analysis(str, lex, form, stem, rule, mform)
    expected = "Et,ls.n16278,morphforms.1000000001,stems.example1,rules.example1,et" 
    @test delimited(a; delim = ",") == expected
    piped  = "Et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1|et"
    @test delimited(a; delim = "|") == piped
end

@testset "Test serializing analysis using CITE2 URNs" begin
  dict = Dict(
    "ls" => "urn:cite2:citedemo:ls.v1:",
    "morphforms" => "urn:cite2:citedemo:morphforms.v1:",
    "rules" => "urn:cite2:citedemo:rules.v1:",
    "stems" => "urn:cite2:citedemo:stems.v1:"
  )
  str = "Et"
  form = FormUrn("morphforms.1000000001")
  lex = LexemeUrn("ls.n16278")
  rule = RuleUrn("rules.example1")
  stem = StemUrn("stems.example1")
  normed = "et"
  a = Analysis(str, lex, form, stem, rule, normed)
  expected = "Et,urn:cite2:citedemo:ls.v1:n16278,urn:cite2:citedemo:morphforms.v1:1000000001,urn:cite2:citedemo:stems.v1:example1,urn:cite2:citedemo:rules.v1:example1,et"
  @test delimited(a; delim =  ",", registry = dict) == expected
  piped  = "Et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1|et"
  @test delimited(a; registry = dict) == piped

  relationblock = relationsblock(Cite2Urn("urn:cite2:citedemo:citableparser.v1:analyses1"), "Vector of 1 analysis to test with", [a], registry=dict)
  length(split(relationblock, "\n")) == 4
end


@testset "Test equality function on Analysis" begin
  a1 = Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2010003100"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i13"), "donum")
  a2 = Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2010003100"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i13"), "donum")
  a1 == a2
end


@testset "Test member accessor functions" begin
  a = Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2010003100"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i13"),"donum")  
  
  @test token(a) == "donum"
  @test mtoken(a) == "donum"
  @test lexemeurn(a) ==  LexemeUrn("ls.n14736")
  @test formurn(a) == FormUrn("forms.2010003100")
  @test stemurn(a) == StemUrn("latcommon.nounn14736")
  @test ruleurn(a) ==  RuleUrn("nouninfl.us_i13")
  
end
