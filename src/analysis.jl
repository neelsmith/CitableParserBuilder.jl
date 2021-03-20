"""A citable morphological analysis.

An `Analysis` has five members: a token string value, and four abbreviated
URNs, one each for the lexeme, form, rule and stem.
"""
struct Analysis
    token::AbstractString
    lexeme::LexemeUrn
    form::FormUrn
    rule::RuleUrn
    stem::StemUrn
end