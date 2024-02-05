const AStr = AnnotatedString{String}

"""
    abstract type Prompt{T} end

The supertype of all specific prompt forms.
Should produce an Answer{T}.

TODO improve docstring
"""
abstract type Prompt{T} end

"""
    struct Behaviour

The particular way a question should behave. This may consist of
- A `default` value (when applicable)
- A `placeholder` value (when applicable)
- A `timeout` applied to the question (in seconds)
- A `callback` function
- Whether the question should "trap" focus (`trapfocus`)
- Whether the question should be able to be aborted (`abotable`)

TODO improve docstring
"""
@kwdef struct Behaviour{D}
    default::D = nothing
    placeholder::Union{AStr, Nothing} = nothing
    timeout::Union{Float64, Nothing} = nothing
    callback::Union{Function, Nothing} = nothing
    trapfocus::Bool = false
    abortable::Bool = true
end

"""
    struct Style

A small selection of basic styling attributes that should be easily represented
across multiple display types.

These attributes are:
- Whether the question should be shown in a `compact` form
- The `border` the question should (or should't) have
- The style of the question's `text`
- Whether the question should be shown in a `modal` format

TODO improve docstring
"""
@kwdef struct Style
    compact::Bool = false
    border::Union{Bool, Symbol, SimpleColor} = false
    text::Union{Face, Nothing} = nothing
    modal::Bool = false
end

"""
    struct Question{P <: Prompt}

A question, ready to be asked, consisting of:
- The prompt (`p`) that the user answers
- The `behaviour` the question should exhibit
- The `style` the question should be shown with

TODO improve docstring
"""
struct Question{P <: Prompt}
    p::P
    behaviour::Behaviour
    style::Style
end

"""
    struct Answer{T}

An answer from a `Question{Prompt{T}}`. Holds a `response` that is either of
type `T`, or the value `nothing`.

The flag `aborted` indicates whether the question was aborted or not.

TODO improve docstring
"""
struct Answer{T}
    response::Union{T, Nothing}
    aborted::Bool
end

abstract type Menu{T} <: Prompt{T} end

"""
    struct Confirmation <: Menu{Bool}

A yes/no confirmation, optionally with custom yes/no strings.

TODO improve docstring
"""
struct Confirmation <: Menu{Bool}
    prompt::AStr
    yes::AStr
    no::AStr
end

struct Picker{N, T} <: Menu{T}
    prompt::AStr
    options::NTuple{N, Pair{T, AStr}}
    shortcuts::Union{Nothing, NTuple{N, Char}}
    vertical::Bool
end

struct List{T} <: Menu{T}
    # Selectable, re-ordable, + delete items, + add items
end

abstract type TextPrompt{T} <: Prompt{T} end

struct Completion{T} <: TextPrompt{T}
    prompt::AStr
    options::Vector{Pair{T, AStr}}
    mustmatch::Bool
    multiple::Bool
    help::Union{AStr, Nothing}
    preview::Union{Tuple{Int, Function}, Nothing}
end

struct ValueInput{T} <: TextPrompt{T}
    prompt::AStr
    validator::Function
end

struct TextInput <: TextPrompt{String}
    lines::Int
    plaseholder::AStr
    maxsize::Union{Int, Nothing}
    sizefn::Function
end

struct TextArea <: TextPrompt{String}
    lines::Int
    plaseholder::AStr
    maxsize::Union{Int, Nothing}
    sizefn::Function
end
