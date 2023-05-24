

@testset "Test extracting string list of tokens from list of Analysis objects" begin
    a1 = Analysis("donorum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19"))
    a2 =   Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19a"))
  
    resultlist = [a1, a2]
  
    expected = ["donorum", "donum"]
    @test tokens(resultlist) == expected
  end


  @testset "Test extracting string list of tokens AnalyzedToken objects" begin
    f = joinpath(pwd(), "data", "ambiganalysis.cex")
    atc = fromcex(f, AnalyzedTokens, FileReader)
    expected = ["et", "abducere"]

    @test tokens(atc) == expected

    analysislist = atc.analyses
    @test tokens(analysislist) == expected
  end





@testset "Test extracting string list of lexemes from list of Analysis objects" begin
    a1 = Analysis("donorum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19"))
    a2 =   Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19a"))
  
    resultlist = [a1, a2]
  
    expected = [LexemeUrn("ls.n14736")]
    @test lexemes(resultlist) == expected

  end

  @testset "Test extracting lexemes from AnalyzedToken objects" begin
    f = joinpath(pwd(), "data", "ambiganalysis.cex")
    atc = fromcex(f, AnalyzedTokens, FileReader)
    expected = [ LexemeUrn("ls.n16278"), LexemeUrn("ls.x"), LexemeUrn("ls.y"), LexemeUrn("ls.z")]

    @test lexemes(atc) == expected

    analysislist = atc.analyses
    @test lexemes(analysislist) == expected
  end
 