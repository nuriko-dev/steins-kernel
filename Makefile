AS = as
CC = gcc
LD = ld

# Work Flags
ASFLAGS = --32
CCFLAGS = -m32 -ffreestanding -fno-pie
LDFLAGS = -m elf_i386

# More Global Stuff
OUTPUT_DIR = ./build
OUTPUT_IMAGE = $(OUTPUT_DIR)/steins-os.iso

# Boot Sector Factory
BS_OUT = $(OUTPUT_DIR)/steins-sector.bin
BS_LINK_FLAGS = -Ttext 0x7c00 --oformat=binary
BS_SRC = ./boot/arch/i386/boot.s
BS_OBJ = $(BS_SRC:.s=.o)

all: image

%.o: %.s
	@echo "   > Assembling" $<...
	@$(AS) $(ASFLAGS) -o $@ $<

bootsector: $(BS_OBJ)
	@echo "> Linking the assembled bootsector sources..."
	@$(LD) -o $(BS_OUT) $^ $(BS_LINK_FLAGS) $(LDFLAGS)

image: bootsector
	@echo "> Creating an empty disk image.."
	@dd if=/dev/zero of=$(OUTPUT_IMAGE) bs=512 count=2880 status=none
	@echo "> Writing the bootsector.."
	@dd if=$(BS_OUT) of=$(OUTPUT_IMAGE) conv=notrunc bs=512 seek=0 count=1 status=none
	
clean:
	@rm -rf $(BS_OBJ) $(BS_OUT)
	@rm -rf $(OUTPUT_IMAGE)
