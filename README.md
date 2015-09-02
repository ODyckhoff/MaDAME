MaDAME
======

MaDAME - a Musical Data And Melody Engine

The idea is to create a system that will provide a glossary of musical terms, tutorials for construction of musical sequences, and most importantly, tools allowing the user to input a set of notes/chords and return them a set of calculated musical data, e.g. chord sequences which fit the given data, scales and arpeggios related to that chord/key signature, and potentially (if time allows) generating melodies that fit the "theme" of the user's input (i.e. generating melodies that make sense, and that don't make it sound like a completely different piece of music embedded in the original).

Ideally, this should be a musical aid, and not a full composition engine, so the input and output are intended to be only short musical patterns, rather than entire symphonies.

For me, the main challenge (and fun) will exist in deriving these calculations necessary to map appropriate notes and chords to the given input, and in generating short melodies. As a musician and computer scientist, the idea of working on a project such as this is rather exciting.

My current thoughts are to implement the software as an API, and plug in a web front end to display the data. I'll have to do some research on digital formats of sheet music to see if there's a set of standards, and if so, I shall endeavour to provide data which fits these standards so that others in future my also use the API.

KeyFinder
=========

The Key finder takes a series of numbers as input, where each number represents a note in a scale. 0 = A, 1 = A#/Bb, 2 = B, etc. through to 11 = G#/Ab. You may invoke it thusly:

    perl MaDAME.pm MusDat KeyFinder 0 2 4 5 7 9 11
