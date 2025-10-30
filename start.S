.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.text
.global _start

.word 0x2000C000      /* 初始栈指针 */
.word _start + 1      /* 复位向量（Thumb状态） */

_start:
    b start
