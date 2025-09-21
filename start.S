.text
.global _start

_start:
    ldr r1, =0x50000000
    ldr r0, =0x1
    str r0, [r1]

    ldr r1, =0x50000014
    ldr r0, =0x1
    str r0, [r1]   
    bl delay

    ldr r1, =0x50000014
    ldr r0, =0x0
    str r0, [r1]   

    bl delay

    ldr r1, =0x50000014
    ldr r0, =0x1
    str r0, [r1]   

    bl delay

    ldr r1, =0x50000014
    ldr r0, =0x0
    str r0, [r1]   

    bl delay

    ldr r1, =0x50000014
    ldr r0, =0x1
    str r0, [r1]   

    bl delay

    ldr r1, =0x50000014
    ldr r0, =0x0
    str r0, [r1]   

    bl delay

    ldr r1, =0x50000014
    ldr r0, =0x1
    str r0, [r1]   

    bl delay

    ldr r1, =0x50000014
    ldr r0, =0x0
    str r0, [r1]   

    bl delay
    
halt:
    b halt

delay:
    ldr r2, =10000
    ldr r3, =0x0
delay_loop:
    sub r2, r2, #1
    cmp r2, r3
    bne delay_loop
    mov pc, lr