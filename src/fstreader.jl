"""Read SFST output from file, and parse into a dictionary of
tokens -> (possibly empty) array of SFST strings.

$(SIGNATURES)

## Parameters

- `f` Name of file to read in.
"""
function  readfst(f)
    analyses = Dict()
    currenttoken = ""
    currentfst = []
    for ln in eachline(f)
        if startswith(ln, "no result")
            analyses[currenttoken] = []
        elseif startswith(ln, "<u>")
            push!(currentfst, ln)
        else            
            analyses[currenttoken] = currentfst
            currenttoken = replace(ln, "> " => "")
            currentfst = []
        end
    end
    analyses
end