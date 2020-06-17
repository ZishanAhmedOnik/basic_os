#include "types.h"
#include "gdt.h"

void printf(const int8_t* str)
{
    uint16_t* VideoMemory = (uint16_t*)0xb8000;

    static uint8_t x = 0;
    static uint8_t y = 0;
 
    for(int i = 0; str[i] != '\0'; ++i)
    {
        switch (str[i])
        {
        case '\n':
            x = 0;
            y++;
            break;
        
        default:
            VideoMemory[y * 80 + x] = (VideoMemory[y * 80 + x] & 0xFF00) | str[i];
            x++;
            break;
        }

        if(x >= 80)
        {
            x = 0;
            y++;
        }

        if(y >= 25) 
        {
            for(y = 0; y < 25; y++)
            {
                for(x = 0; x < 80; x++)
                {
                    VideoMemory[y * 80 + x] = (VideoMemory[y * 80 + x] & 0xFF00) | ' ';
                }
            }

            x = 0;
            y = 0;
        }
    }
}

typedef void (*constructor)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;

extern "C" void callConstructors()
{
    for(constructor* i = &start_ctors; i != &end_ctors; i++)
    {
        (*i)();
    }
}

extern "C" void kernelMain(void* multiboot_structure, uint32_t magicnumber)
{
    printf("Hello VM World! with types :/\n");
    printf("This is another sentence!");

    GlobalDescriptorTable gdt;

    while(true) {};
}
