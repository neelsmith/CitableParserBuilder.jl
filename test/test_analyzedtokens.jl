@testset "Test serializing analyzed token" begin
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule)

    u = CtsUrn("urn:cts:demo:latin.sample:1")
    cn = CitablePassage(u, "Et")
    ctkn = CitableToken(cn, LexicalToken())
    atkn = AnalyzedToken(ctkn, [a]) 
   
    expected = "urn:cts:demo:latin.sample:1|Et|et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1|LexicalToken"
    @test cex(atkn) == expected
end


@testset "Test serializing analyzed token with a registry" begin
    abbrdict = Dict(
      "ls" => "urn:cite2:citedemo:ls.v1:",
      "morphforms" => "urn:cite2:citedemo:morphforms.v1:",
      "stems" => "urn:cite2:citedemo:stems.v1:",
      "rules" => "urn:cite2:citedemo:rules.v1:"
    )
    str = "et"
    form = FormUrn("morphforms.1000000001")
    lex = LexemeUrn("ls.n16278")
    rule = RuleUrn("rules.example1")
    stem = StemUrn("stems.example1")
    a = Analysis(str, lex, form, stem, rule)
  
    u = CtsUrn("urn:cts:demo:latin.sample:1")
    cn = CitablePassage(u, "Et")
    ctkn = CitableToken(cn, LexicalToken())
    atkn = AnalyzedToken(ctkn, [a]) 

    expected = "urn:cts:demo:latin.sample:1|Et|et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1|LexicalToken()"
    @test delimited(atkn; registry = abbrdict) == expected
end

@testset "Test parsing a serialized AnalyzedToken with abbreviated URNs" begin
    cexsrc = "urn:cts:demo:latin.sample:1|Et|et|ls.n16278|morphforms.1000000001|stems.example1|rules.example1|LexicalToken"
    atkn = fromcex(cexsrc, AnalyzedToken )
    @test isa(atkn, AnalyzedToken)
    @test length(atkn.analyses) == 1
    a = atkn.analyses[1]
    @test a.lexeme == LexemeUrn("ls.n16278")
    @test a.form == FormUrn("morphforms.1000000001")
    @test a.stem == StemUrn("stems.example1")
    @test a.rule == RuleUrn("rules.example1")
end

@testset "Test parsing a serialized AnalyzedToken using full URNs" begin
    cexsrc =  "urn:cts:demo:latin.sample:1|Et|et|urn:cite2:citedemo:ls.v1:n16278|urn:cite2:citedemo:morphforms.v1:1000000001|urn:cite2:citedemo:stems.v1:example1|urn:cite2:citedemo:rules.v1:example1|LexicalToken"
    atkn = fromcex(cexsrc, AnalyzedToken)
    @test isa(atkn, AnalyzedToken)
    @test length(atkn.analyses) == 1
    a = atkn.analyses[1]
    @test a.lexeme == LexemeUrn("ls.n16278")
    @test a.form == FormUrn("morphforms.1000000001")
    @test a.stem == StemUrn("stems.example1")
    @test a.rule == RuleUrn("rules.example1")
end

@testset "Test parsing multiple analyses" begin
    f = "data/ambiganalysis.cex"
    
    
    atokens = analyzedtokens_fromcex(cexsrc)
    @test length(atokens) == 2
    @test length(atokens[2].analyses) == 3

    expectedlexemes =  ["ls.n16278", "ls.x", "ls.y", "ls.z"]
    @test lexemes(atokens) == expectedlexemes
    @test stringsforlexeme(atokens, "ls.n16278")[1] == "Et"
    @test passagesforlexeme(atokens, "ls.n16278")[1] == CtsUrn("urn:cts:demo:latin.sample:1")

    # @test lexemedictionary ....
end


@testset "Test lexeme dictionary" begin
    f = joinpath("data", "gettysburgcorpus.cex")
    c = fromcex(f, CitableTextCorpus, FileReader)
    tknindex =  corpusindex(c, simpleAscii())
    tokenized = tokenizedcorpus(c, simpleAscii())

    dictfile = joinpath("data", "posdict.csv")
    dict  = CSV.File(dictfile) |> Dict
    parser = CitableParserBuilder.gettysburgParser(dict = dict)
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
