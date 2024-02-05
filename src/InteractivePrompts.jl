module InteractivePrompts

using Base: AnnotatedString, annotations
using StyledStrings: var"@styled_str", Face, SimpleColor

export ask, Question

public render, clear, abort, focus, unfocus

include("types.jl")
include("api.jl")

end
