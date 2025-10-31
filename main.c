// 外设寄存器定义
#include "stdint.h"

#define RCC_APB2ENR (*(volatile unsigned int*)0x40021018)
#define GPIOA_CRH   (*(volatile unsigned int*)0x40010804)
#define GPIOA_ODR   (*(volatile unsigned int*)0x4001080C)
#define USART1_BASE  0x40013800
#define USART1_SR    (*(volatile uint32_t *)(USART1_BASE + 0x00))
#define USART1_DR    (*(volatile uint32_t *)(USART1_BASE + 0x04))
#define USART1_BRR   (*(volatile uint32_t *)(USART1_BASE + 0x08))
#define USART1_CR1   (*(volatile uint32_t *)(USART1_BASE + 0x0C))

// 系统时钟频率 (Hz)
#define SYSTEM_CLOCK 72000000

const char g_a = 'a';
volatile char g_b = 'b';
char g_string[] = "hello world\n";
unsigned int g_c;
// 初始化USART1
void uart_init(uint32_t baudrate) {
    // 1. 使能GPIOA和USART1时钟
    RCC_APB2ENR |= (1 << 2) | (1 << 14);
    
    // 2. 配置PA9 (TX) 为复用推挽输出，最大速度50MHz
    //    PA10 (RX) 为浮空输入
    GPIOA_CRH &= ~(0xFF << 4); // 清除PA9和PA10的配置
    GPIOA_CRH |= (0x0B << 4);  // PA9: 复用推挽输出，最大速度50MHz (CNF=10, MODE=11 -> 1011=0xB)
    GPIOA_CRH |= (0x04 << 8);  // PA10: 浮空输入 (CNF=01, MODE=00 -> 0100=0x4)
    
    // 3. 配置USART1
    // 先禁用USART1，以便配置
    USART1_CR1 &= ~(1 << 13);
    
    // 设置波特率
    USART1_BRR = (4) << 4 | (5 % 16);
    
    // 配置数据格式: 8位数据, 1停止位, 无校验
    USART1_CR1 &= ~(1 << 12); // 8位数据
    USART1_CR1 &= ~(1 << 9);  // 1停止位
    USART1_CR1 &= ~(1 << 10); // 无校验
    
    // 使能USART1，并使能发送
    USART1_CR1 |= (1 << 3);  // 使能发送
    USART1_CR1 |= (1 << 13); // 使能USART1
}

// 发送一个字符
void uart_putc(char c) {
    // 等待发送缓冲区为空
    while (!(USART1_SR & (1 << 7)));
    USART1_DR = c;
}

// 发送字符串
void uart_puts(const char *s) {
    while (*s) {
        uart_putc(*s++);
    }
}


// 简单延时函数
void delay(volatile unsigned int count) {
    while(count--);
}

void start(void)
{
   // 初始化串口，波特率115200
    uart_init(115200);
    
    // 发送欢迎信息
    uart_puts("\r\n\r\nSTM32 Cortex-M3 UART Debug Example\r\n");
    uart_puts("System initialized successfully!\r\n");
    
    uart_putc(g_b);
    g_b = 'x';
    uart_putc(g_b);

    // while(1) {
    //     // 使用printf输出调试信息（需要syscalls.c支持）
        
    //     // 延时约1秒
    //     delay(50000);
    // }
}