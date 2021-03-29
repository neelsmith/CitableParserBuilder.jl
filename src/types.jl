"Supertype of all concrete Stem structures."
abstract type Stem end

"Supertype of all concrete Rule structures."
abstract type Rule end


# These three functions must be implemented to return AbbreviatedUrns
# for a Stem or Rule.

"Function required to get ID value of a Stem implementation."
function id(s::Stem)
    @warn("Unrecognized implementation of Stem")
    nothing
end


"Function required to get lexeme  value of a Stem implementation."
function lexeme(s::Stem)
    @warn("Unrecognized implementation of Stem")
    nothing
end

"Function required to get ID value of a Rule implementation."
function id(r::Rule)
    @warn("Unrecognized implementation of Rule")
    nothing
end