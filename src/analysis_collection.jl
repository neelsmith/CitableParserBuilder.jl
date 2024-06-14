"""A collection of analyzed tokens."""
struct AnalyzedTokens
    analyses::Vector{AnalyzedToken}
end

"""Override Base.show for `AnalyzedTokens`.
$(SIGNATURES)
"""
function show(io::IO, analyses::AnalyzedTokens)
    length(analyses.analyses) == 1 ? print(io, "Collection of  1 analysis") : print(io, "Collection of ", length(analyses.analyses), " analyzed tokens.")
end


"""Override `Base.==` for `Analysis`.

$(SIGNATURES)
"""
function ==(at1::AnalyzedTokens, at2::AnalyzedTokens)
    at1.analyses == at2.analyses
end



"Value for CitableTrait."
struct CitableAnalyses <: CitableCollectionTrait end

"""Define`CitableTrait` value for `AnalyzedTokens`.
$(SIGNATURES)
"""
function citablecollectiontrait(::Type{AnalyzedTokens})
    CitableAnalyses()
end

"""Typeof URN identifying analyses in an an `AnalyzedTokens` collection.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function urntype(analyses::AnalyzedTokens)
    CtsUrn
end


"""Label for `analyses`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function label(analyses::AnalyzedTokens)
    string(analyses)
end



"""Serialize an `AnalyzedTokens` object as delimited text (required for `Citable` interface).

$(SIGNATURES)
Uses abbreviated URNs.  
These can be expanded to full CITE2 URNs when read back with a URN registry,
or the `delimited` function can be used with a URN registry to write full CITE2 URNs.
"""
function delimited(atcollection::AnalyzedTokens; delim = "|", registry = nothing)
    delimited(atcollection.analyses, delim = delim, registry = registry)
end


"Value for CexTrait"
struct AnalysesCex <: CexTrait end

"""Define`CexTrait` value for `AnalyzedTokens`.
$(SIGNATURES)
"""
function cextrait(::Type{AnalyzedTokens})
    AnalysesCex()
end


"""Format an `AnalyzedTokens` collection as a delimited-text string.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function cex(analyses::AnalyzedTokens; delimiter = "|")
    header = "#!ctsdata\n"

    strings = map(atoken -> cex(atoken, delimiter=delimiter), analyses)
    header * join(strings, "\n")
end


"""Parse a delimited-text string into an `AnalyzedTokens` collection.
$(SIGNATURES)
"""
function fromcex(trait::AnalysesCex, s::AbstractString,  ::Type{AnalyzedTokens}; delimiter = "|", configuration = nothing, strict = true)
    @info("HEY! PARSE Plural AnalyzedTokens from cex")
    rawlines = split(s, "\n")[2:end]
    datalines = filter(ln -> ! isempty(ln), rawlines)

    debugdisp = join(datalines,"\n\n")
    @info("Datalines:\n $(debugdisp)")

    prevcitable = nothing
    curranalyses = Analysis[]
    tokens = AnalyzedToken[]
    @info("$(length(datalines)) data lines")
    for ln in datalines
        parts = split(ln, delimiter)

        if length(parts) < 9
            msg = "Error reading AnalyzedTokens from cex. Too few parts ($(length(parts))) in $(parts)"
            @warn(msg)
            DomainError(msg)
        else
            @debug("LINEL: ", ln)
            @debug("Yields $(length(parts)) parts")

            currpsg = CitablePassage(CtsUrn(parts[1]), parts[2])
            @info("Looking at currpsg $(currpsg)")
            @debug("type empty? $(isempty(parts[9]))")
            if isempty(parts[9])
                @warn("Couldn't form a token type for $(currpsg)")
            else
                ttypestr = parts[9] * "()"
                @debug("TTYPE$(ttypestr)")
                ttype = parts[9] * "()" |> Meta.parse |> eval

                currcitable = CitableToken(currpsg, ttype)
                @info("CURRCITALBBE $(currcitable)")
                analysisstring = join([parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]], delimiter)
                currentanalysis = analysis(analysisstring, delimiter)


                @info("Now compare prev and crr citable: $(prevcitable)/$currcitable")
                @info("Equal?  $(prevcitable == currcitable)")
                if isnothing(prevcitable)
                    prevcitable = currcitable
                    @info("SET PREV $(prevcitable)")
                    curranalyses = isnothing(currentanalysis) ? Analysis[] : [currentanalysis]

                elseif urn(currcitable) != urn(prevcitable)
                    push!(tokens, AnalyzedToken(prevcitable, curranalyses))
                    prevcitable = currcitable
                    @info("SET PREV $(prevcitable)")
                    curranalyses = isnothing(currentanalysis) ? Analysis[] : [currentanalysis]
                    
                else
                    if ! isnothing(currentanalysis)
                        push!(curranalyses, currentanalysis)
                    end
                end
                
            end
            
            
            
        end
        @debug("PREVCITABLE: " , prevcitable)
        
    end
    if ! isnothing(prevcitable)
        push!(tokens, AnalyzedToken(prevcitable, curranalyses))
    end
    AnalyzedTokens(tokens)
end

"""Implement iteration for `AnalyzedTokens`.
$(SIGNATURES)
"""
function iterate(analyses::AnalyzedTokens)
    isempty(analyses.analyses) ? nothing : (analyses.analyses[1], 2)
end


"""Implement iteration with state for `AnalyzedTokens`.
$(SIGNATURES)
"""
function iterate(analyses::AnalyzedTokens, state)
    state > length(analyses.analyses) ? nothing : (analyses.analyses[state], state + 1)
end

"""Implement base element type for `AnalyzedTokens`.
$(SIGNATURES)
"""
function eltype(analyses::AnalyzedTokens)
    AnalyzedToken
end

function length(analyses::AnalyzedTokens)
    length(analyses.analyses)
end