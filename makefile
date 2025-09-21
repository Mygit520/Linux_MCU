all:
	arm-none-eabi-gcc -mcpu=cortex-m0plus -mthumb -c start.S -o led_on.o
	arm-none-eabi-ld -Ttext 0x08000000 led_on.o -o led_on.elf
	arm-none-eabi-objcopy -O binary -S led_on.elf led_on.bin
	arm-none-eabi-objdump -D led_on.elf > led_on.dis
clean:
	rm *.bin *.o *.elf