const AStr = AnnotatedString{String}

abstract type Prompt end

@kwdef struct Behaviour{D}
    default::D = nothing
    placeholder::Union{AStr, Nothing} = nothing
    timeout::Union{Float64, Nothing} = nothing
    callback::Union{Function, Nothing} = nothing
    trapfocus::Bool = false
    abortable::Bool = true
end

@kwdef struct Style
    compact::Bool = false
    border::Union{Bool, Symbol, SimpleColor} = false
    text::Union{Face, Nothing} = nothing
    modal::Bool = false
end

struct Question{P <: Prompt}
    p::P
    behaviour::Behaviour
    style::Style
end

struct Answer{T}
    response::T
    aborted::Bool
end

abstract type Menu <: Prompt end

struct Confirmation <: Menu
    prompt::AStr
    default::Union{Nothing, Bool}
    yes::AStr
    no::AStr
end

struct Picker{N, T} <: Menu
    prompt::AStr
    options::NTuple{N, Pair{T, AStr}}
    default::Union{Nothing, T}
    shortcuts::Union{Nothing, NTuple{N, Char}}
    vertical::Bool
end

struct List <: Menu
    # Selectable, re-ordable, + delete items, + add items
end

abstract type TextPrompt <: Prompt end

struct Completion{T} <: TextPrompt
    prompt::AStr
    options::Vector{Pair{T, AStr}}
    mustmatch::Bool
    multiple::Bool
    placeholder::AStr
    default::Union{T, Nothing}
    help::Union{AStr, Nothing}
    preview::Union{Tuple{Int, Function}, Nothing}
end

struct ValueInput <: TextPrompt
    prompt::AStr
    validator::Function
end

struct TextInput <: TextPrompt
    lines::Int
    default::AStr
    plaseholder::AStr
    maxsize::Union{Int, Nothing}
    sizefn::Function
end

struct TextArea <: TextPrompt
    lines::Int
    default::AStr
    plaseholder::AStr
    maxsize::Union{Int, Nothing}
    sizefn::Function
end
