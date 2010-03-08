###############################################################################
#
#                        "FastLZ" compression library
#
###############################################################################

CFILES = fastlzlib.c

all:
	make gcc

clean:
	rm -f *.o *.obj *.so* *.dll *.exe *.pdb *.exp *.lib

tar:
	rm -f fastlzlib.tgz
	tar cvfz fastlzlib.tgz fastlzlib.txt fastlzlib.c fastlzlib.h fastlzlib-zlib.h fastlzcat.c Makefile LICENSE

gcc:
	gcc -c -fPIC -O3 -g \
		-W -Wall -Wextra -Werror \
		-D_REENTRANT \
		fastlzlib.c -o fastlz.o
	gcc -shared -fPIC -O3 -Wl,-O1 -Wl,--no-undefined \
		-rdynamic -shared -Wl,-soname=libfastlz.so \
		fastlz.o -o libfastlz.so

	gcc -c -fPIC -O3 -g \
		-W -Wall -Wextra -Werror \
		-D_REENTRANT \
		fastlzcat.c -o fastlzcat.o
	gcc -fPIC -O3 -Wl,-O1 \
		-lfastlz -L. \
		fastlzcat.o -o fastlzcat

# to be started in a visual studio command prompt
visualcpp:
	cl.exe -nologo -c -MD -O2 -W3 \
		-D_WINDOWS -D_WIN32_WINNT=0x0400 -DWINVER=0x0400 \
		-D_CRT_SECURE_NO_WARNINGS \
		-DFASTLZ_DLL \
		-Fofastlz.obj \
		$(CFILES)
	link.exe -nologo -dll \
		-out:fastlz.dll \
		-implib:fastlz.lib \
		-DEBUG -PDB:fastlz.pdb \
		fastlz.obj
	mt.exe -nologo -manifest fastlz.dll.manifest \
		"-outputresource:fastlz.dll;2"
	cl.exe -nologo -MD -O2 -W3 \
		-D_WINDOWS -D_WIN32_WINNT=0x0400 -DWINVER=0x0400 \
		-D_CRT_SECURE_NO_WARNINGS \
		-Fefastlzcat.exe \
		fastlz.lib \
		fastlzcat.c -link
	mt.exe -nologo -manifest fastlzcat.exe.manifest \
		"-outputresource:fastlzcat.exe;1"