require 'mkmf'

$CFLAGS << ' -O2 -W -Wall -Wno-unused-parameter -Wbad-function-cast -Wuninitialized -g '
$INCFLAGS << " -I$(srcdir)/lmdb"
$VPATH ||= []
$VPATH << "$(srcdir)/lmdb"
$srcs = Dir.glob("#{$srcdir}/{,lmdb/}*.c").map {|n| File.basename(n) }

have_header 'limits.h'
have_header 'string.h'
have_header 'stdlib.h'
have_header 'errno.h'
have_header 'sys/types.h'
have_header 'assert.h'

have_header 'ruby.h'
have_func 'rb_funcall_passing_block'
have_func 'rb_thread_call_without_gvl2'

create_header

create_makefile('isomorfeus_hamster_ext')
