
# Appendix: a note on the citable parser

The `GettysburgParser` used in this demonstration works with a simple dictionary of tokens to POS tags.  The dictionary was constructed by wrapping the Python NLTK POS tagger with a Julia function. This page documents how to do that so that you can generically apply the NTLK tagger to a list of tokens from Julia.


## Python prerequisites

You need to have Python, with `nltk`.

    pip install nltk

Then start python, and at the python prompt,

    import nltk
    nltk.download

## A Julia wrapper


```
# If you're in a system with python accessible
# and the nltk module installed, you can actually
# execute all the code blocks on this page.
repo = pwd() |> dirname  |> dirname |> dirname
gburgfile = repo * "/test/data/gettysburg/gettysburgcorpus.cex"
using CitableCorpus
corpus = corpus_fromfile(gburgfile, "|")
```

!!! note
   
    In the `extra` directory, the script `engpos.jl` does everything documented here, and can be run from the command line from the root of the repository with `julia --project=extra/ extra/engpos.jl`



In Julia, you can make the NLTK module's `tag` function available like this:

```
using Conda
Conda.add("nltk")
using PyCall
@pyimport nltk.tag as ptag
```


Now if we have a citable corpus named `corpus`, we can use the `TextAnalysis` functions to extract a unique lexicon, and apply the NLTK tagger to it.



```
using CitableCorpusAnalysis
using TextAnalysis
tacorp = tacorpus(corpus)

tkns = []
for doc in tacorp.documents
    push!(tkns, tokens(doc))
end
tknlist = tkns |> Iterators.flatten |> collect |> unique
tagged = ptag.pos_tag(tknlist)
```

