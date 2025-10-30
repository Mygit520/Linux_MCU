# 定义工具链
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump

# 目标文件
TARGET = led_on

# 源文件
AS_SRC = start.S
C_SRC = main.c

# 编译选项
CFLAGS = -mcpu=cortex-m3 -mthumb -Wall -O2
LDFLAGS = -Ttext 0x08000000 -nostdlib

# 目标
all: $(TARGET).bin $(TARGET).dis

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -S $< $@

$(TARGET).dis: $(TARGET).elf
	$(OBJDUMP) -D $< > $@

$(TARGET).elf: start.o main.o
	$(LD) $(LDFLAGS) $^ -o $@

start.o: start.S
	$(CC) $(CFLAGS) -c $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o *.elf *.bin *.dis