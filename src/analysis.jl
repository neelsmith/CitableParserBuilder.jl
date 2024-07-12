"""Citable analysis of a string value.

An `Analysis` has seven members: string values for the orthographic token and the morphological token, four abbreviated URNs, one each for the lexeme, form, rule and stem, and a sequence ID for the morphological token.
"""
struct Analysis
    token::AbstractString
    lexeme::LexemeUrn
    form::FormUrn
    stem::StemUrn
    rule::RuleUrn
    mtoken::AbstractString
    mtokenid::AbstractString
end


"""Override `Base.==` for `Analysis`.

$(SIGNATURES)
"""
function ==(a1::Analysis, a2::Analysis)
    a1.token == a2.token && 
    a1.lexeme == a2.lexeme &&
    a1.form == a2.form &&
    a1.stem == a2.stem && 
    a1.rule == a2.rule &&
    a1.mtoken == a2.mtoken &&
    a1.mtokenid == a2.mtokenid 
end


# Make this a CEX serializable type
"""Define CexTrait for Analysis type.
"""
struct AnalysisCex <: CexTrait end
function cextrait(::Type{Analysis})
    AnalysisCex()
end

"""Implementation of cex function for an Analysis.
$(SIGNATURES)
"""
function cex(a::Analysis; delim = "|", registry = nothing)
    
    if isnothing(registry)
        join([
            a.token,
            a.lexeme,
            a.form,
            a.stem,
            a.rule,
            a.mtoken,
            a.mtokenid
            ], delim)
        
    else
        @debug("Serializing while expanding URNs. Token $(a.token)")
        @debug("Serialize token $(a.token)")
        @debug("Expand lexeme: $(expand(a.lexeme, registry))")
        @debug("Expand form $(a.form) to...") 
        @debug("   -> $(expand(a.form, registry))")
        @debug("Expand stem: $(expand(a.stem, registry))")
        @debug("Expand rule: $(expand(a.rule, registry))")
        @debug("\n\n")
        try 
            join([ a.token,
            expand(a.lexeme, registry),
            expand(a.form, registry),
            expand(a.stem, registry),
            expand(a.rule, registry),
            a.mtoken, a.mtokenid
            ], delim)
        catch e
            @warn("Failed to serialize analysis for token $(a.token)")
            ""
        end
    end
end

"""Implementation of fromcex function for an Analysis.
$(SIGNATURES)
"""
function fromcex(traitvalue::AnalysisCex, cexsrc::AbstractString, T;      
    delimiter = "|", configuration = nothing, strict = true)
    parts = split(cexsrc, delimiter)
    @debug("delimited for single analysis: $(s) has $(length(parts)) parts")
    if length(parts) < 7
        DomainError(
            "Canont construct Analysis: two few parts in $(parts)"
        )
    else
            
        tokentext = parts[1]
        mtoken = parts[6]
        mtokenid = parts[7]
        
        if no_id(parts[2:5])
            nothing

        else
            lexu = startswith(parts[2], "urn:") ? Cite2Urn(parts[2]) |> abbreviate |> LexemeUrn : LexemeUrn(parts[2])
            formu = startswith(parts[3], "urn:") ? Cite2Urn(parts[3]) |> abbreviate |> FormUrn : FormUrn(parts[3])
            stemu = startswith(parts[4], "urn:") ? Cite2Urn(parts[4]) |> abbreviate |> StemUrn : StemUrn(parts[4])
            ruleu = startswith(parts[5], "urn:") ? Cite2Urn(parts[5]) |> abbreviate |> RuleUrn : RuleUrn(parts[5])

            Analysis(
                tokentext,
                lexu,
                formu,
                stemu,
                ruleu,
                mtoken,
                mtokenid
            )
        end
    end
    
end






"""Identify morphological token identified in analysis.
$(SIGNATURES)
"""
function mtokenid(a::Analysis)
    a.mtokenid
end


"""Identify morphologocal token identified in analysis.
$(SIGNATURES)
"""
function mtoken(a::Analysis)
    a.mtoken
end


"""Identify orthographic token analyzed.
$(SIGNATURES)
"""
function token(a::Analysis)
    a.token
end


"""Identify lexeme identifed in analysis.
$(SIGNATURES)
"""
function lexemeurn(a::Analysis)
    a.lexeme
end

"""Identify morphlogical form identifed in analysis.
$(SIGNATURES)
"""
function formurn(a::Analysis)
    a.form
end

"""Identify lexical stem identifed in analysis.
$(SIGNATURES)
"""
function stemurn(a::Analysis)
    a.stem
end

"""Identify inflectional rule identifed in analysis.
$(SIGNATURES)
"""
function ruleurn(a::Analysis)
    a.rule
end


#=
"""Serialize a Vector of `Analysis` objects as delimited text.

$(SIGNATURES)
"""
function delimited(v::AbstractVector{Analysis}; delim = "|", registry = nothing)
    lines = []
    for analysis in v
        push!(lines, delimited(analysis; delim = delim, registry = registry))
    end

    join(lines, "\n")
end

=#


"""Compose a CEX `relationset` block for a set of analyses.

$(SIGNATURES)
"""
function relationsblock(urn::Cite2Urn, label::AbstractString, v::AbstractVector{Analysis}, delim = "|"; registry = nothing)
    headerlines = [
        "#!citerelationset",
        join(["urn", urn],  delim),
        join(["label", label], delim),
        join(["token", "lexeme", "form", "stem", "rule","mtoken","mtokenid"], delim)
    ]


    lines = cex.(v; delim = delim, registry = registry)

    join(headerlines, "\n") * join(lines,"\n")
end


"""True if any element in stringlist is empty."""
function no_id(stringlist)
    isempty(stringlist[1]) || isempty(stringlist[2]) ||
    isempty(stringlist[3]) || isempty(stringlist[4])  
end


#=
"""Parse delimited-text representaiton into an `Analysis`.
If delimited-text form uses full Cite2Urns, these are abbreviated.

$(SIGNATURES)
"""
function analysis(s, delim = "|")::Union{Analysis,Nothing}
    parts = split(s, delim)
    @debug("delimited for single analysis: $(s) has $(length(parts)) parts")
    if length(parts) < 6
        DomainError(
            "Canont construct Analysis: two few parts in $(parts)"
        )
    else
            
        tokentext = parts[1]
        mtoken = parts[6]
        
        if no_id(parts[2:5])
            nothing

        else
            lexu = startswith(parts[2], "urn:") ? Cite2Urn(parts[2]) |> abbreviate |> LexemeUrn : LexemeUrn(parts[2])
            formu = startswith(parts[3], "urn:") ? Cite2Urn(parts[3]) |> abbreviate |> FormUrn : FormUrn(parts[3])
            stemu = startswith(parts[4], "urn:") ? Cite2Urn(parts[4]) |> abbreviate |> StemUrn : StemUrn(parts[4])
            ruleu = startswith(parts[5], "urn:") ? Cite2Urn(parts[5]) |> abbreviate |> RuleUrn : RuleUrn(parts[5])

            Analysis(
                tokentext,
                lexu,
                formu,
                stemu,
                ruleu,
                mtoken
            )
        end
    end
end


=#
