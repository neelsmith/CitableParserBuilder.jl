"""A collection of analyzed tokens."""
struct AnalyzedTokenCollection
    analyses::Vector{AnalyzedToken}
end

"""Override Base.show for `AnalyzedTokenCollection`.
$(SIGNATURES)
"""
function show(io::IO, atc::AnalyzedTokenCollection)
    length(atc.analyses) == 1 ? print(io, "Collection of  1 analysis") : print(io, "Collection of ", length(atc.analyses), " analyzed tokens.")
end

"""Override `Base.==` for `AnalyzedTokenCollection`.

$(SIGNATURES)
"""
function ==(at1::AnalyzedTokenCollection, at2::AnalyzedTokenCollection)
    at1.analyses == at2.analyses
end



"Value for CitableTrait."
struct CitableAnalyses <: CitableCollectionTrait end

"""Define`CitableTrait` value for `AnalyzedTokenCollection`.
$(SIGNATURES)
"""
function citablecollectiontrait(::Type{AnalyzedTokenCollection})
    CitableAnalyses()
end

"""Typeof URN identifying analyses in an an `AnalyzedTokenCollection` collection.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function urntype(analyses::AnalyzedTokenCollection)
    CtsUrn
end


"""Label for `analyses`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function label(atc::AnalyzedTokenCollection)
    string(atc)
end


"Value for CexTrait"
struct AnalysesCex <: CexTrait end

"""Define`CexTrait` value for `AnalyzedTokenCollection`.
$(SIGNATURES)
"""
function cextrait(::Type{AnalyzedTokenCollection})
    AnalysesCex()
end


# Add support for registry...
"""Format an `AnalyzedTokenCollection` collection as a delimited-text string.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function cex(atc::AnalyzedTokenCollection; delimiter = "|", registry = nothing)
    header = "#!ctsdata\n"
    if ! isnothing(registry)
        @warn("Registry support for expanding URNs not yet implementpreed.")
    end
    strings = map(atoken -> cex(atoken, delimiter=delimiter), atc)
    header * join(strings, "\n")
end


"""Parse a delimited-text string into an `AnalyzedTokenCollection` collection.
$(SIGNATURES)
"""
function fromcex(trait::AnalysesCex, s::AbstractString,  ::Type{AnalyzedTokenCollection}; delimiter = "|", configuration = nothing, strict = true)
    @debug("HEY! PARSE Plural AnalyzedTokenCollection from cex")


    rawlines = split(s, "\n")[2:end]
    datalines = filter(ln -> ! isempty(ln), rawlines)

    debugdisp = join(datalines,"\n\n")
    @debug("Datalines:\n $(debugdisp)")

    prevcitable = nothing
    curranalyses = Analysis[]
    tokens = AnalyzedToken[]
    @debug("$(length(datalines)) data lines")
        
    for ln in datalines
        parts = split(ln, delimiter)

        if length(parts) < 10
            msg = "Error reading AnalyzedTokenCollection from cex. Too few parts ($(length(parts))) in $(parts)"
            @warn(msg)
            DomainError(msg)
        else
            @debug("LINEL: ", ln)

            @debug("Yields $(length(parts)) parts")
   
            currpsg = CitablePassage(CtsUrn(parts[1]), parts[2])
            @debug("Looking at currpsg $(currpsg)")
            @debug("type empty? $(isempty(parts[9]))")
            if isempty(parts[10])
                @warn("Couldn't form a token type for $(currpsg)")
            else
                ttypestr = parts[10] * "()"
                @debug("TTYPE: $(ttypestr)") 
                ttype = parts[10] * "()" |> Meta.parse |> eval

                currcitable = CitableToken(currpsg, ttype)
                @debug("CURRCITALBBE $(currcitable)")
                analysisstring = join([parts[3], parts[4], parts[5], parts[6], parts[7], parts[8], parts[9]], delimiter)
                @debug("ASTRING: $(analysisstring)")
                
                currentanalysis = fromcex(analysisstring, Analysis; delimiter = delimiter)


                @debug("Now compare prev and crr citable: $(prevcitable)/$currcitable")
                @debug("Equal?  $(prevcitable == currcitable)")
                if isnothing(prevcitable)
                    prevcitable = currcitable
                    @debug("SET PREV $(prevcitable)")
                    curranalyses = isnothing(currentanalysis) ? Analysis[] : [currentanalysis]

                elseif urn(currcitable) != urn(prevcitable)
                    @debug("MAke something happen with curranalyses")
                    push!(tokens, AnalyzedToken(prevcitable, curranalyses))
                    prevcitable = currcitable
                    @debug("SET PREV $(prevcitable)")
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
    AnalyzedTokenCollection(tokens)

end

"""Implement iteration for `AnalyzedTokenCollection`.
$(SIGNATURES)
"""
function iterate(atc::AnalyzedTokenCollection)
    isempty(atc.analyses) ? nothing : (atc.analyses[1], 2)
end


"""Implement iteration with state for `AnalyzedTokenCollection`.
$(SIGNATURES)
"""
function iterate(atc::AnalyzedTokenCollection, state)
    state > length(atc.analyses) ? nothing : (atc.analyses[state], state + 1)
end

"""Implement base element type for `AnalyzedTokenCollection`.
$(SIGNATURES)
"""
function eltype(atc::AnalyzedTokenCollection)
    AnalyzedToken
end

function length(atc::AnalyzedTokenCollection)
    length(atc.analyses)
end