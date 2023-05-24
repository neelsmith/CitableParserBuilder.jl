
# Tokens
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



# Lexemes
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
 

# Rules
@testset "Test extracting rules from list of Analysis objects" begin
    a1 = Analysis("donorum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19"))
    a2 =   Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19a"))
  
    resultlist = [a1, a2]
  
    expected = [RuleUrn("nouninfl.us_i19"), RuleUrn("nouninfl.us_i19a")]
    @test rules(resultlist) == expected
end
  
@testset "Test extracting rules from AnalyzedToken objects" begin
    f = joinpath(pwd(), "data", "ambiganalysis.cex")
    atc = fromcex(f, AnalyzedTokens, FileReader)
    expected = [ 
    RuleUrn("rules.example1"),
    RuleUrn("rules.x"),
    RuleUrn("rules.y"),
    RuleUrn("rules.z")]
    @test rules(atc) == expected

    analysislist = atc.analyses
    @test rules(analysislist) == expected
end


# Stems
  
@testset "Test extracting stems from list of Analysis objects" begin
    a1 = Analysis("donorum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19"))
    a2 =   Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19a"))
  
    resultlist = [a1, a2]
  
    expected = [StemUrn("latcommon.nounn14736")]
    @test stems(resultlist) == expected
end
  
@testset "Test extracting stems from AnalyzedToken objects" begin
    f = joinpath(pwd(), "data", "ambiganalysis.cex")
    atc = fromcex(f, AnalyzedTokens, FileReader)
    expected = [ 
        StemUrn("stems.example1"),
        StemUrn("stems.x"),
        StemUrn("stems.y")]
    @test stems(atc) == expected

    analysislist = atc.analyses
    @test stems(analysislist) == expected
end



# Forms  
@testset "Test extracting forms from list of Analysis objects" begin
    a1 = Analysis("donorum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19"))
    a2 =   Analysis("donum", LexemeUrn("ls.n14736"), FormUrn("forms.2020003200"), StemUrn("latcommon.nounn14736"), RuleUrn("nouninfl.us_i19a"))
  
    resultlist = [a1, a2]
  
    expected = [FormUrn("forms.2020003200")]
    @test forms(resultlist) == expected
end
  
@testset "Test extracting forms from AnalyzedToken objects" begin
    f = joinpath(pwd(), "data", "ambiganalysis.cex")
    atc = fromcex(f, AnalyzedTokens, FileReader)
    expected = [ 
        FormUrn("morphforms.1000000001"),
        FormUrn("morphforms.x"),
        FormUrn("morphforms.y"),
        FormUrn("morphforms.z")]
    @test forms(atc) == expected

    analysislist = atc.analyses
    @test forms(analysislist) == expected
end



  

  

  

  


