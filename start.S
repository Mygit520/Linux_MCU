.syntax unified
.cpu cortex-m0plus
.fpu softvfp
.thumb

.text
.global _start

.word 0x20000C00  /* 初始栈指针（SP_init值，根据你的RAM大小设置） */
.word _start + 1      /* 复位向量：指向程序入口 */

_start:

/*
    ldr r1, =0x40021034
    ldr r0, =0x7
    str r0, [r1]
    bl delay
*/
    bl led_loop

led_loop:
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

    b led_loop
halt:
    b halt


delay:
    ldr r2, =1000000        /* 减小延时值便于测试 */
delay_loop:
    subs r2, #1           /* Thumb指令 */
    bne delay_loop
    bx lr