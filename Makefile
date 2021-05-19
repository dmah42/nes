# Makefile ("make") configuration for iNES ROM files.
#
# Based on first_nes by Greg M. Krsak <greg.krsak@gmail.com>, 2018
#
# Based on the NintendoAge "Nerdy Nights" tutorials, by bunnyboy:
#   http://nintendoage.com/forum/messageview.cfm?catid=22&threadid=7155
# Based on "Nintendo Entertainment System Architecture", by Marat Fayzullin:
#   http://fms.komkon.org/EMUL8/NES.html
# Based on "Nintendo Entertainment System Documentation", by Jeremy Chadwick:
#   https://emu-docs.org/NES/nestech.txt
#
# Processor: 8-bit, Ricoh RP2A03 (6502), 1.789773 MHz (NTSC)
# Assembler: ca65 (cc65 binutils)
#
# Tested with:
#  make
#  nestopia nes.nes
#
# Tested on:
#  - Linux with Nestopia UE 1.47
#
# For more information about NES programming in general, try these references:
# https://en.wikibooks.org/wiki/NES_Programming
#
# For more information on the ca65 assembler, try these references:
# https://github.com/cc65/cc65
# http://cc65.github.io/doc/ca65.html

# Reference: https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

ASSEMBLER = ca65
ASMFLAGS = --cpu 6502

LINKER = ld65
LINKFLAGS = --config config/ines.cfg

# Simply typing "make" will invoke all suggested targets to build an
# emulator-ready ROM
default: universal-pre-clean assemble link emulator emulator-post-clean

# To start over from scratch, type "make clean"
clean: universal-pre-clean emulator-post-clean
	
# This target entry assembles the .s assembly language files into .o object
# files
assemble: nes.s
	$(ASSEMBLER) $(ASMFLAGS) nes.s

# This target entry links the .o object files into .bin ROM files
link: nes.o
	$(LINKER) nes.o $(LINKFLAGS)

# This target entry concatenates the .bin ROM files into a .nes iNES
# emulator-compatible ROM file
emulator: bin/nes_hdr.bin bin/nes_prg.bin bin/nes_chr.bin
	cat bin/nes_hdr.bin bin/nes_prg.bin bin/nes_chr.bin > nes.nes

# TODO: Implement this target for making physical NES cartridges
cart:
	echo "'cart' target is not currently implemented"

# This target entry removes any build files (.bin, .nes) associated with an NES
# ROM 
universal-pre-clean:
	$(RM) bin/*.bin && $(RM) nes.nes && $(RM) nes.o

# This target entry removes the files (.o, .out) not required by emulators
emulator-post-clean:
	$(RM) nes.o && $(RM) a.out
