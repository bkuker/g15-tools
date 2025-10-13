del julia.ptr
del julia.pti
npm run asm -- --bootable --ptr julia.asm > julia.ptr && python C:\Users\bkuker\Desktop\BendixG15\BendixG15\emulators\python\g15d\g15d.py -b -v verbose.log julia.txt