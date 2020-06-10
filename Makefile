GPPPARAMS = -ffreestanding -g -c
ASPARAMS = --32
LDPARAMS = -ffreestanding -nostdlib -g -T

objects = loader.o kernel.o

%.o: %.cpp
	/home/zonik42/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-g++ $(GPPPARAMS) -o $@ -c $<
	
%.o: %.s
	/home/zonik42/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-g++ $(GPPPARAMS) -o $@ -c $<
	
mykernel.elf: linker.ld $(objects)
	/home/zonik42/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-g++ $(LDPARAMS) $< -o $@ $(objects) -lgcc
	
clean:
	rm *.o
	rm *.elf

install: mykernel.bin
	sudo cp $< /boot/mykernel.bin
