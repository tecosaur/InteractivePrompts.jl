import Base.Multimedia: AbstractDisplay, displays

"""
    ask([disp::AbstractDisplay], question::Question)

Interactively ask `question`, optionally specifying a particular `disp`lay to
use (automatically picked from the display stack if unspecified).
"""
function ask(@nospecialize q::Question)
    disp = findlast(d -> applicable(render, d, q), displays)
    isnothing(disp) && throw(MethodError(render, (q,)))
    ask(disp, q)
end

function ask(d::AbstractDisplay, q::Question{T}) where {T}
    @nospecialize
    local state
    try
        state = render(d, q)
        state = focus(d, q, state)
    catch err
        if err isa InterruptException && isdefined(state)
            state = abort(d, q, state)
        else
            rethrow()
        end
    finally
        state = unfocus(d, q, state)
    end
    answer(d, q, state)::Answer{T}
end

"""
    render(d::AbstractDisplay, q::Question)

Render the question `q` to the display `d`.

Produces a representaton of the question's state.

TODO improve docstring
"""
function render end

"""
    clear(d::AbstractDisplay, q::Question, state)

Clear the previous rendering of `q` in the display `d`.

TODO improve docstring
"""
function clear end

"""
    abort(d::AbstractDisplay, [q::Question, state::Any])

Abort the attempt to answer `q` in the display `d`.

Methods accepting `q` and `state` arguments must return the new state.

TODO improve docstring
"""
function abort end

abort(d::AbstractDisplay, q::Question, state) = (@nospecialize abort(d); state)

"""
    focus(d::AbstractDisplay, [q::Question, state::Any])

Give focus to the question `q` in display `d`. Exactly one question should have
focus at any one time.

Methods accepting `q` and `state` arguments must return the new state.

TODO improve docstring
"""
function focus end

focus(d::AbstractDisplay, q::Question, state) = (@nospecialize focus(d); state)

"""
    unfocus(d::AbstractDisplay, [q::Question, state::Any])

Remove focus from the question `q` in display `d`. Exactly one question should
have focus at any one time.

Methods accepting `q` and `state` arguments must return the new state.

TODO improve docstring
"""
function unfocus end

unfocus(d::AbstractDisplay, q::Question, state) = (@nospecialize unfocus(d); state)

"""
    answer(d::AbstractDisplay, q::Question, state)

Extract the answer to `q` (show in display `d`) from `state`.

TODO improve docstring
"""
function answer end
