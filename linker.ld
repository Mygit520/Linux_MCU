/*
 * 最简链接脚本
 * 仅包含.data重定位所需部分
 */

/* 内存区域定义 */
MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 256K
    RAM (xrw)  : ORIGIN = 0x20000000, LENGTH = 48K
}

/* 段定义 */
SECTIONS
{
    /* 代码段 */
    .text : {
        *(.text)        /* 所有代码 */
    } > FLASH
    
    /* 只读数据段 */
    .rodata : {
        *(.rodata)      /* 只读数据 */
        *(.rodata*)     /* 其他只读数据 */
    } > FLASH
    
    /* 初始化数据段 */
    .data : {
        _sdata = .;     /* RAM中.data起始地址 */
        *(.data)        /* 初始化数据 */
        *(.data*)       /* 其他初始化数据 */
        _edata = .;     /* RAM中.data结束地址 */
    } > RAM AT > FLASH   /* 运行时在RAM，存储在FLASH */
    
    /* 获取.data段在Flash中的加载地址 */
    _sidata = LOADADDR(.data);
    
    /* 未初始化数据段 */
    .bss : {
        _sbss = .;      /* .bss段起始地址 */
        *(.bss)         /* 未初始化数据 */
        *(.bss*)        /* 其他未初始化数据 */
        *(COMMON)       /* COMMON块 */
        _ebss = .;      /* .bss段结束地址 */
    } > RAM
    
    /* 栈顶地址（硬编码，与start.S匹配） */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}