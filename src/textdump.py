#!/usr/bin/env python
#
# textdump.py: extracts .text binary from ELF file
#
# Usage: readelf -x .text a.out | python textdump.py 
#
# Dis-assemble: mips-gcc/bin/mips-objdump -d a.out

import sys
import re

p = re.compile(' [0-9a-f]{8,8}')
for line in sys.stdin:
    for hex in p.findall(line):
        print hex.strip()
