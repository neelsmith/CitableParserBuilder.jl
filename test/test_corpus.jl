@testset "Test analyzing a corpus" begin
    struct FakeParser <: CitableParser
        label
        stringparser
    end
    function fakestringparser(token) 
        # Returns only nothing values no matter
        # what the token is
        [
            Analysis(
            token,
            LexemeUrn("fakeparser.nothing"),
            FormUrn("fakeparser.nothing"),
            StemUrn("fakeparser.nothing"),
            RuleUrn("fakeparser.nothing")
        )
        ]
    end
    fp = FakeParser("Parser generating nothing but nothing", fakestringparser)
    mred = CitableTextCorpus([
        CitableNode(CtsUrn("urn:cts:docstrings:mred.themesong:1"),"A horse is a horse, of course, of course,"),
        CitableNode(CtsUrn("urn:cts:docstrings:mred.themesong:2"),"And no one can talk to a horse of course,"),
        CitableNode(CtsUrn("urn:cts:docstrings:mred.themesong:3"),"That is, of course, unless the horse is the famous Mr. Ed."),
])

    analyses = analyzecorpus(fp, simpleAscii(), mred)
    @test length(analyses) == 31
end

@testset "Test inclusion of varargs in corpus analysis" begin
    struct ParserWithDictionary <: CitableParser
        stringparser
    end
    function dictionaryparser(token, data) 
        dict = data[1]
        lc = lowercase(token)
        if haskey(dict, lc)
            @info("LC ", lc, " IS a key")
        else
            @info("LC ", lc, " is NOT a key")
        end
        formval = haskey(dict, lc) ? dict[lc] : "UNANALYZED"
        @info("FORMVAL ", formval, " LC " , lc)
        @info("FROM DICT ", dict)
        [
            Analysis(
            token,
            LexemeUrn("fakeparser." * token),
            FormUrn("fakeparser." * formval),
            StemUrn("fakeparser.nothing"),
            RuleUrn("fakeparser.nothing")
        )
        ]
    end
    dictp = ParserWithDictionary(dictionaryparser)

    data = Dict(
            "a" => "ART",
            "is" => "VRB",
            "horse" => "NOUN",
            "of" => "PREP",
            "course" => "NOUN",
        )
    shortmred = CitableTextCorpus([
            CitableNode(CtsUrn("urn:cts:docstrings:mred.themesong:1"),"A horse is a horse, of course, of course,")])
    analyses = analyzecorpus(dictp, simpleAscii(), shortmred, data)            
end