@testset "Test parsing API" begin
    parser = CitableParserBuilder.gettysburgParser(pwd() |> dirname)
    parse = parsetoken("Four", parser)
    @test length(parse)  == 1


    listresults = parselist(["Four","score","and","seven"], parser)
    @test length(listresults) == 4


    f = joinpath("data","wordlist.txt")
    fileresults = parselist(f, parser, FileReader)
    @test length(fileresults) == 4

    url = "https://raw.githubusercontent.com/neelsmith/CitableParserBuilder.jl/dev/test/data/wordlist.txt"

    
    urlresults = parselist(url, parser, UrlReader)
    @test length(urlresults) == 4

end