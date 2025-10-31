/*
 * 精简链接脚本（添加中断向量表支持）
 * 保持简洁风格，仅添加必要部分
 */

/* 内存区域定义 */
MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 256K
    RAM (xrw)  : ORIGIN = 0x20000000, LENGTH = 48K
}

/* 入口点 */
ENTRY(_start)

/* 段定义 */
SECTIONS
{
    /* ==== 1. 中断向量表（必须放在最前面）==== */
    .isr_vector : {
        *(.isr_vector)  /* 中断向量表 */
    } > FLASH

    /* ==== 2. 代码段 ==== */
    .text : {
        *(.text)        /* 所有代码 */
    } > FLASH
    
    /* ==== 3. 只读数据段 ==== */
    .rodata : {
        *(.rodata)      /* 只读数据 */
        *(.rodata*)     /* 其他只读数据 */
    } > FLASH
    
    /* ==== 4. 初始化数据段 ==== */
    .data : {
        _sdata = .;     /* RAM中.data起始地址 */
        *(.data)        /* 初始化数据 */
        *(.data*)       /* 其他初始化数据 */
        _edata = .;     /* RAM中.data结束地址 */
    } > RAM AT > FLASH   /* 运行时在RAM，存储在FLASH */
    
    /* 获取.data段在Flash中的加载地址 */
    _sidata = LOADADDR(.data);
    
    /* ==== 5. 未初始化数据段 ==== */
    .bss : {
        _sbss = .;      /* .bss段起始地址 */
        *(.bss)         /* 未初始化数据 */
        *(.bss*)        /* 其他未初始化数据 */
        *(COMMON)       /* COMMON块 */
        _ebss = .;      /* .bss段结束地址 */
    } > RAM
    
    /* ==== 6. 栈顶地址 ==== */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}