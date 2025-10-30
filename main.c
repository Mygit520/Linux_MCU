// 外设寄存器定义
#define RCC_APB2ENR (*(volatile unsigned int*)0x40021018)
#define GPIOA_CRH   (*(volatile unsigned int*)0x40010804)
#define GPIOA_ODR   (*(volatile unsigned int*)0x4001080C)

// 简单延时函数
void delay(volatile unsigned int count) {
    while(count--);
}

void start(void)
{
    // 1. 使能GPIOA时钟
    RCC_APB2ENR |= 0x04;
    
    // 2. 配置PA8为输出
    GPIOA_CRH = (GPIOA_CRH & ~0xF) | 0x2;  // 推挽输出，2MHz
    
    // 3. LED闪烁循环
    while(1) {
        GPIOA_ODR &= ~(1<<8);   // 亮灯
        delay(50000);
        GPIOA_ODR |= (1<<8);    // 灭灯
        delay(50000);
    }
}