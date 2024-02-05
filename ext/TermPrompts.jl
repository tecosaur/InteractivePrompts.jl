module TermPrompts

using REPL

using InteractivePrompts: Question, Confirmation
import Base.display

using StyledStrings

const REPLDisplay = REPL.REPLDisplay{REPL.LineEditREPL}

function render(::REPLDisplay, confirm::Question{Confirmation})
    print("Hey there: ")
    readline()
end

end
