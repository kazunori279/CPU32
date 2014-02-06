#!/usr/bin/env python
#
# c2mif.py: compile .c file and generate .mif file
# (make sure you have mips-gcc/bin directory added to your PATH)
#
# Usage: > python c2mif.py foo.c 

import commands
import sys
import re

# get .c file name
if len(sys.argv) < 2:
    sys.exit('Can not find .c file.') 
c_file_path = sys.argv[1]
m = re.compile('(\w+)\.c').match(c_file_path)
if m == None:
    sys.exit('Not a proper .c file')
file_name = m.group(1)

# execute gcc
s_file = '/tmp/' + file_name + '.s'
r = commands.getstatusoutput('mips-gcc -o ' + s_file + ' -S ' + c_file_path)
if r[0] != 0:
    sys.exit(r[1]) 

# remove macros
s_file_nomacro = '/tmp/' + file_name + '.no_macro'
p = re.compile('\s+\..*')
f = open(s_file_nomacro,'w')
for line in open(s_file, 'r'):
    if p.match(line) == None:
        f.write(line)
f.close()

# assemble
o_file = '/tmp/' + file_name + '.o'
r = commands.getstatusoutput('mips-as -o ' + o_file + ' -O0 -mips1 ' + s_file_nomacro)
if r[0] != 0:
    sys.exit(r[1])

# reading text dump
t_file = '/tmp/' + file_name + '.textdump'
r = commands.getstatusoutput('readelf -x .text ' + o_file + ' > ' + t_file)
if r[0] != 0:
    sys.exit(r[1])

# extract hex
h_file = '/tmp/' + file_name + '.hex'
p = re.compile(' [0-9a-f]{8,8}')
f = open(h_file, 'w')
l = 0
for line in open(t_file, 'r'):
    for hex in p.findall(line):
        f.write(hex.strip())
        f.write('\n')
        l += 1
f.close()

# convert to mif
m_file = file_name + '.mif'
f = open(m_file, 'w')
f.write('-- \n')
f.write('WIDTH = 32;\n')
f.write('DEPTH = ' + str(l) + ';\n')
f.write('ADDRESS_RADIX = DEC;\n')
f.write('DATA_RADIX = HEX;\n')
f.write('CONTENT BEGIN\n\n')
i = 0
for line in open(h_file, 'r'):
    f.write(str(i) + ':' + line.replace('\n', ';\n'))
    i += 1
f.write('\nEND;\n')
f.close()

# done
print m_file + ' created.' 
