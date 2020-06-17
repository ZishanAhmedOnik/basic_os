GPPPARAMS = -ffreestanding -fno-exceptions -fno-rtti -g -c
ASPARAMS = --32
LDPARAMS = -ffreestanding -nostdlib -g -T

objects = loader.o gdt.o port.o kernel.o

%.o: %.cpp
	/home/zonik42/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-g++ $(GPPPARAMS) -o $@ -c $<
	
%.o: %.s
	/home/zonik42/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-g++ $(GPPPARAMS) -o $@ -c $<
	
mykernel.elf: linker.ld $(objects)
	/home/zonik42/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-g++ $(LDPARAMS) $< -o $@ $(objects) -lgcc
	
clean:
	rm *.o
	rm *.elf
	rm *.iso
	rm -rf iso

mykernel.iso: mykernel.elf
	mkdir iso
	mkdir iso/boot/
	mkdir iso/boot/grub
	cp $< iso/boot

	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo '' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My Operating System" {' >> iso/boot/grub/grub.cfg
	echo '	multiboot /boot/mykernel.elf' >> iso/boot/grub/grub.cfg
	echo '	boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg

	grub-mkrescue --output=$@ iso

run: mykernel.iso
	(killall VirtualBox && sleep 1) || true
	VirtualBox --startvm "myos" &