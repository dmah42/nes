; This Interrupt Service Routine is called when the NES is reset, including
; when it is turned on.
;
; Based on first_nes by Greg M. Krsak <greg.krsak@gmail.com>, 2018
;
; Based on the NintendoAge "Nerdy Nights" tutorials, by bunnyboy:
;   http://nintendoage.com/forum/messageview.cfm?catid=22&threadid=7155
; Based on "Nintendo Entertainment System Architecture", by Marat Fayzullin:
;   http://fms.komkon.org/EMUL8/NES.html
; Based on "Nintendo Entertainment System Documentation", by Jeremy Chadwick:
;   https://emu-docs.org/NES/nestech.txt
;
; Processor: 8-bit, Ricoh RP2A03 (6502), 1.789773 MHz (NTSC)
; Assembler: ca65 (cc65 binutils)
;
; Tested with:
;  make
;  nestopia nes.nes
;
; Tested on:
;  - Linux with Nestopia UE 1.47
;
; For more information about NES programming in general, try these references:
; https://en.wikibooks.org/wiki/NES_Programming
;
; For more information on the ca65 assembler, try these references:
; https://github.com/cc65/cc65
; http://cc65.github.io/doc/ca65.html

.PROC ISR_PowerOn_Reset
  ; ---------------------------------------------------------------------------
  ; Initialization sequence for the NES. These tasks should generally be
  ; performed every time the system is reset.
  ; ---------------------------------------------------------------------------
  
    cld                         ; Disable unsupported BCD mode (in case someone
                                ; is using a 6502 debugger)
    ldx     #$ff                ; 
    txs                         ; Set the value of the stack pointer to 255
    jsr     DisableVideoOutput
    jsr     DisableAudioOutput
    jsr     ClearVBlankFlag     ; Clear the vblank flag in case the NES was
                                ; reset during vblank

  ; ---------------------------------------------------------------------------
  ; Note: When the system is first turned on or reset, the PPU may not be in a
  ; usable state right away. You should wait at least 30,000 (thirty thousand)
  ; CPU cycles for the PPU to initialize, which may be accomplished by waiting
  ; for two vblank intervals.
  ; ---------------------------------------------------------------------------

    jsr     WaitForVBlank
    jmp     __ClearCPUMemory

  __CPUMemoryCleared:
    jsr     WaitForVBlank

  ; ---------------------
  ; Now the PPU is ready.
  ; ---------------------

    jsr     LoadPaletteData
    jsr     LoadSpriteData                                
    jsr     EnableVideoOutput

  ; -------------
  ; ENDLESS LOOP.
  ; -------------

    jsr     EndlessLoop
    rti                             ; This should never be called

.ENDPROC 

; End of lib/isr/poweron_reset.s
