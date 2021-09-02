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