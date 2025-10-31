void uart_puts(const char *s);
void NMI_Handler(void)
{
    uart_puts("here is NMI_Handler");
    while(1)
    {

    }
}

void HardFault_Handler(void)
{
    uart_puts("here is HardFault_Handler");
    while(1)
    {
        
    }    
}

void MemManage_Handler(void)
{
    uart_puts("here is MemManage_Handler");
    while(1)
    {
        
    }    
}

void BusFault_Handler(void)
{
    uart_puts("here is BusFault_Handler");
    while(1)
    {
        
    }
}

void UsageFault_Handler(void)
{
    uart_puts("here is UsageFault_Handler");
    while(1)
    {
        
    }
}

void SVC_Handler(void)
{
    uart_puts("here is SVC_Handler");
    while(1)
    {
        
    }
}

void DebugMon_Handler(void)
{
    uart_puts("here is DebugMon_Handler");
    while(1)
    {
        
    }
}

void PendSV_Handler(void)
{
    uart_puts("here is PendSV_Handler");
    while(1)
    {
        
    }
}

void SysTick_Handler(void)
{
    uart_puts("here is SysTick_Handler");
    while(1)
    {
        
    }
}