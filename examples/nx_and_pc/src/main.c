// Include the most common headers from the C standard library
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef __SWITCH__
	#include <switch.h>
#endif

// Main program entrypoint
int main(int argc, char* argv[])
{
	#ifdef __SWITCH__
    // This example uses a text console, as a simple way to output text to the screen.
    // If you want to write a software-rendered graphics application,
    //   take a look at the graphics/simplegfx example, which uses the libnx Framebuffer API instead.
    // If on the other hand you want to write an OpenGL based application,
    //   take a look at the graphics/opengl set of examples, which uses EGL instead.
    consoleInit(NULL);

    // Other initialization goes here. As a demonstration, we print hello world.
    printf("Compiled for NX!\n");

    // Main loop
    while (appletMainLoop())
    {
        // Scan all the inputs. This should be done once for each frame
        hidScanInput();

        // hidKeysDown returns information about which buttons have been
        // just pressed in this frame compared to the previous one
        u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);

        if (kDown & KEY_PLUS)
            break; // break in order to return to hbmenu

        // Your code goes here

        // Update the console, sending a new frame to the display
        consoleUpdate(NULL);
    }

    // Deinitialize and clean up resources used by the console (important!)
    consoleExit(NULL);
	#else
	// just do something here so we know the thing actually works compiling for pc
	printf("Compiled for PC!\n");
	#endif
    return 0;
}
