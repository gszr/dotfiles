#!/usr/bin/env python2

# Very useful script to list installed fonts that support a given glyph; taken from 
# http://unix.stackexchange.com/questions/162305/find-the-best-font-for-rendering-a-codepoint

import re, sys
import fontconfig

if len(sys.argv) < 1:
    print('''Usage: ''' + sys.argv[0] + '''CHARS [REGEX]
        Print the names of available fonts containing the code point(s) CHARS.
        If CHARS contains multiple characters, they must all be present.
        Alternatively you can use U+xxxx to search for a single character with
        code point xxxx (hexadecimal digits).
        If REGEX is specified, the font name must match this regular expression.''')
    sys.exit(0)

characters = sys.argv[1]
if characters.startswith('U+'):
    characters = unichr(int(characters[2:], 16))
else:
    characters = characters.decode(sys.stdout.encoding)
regexp = re.compile(sys.argv[2] if len(sys.argv) > 2 else '')
font_names = fontconfig.query()
found = False
for name in font_names:
    if not re.search(regexp, name): continue
    font = fontconfig.FcFont(name)
    if all(font.has_char(c) for c in characters):
        print(name)
        found = True
sys.exit(0 if found else 1)
