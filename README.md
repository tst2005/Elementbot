# Elementbot
An Object-Oriented IRC Bot written in the Lua 5.1 programming language.

Elementbot is an IRC bot written in the Lua programming language using the LuaSocket library for networking. At this moment, Elementbot is NOT copy-friendly, and will need a few minor edits to work properly. This includes the directory to save .tells and LastSeens. 

Info (syntax: .?)
Will return general info about the bot.

Correction (syntax: .red <torep>/<rep> || ALT Syntax: s/<torep>/<rep>)
Will replace 'torep' in the sender's last message and replace it with 'rep'.

Seen (syntax: .seen <name>)
Will return when the specified user was last online (read: when they left.), and what they last said.

Hex (syntax: .hex <number>)
Will return the hexadecimal number of the number given.

Byte (syntax: .byte <text>)
Will return the ASCII byte values of the text and escape-sequences given. {BUG: Escape-sequences don't work properly.}

Evaluate (syntax: .eval <sum>)
Will calculate a given sum. This function supports 'pi' and 'inf' for infinity.
Supported arithmetic operators are: addition (+), substraction (-), division (/), pow (^), modulus (%) and brackets to change the order of operations.

Math (syntax: .math <mode> <numbeR>)
Will perform a mathematical function on a given number.
Supported modes are:
abs - Will return the absolute/non-negative value of a number.
acos/asin - Will return the inverse cosine/sine radians.
atan/atant - Returns the inverse tangent in radians. Supply 2 numbers in this format: s/c.
floor/ceil - Return the integer no greater than or no less than the given value.
cos/sin/tan - Return the cosine, sine and tangent value for a given value in radians.
cosh/sinh/tanh - Return the hyperbolic cosine, hyperbolic sine, and hyperbolic tangent value. {TEMPORARILY REMOVED because of bugs}
deg/rad - Convert from radians to degrees and vice versa.
exp/log - exp returns e (the base of natural logarithms) raised to the power the given value. math.log() returns the inverse of this. exp 1 returns e.
logt - Return the base 10 logarithm of a given number. The number must be positive.
sqrt - Return the square root of a given number. Only non-negative arguments are allowed.

Define (syntax: .def <word>)
Will return the definition for given word. Definitions are fetched from http://dictionary.reference.com

Synonym (syntax: .syn <word>)
Will return a list of synonyms of the given word. Synonyms are fetched from http://thesaurus.com

Tell (syntax: .tell <recipient> <message>)
Will leave a message for the specified recipient which they will receive upon joining the channel.

Random (syntax: .random <number>/<number>)
Will return a number inbetween the two specified.

To-Be-Done in v1.6.0:
+ Add a .ud function for Urban-Dictionary lookup. {IN-PROGRESS}
+ Add a .wiki function for wikipedia lookup. {DONE}
+ Add a .translate/.trans function for translation. {IN-PROGRESS}
+ Add a .rev function to reverse strings. {DONE}
+ Fix .byte to show Escape-sequences correctly. {TO BE DONE}
+ Add .math functions to be directly available from .eval {DONE}
+ Add a .sudo command to execute Lua functions straight from IRC (WILL have some form of security!) {DONE}
