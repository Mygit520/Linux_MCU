# 定义工具链
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size

# 目标文件
TARGET = led_on

# 源文件
AS_SRC = start.S
C_SRC = main.c

# 编译选项
CFLAGS = -mcpu=cortex-m3 -mthumb -Wall -O2
# 使用 GCC 进行链接而不是直接使用 ld
LINK_VIA_GCC = yes  # 添加这个标志

# 根据是否使用 GCC 进行链接设置不同的 LDFLAGS
ifeq ($(LINK_VIA_GCC), yes)
    # 使用 GCC 链接时，可以使用 -Wl 选项
    LDFLAGS = -T linker.ld -nostdlib -Wl,-Map=$(TARGET).map,--cref
else
    # 直接使用 ld 时，使用不同的选项格式
    LDFLAGS = -T linker.ld -nostdlib -Map $(TARGET).map --cref
endif

# 目标
all: $(TARGET).bin $(TARGET).dis $(TARGET).map size

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -S $< $@

$(TARGET).dis: $(TARGET).elf
	$(OBJDUMP) -D $< > $@

# 根据是否使用 GCC 进行链接设置不同的链接命令
ifeq ($(LINK_VIA_GCC), yes)
$(TARGET).elf: start.o main.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@
else
$(TARGET).elf: start.o main.o
	$(LD) $(LDFLAGS) $^ -o $@
endif

$(TARGET).map: $(TARGET).elf  # MAP 文件是链接过程的副产品

start.o: start.S
	$(CC) $(CFLAGS) -c $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

# 显示内存使用统计
size: $(TARGET).elf
	@echo "===== Memory Usage Summary ====="
	$(SIZE) -B -d $<
	@echo "================================"

clean:
	rm -f *.o *.elf *.bin *.dis *.map

# 显示 MAP 文件关键信息
map-info: $(TARGET).map
	@echo "===== MEMORY USAGE SUMMARY ====="
	@echo "FLASH: $(shell grep '.text' $(TARGET).map | awk '{sum += $$3} END {print sum}') bytes" 	@echo "RAM:   $(shell grep '.bss' $(TARGET).map | awk '{sum += $$3} END {print sum}') bytes"
	@echo "==============================="

# 添加内存使用报告目标
memusage: $(TARGET).elf
	@echo "===== MEMORY USAGE SUMMARY ====="
	@arm-none-eabi-size -B -d $(TARGET).elf | tail -n 1 | awk '{printf "FLASH: %d bytes (text+data)\n", $$1 + $$2}'
	@arm-none-eabi-size -B -d $(TARGET).elf | tail -n 1 | awk '{printf "RAM:   %d bytes (data+bss)\n", $$2 + $$3}'
	@echo "==============================="