.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.text
.global _start

/* ==== 中断向量表 ==== */
.section .isr_vector, "a"
    .word   _stack_top          /* 栈顶地址 */
    .word   _start + 1          /* 复位处理程序 */
    .word   NMI_Handler + 1 /* NMI */
    .word   HardFault_Handler + 1 /* HardFault */
    .word   MemManage_Handler + 1 /* MemManage */
    .word   BusFault_Handler + 1 /* BusFault */
    .word   UsageFault_Handler + 1 /* UsageFault */
    .word   0                   /* 保留 */
    .word   0                   /* 保留 */
    .word   0                   /* 保留 */
    .word   0                   /* 保留 */
    .word   SVC_Handler + 1 /* SVC */
    .word   DebugMon_Handler + 1 /* DebugMon */
    .word   0                   /* 保留 */
    .word   PendSV_Handler + 1 /* PendSV */
    .word   SysTick_Handler + 1 /* SysTick */
    /* 其他外设中断可以按需添加 */

/* ==== 默认中断处理程序 ==== */
.section .text.Default_Handler
.global Default_Handler
.thumb_func
Default_Handler:
    b Default_Handler   /* 死循环 */   

/* 入口点 */
.section .text
_start:
    /* 1. 设置栈指针（硬编码） */
    ldr sp, =_stack_top   
    
    /* 2. 复制.data段 */
    /* 获取符号地址 */
    ldr r0, =_sdata      
    ldr r1, =_edata       /* RAM中.data段结束地址 */
    ldr r2, =_sidata      /* Flash中.data段初始值地址 */
    
    /* 检查.data段是否为空 */
    cmp r0, r1
    beq .Ldata_done
    
    /* 复制循环 */
.Ldata_loop:
    ldr r3, [r2], #4      /* 从Flash加载4字节 */
    str r3, [r0], #4      /* 存储到RAM */
    cmp r0, r1            /* 检查是否完成 */
    blt .Ldata_loop
    
.Ldata_done:
    
    /* 3. 清零.bss段 */
    ldr r0, =_sbss        /* .bss段起始地址 */
    ldr r1, =_ebss        /* .bss段结束地址 */
    mov r2, #0            /* 清零值 */
    
    /* 检查.bss段是否为空 */
    cmp r0, r1
    beq .Lbss_done
    
    /* 清零循环 */
.Lbss_loop:
    str r2, [r0], #4      /* 存储0并递增地址 */
    cmp r0, r1            /* 检查是否完成 */
    blt .Lbss_loop
    
.Lbss_done:
    
    /* 4. 跳转到main函数 */
    ldr r0, =start
    bx r0
    
    .word 0xffffffff
    /* 5. 如果main返回，进入死循环 */
    b .
