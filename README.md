# defender-FPGA
Classic 80's Defender on a Altera DE-10 SoC
## Components
Contains various VHDL components used in the top level proj0.vhd
## vga_controller.vhd
Primary VGA controller to generate output to VGA monitor. This controller is based on the VGA controller found in the DE-10 SoC example projects.
## vga_pll_25_175.vhd
VGA PLL to generate the VGA clock from the 50MHz clock provided by the DE-10 SoC. This PLL is based on the VGA PLL found in the DE-10 SoC example projects.
## proj0
The top level VHDL file for the project. This file contains the main game loop.