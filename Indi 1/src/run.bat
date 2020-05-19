set filename=conv
nasm -f win32 %filename%.asm -o %filename%.obj
golink /entry:Start /console kernel32.dll user32.dll %filename%.obj
%filename%.exe