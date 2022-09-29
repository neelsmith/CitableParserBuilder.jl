@testset "Test parsing API" begin
    dictfile = joinpath("data", "posdict.csv")
    dict  = CSV.File(dictfile) |> Dict
    parser = CitableParserBuilder.gettysburgParser(dict = dict)
    parse = parsetoken("Four", parser, data = dict)
    @test length(parse)  == 1


    listresults = parselist(["Four","score","and","seven"], parser, data = dict)
    @test length(listresults) == 4


    f = joinpath("data","wordlist.txt")
    fileresults = parselist(f, parser, FileReader, data = dict)
    @test length(fileresults) == 4

    url = "https://raw.githubusercontent.com/neelsmith/CitableParserBuilder.jl/dev/test/data/wordlist.txt"
    urlresults = parselist(url, parser, UrlReader, data = dict)
    @test length(urlresults) == 4

end