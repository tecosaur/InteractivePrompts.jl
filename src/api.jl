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

function ask(d::AbstractDisplay, q::Question)
    @nospecialize
    try
        render(d, q)
    catch err
        if err isa InterruptException
            abort(d, q)
        else
            rethrow()
        end
    end
end

"""
    render(d::AbstractDisplay, q::Question)

TODO
"""
function render end

"""
    clear(d::AbstractDisplay, q::Question)

TODO
"""
function clear end

"""
    abort(d::AbstractDisplay, [q::Question])

TODO
"""
function abort end

abort(d::AbstractDisplay, ::Question) = @nospecialize abort(d)

"""
    focus(q::Question)

TODO
"""
function focus end

"""
    unfocus(q::Question)

TODO
"""
function unfocus end
