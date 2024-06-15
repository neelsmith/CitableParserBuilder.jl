@testset "Test serializing analyzed token" begin
    str = "Et"
    mtoken = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule, mtoken)

    u = CtsUrn("urn:cts:demo:latin.sample:1")
    cn = CitablePassage(u, "Et")
    ctkn = CitableToken(cn, LexicalToken())
    atkn = AnalyzedToken(ctkn, [a]) 
   
    expected = "urn:cts:demo:latin.sample:1|Et|Et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1|et|LexicalToken"
    @test cex(atkn) == expected
    # roundtrip:
    @test_broken fromcex(cex(atkn), AnalyzedToken) == atkn
end


@testset "Test serializing analyzed token with a registry" begin
    abbrdict = Dict(
      "ls" => "urn:cite2:citedemo:ls.v1:",
      "morphforms" => "urn:cite2:citedemo:morphforms.v1:",
      "stems" => "urn:cite2:citedemo:stems.v1:",
      "rules" => "urn:cite2:citedemo:rules.v1:"
    )
    str = "Et"
    mform = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule, mform)
  
    u = CtsUrn("urn:cts:demo:latin.sample:1")
    cn = CitablePassage(u, "Et")
    ctkn = CitableToken(cn, LexicalToken())
    atkn = AnalyzedToken(ctkn, [a]) 

    expected = "urn:cts:demo:latin.sample:1|Et|Et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1|et|LexicalToken"
    @test delimited(atkn; registry = abbrdict) == expected
end

@testset "Test parsing a serialized AnalyzedToken with abbreviated URNs" begin
    cexsrc = "urn:cts:demo:latin.sample:1|Et|Et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1|et|LexicalToken"
    atkn = fromcex(cexsrc, AnalyzedToken )
    @test_broken isa(atkn, AnalyzedToken)
    #@test_broken length(atkn.analyses) == 1
    #a = atkn.analyses[1]
    #@test_broken a.lexeme == LexemeUrn("ls.n16278")
    #@test_broken a.form == FormUrn("morphforms.1000000001")
    #@test_broken a.stem == StemUrn("stems.example1")
    #@test_broken a.rule == RuleUrn("rules.example1")
end

@testset "Test parsing a serialized AnalyzedToken using full URNs" begin
    cexsrc =  "urn:cts:demo:latin.sample:1|Et|Et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1|et|LexicalToken"
    atkn = fromcex(cexsrc, AnalyzedToken)
    #@test isa(atkn, AnalyzedToken)
    #@test length(atkn.analyses) == 1
    #a = atkn.analyses[1]
    #@test a.lexeme == LexemeUrn("ls.n16278")
    #@test a.form == FormUrn("morphforms.1000000001")
    #@test a.stem == StemUrn("stems.example1")
    #@test a.rule == RuleUrn("rules.example1")
end

@testset "Test parsing multiple analyses" begin
    f = joinpath(pwd(), "data", "ambiganalysis.cex")
    atokens = fromcex(f, AnalyzedTokenCollection, FileReader)
    @test length(atokens) == 2
    @test length(atokens.analyses[2].analyses) == 3

    
    @test stringsforlexeme(atokens, "ls.n16278")[1] == "Et"
    @test_broken passagesforlexeme(atokens, "ls.n16278")[1] == CtsUrn("urn:cts:demo:latin.sample:1")

    # @test lexemedictionary ....
end


@testset "Test lexeme dictionary" begin
    f = joinpath(pwd(), "data", "gettysburgcorpus.cex")
    c = fromcex(f, CitableTextCorpus, FileReader)
    tknindex =  corpusindex(c, simpleAscii())
    tokenized = tokenizedcorpus(c, simpleAscii())

    
    parser = CitableParserBuilder.gettysburgParser(pwd() |> dirname)
    
    # This is broken 
    #=
    parses = parsecorpus(tokenized,parser; data = parser.data)
    
    lexdict = lexemedictionary(parses, tknindex)
    formsoflexeme = lexdict["gburglex.or"]
    # Only one form: "or"
    @test length(formsoflexeme)  == 1
    @test collect(keys(formsoflexeme))[1]  == "or"
    psgs  = formsoflexeme["or"]
    @test length(psgs) == 10
    =#
    @test_broken isnothing(parser )
end
