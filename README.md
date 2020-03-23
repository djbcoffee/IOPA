# IOPA
The IO Port Adapter (IOPA) provides two 8-bit general purpose input/output (I/O) ports to any host system via an 8-bit data bus and a few control lines. It provides all the logic needed to control the ports, and their pins, individually while offering a straightforward host interface making it ideal for embedded microcontroller and microprocessor designs.

The IOPA project page, with user manual and hardware files, can be found [here](https://sites.google.com/view/m-chips/iopa)

## Archive content

The following files are provided:
* DataDirectionRegister.vhd - Source code file
* HostInterface.vhd - Source code file
* InputDataRegister.vhd - Source code file
* IO.vhd - Source code file
* OutputDataRegister.vhd - Source code file
* PortA.vhd - Source code file
* PortB.vhd - Source code file
* Universal.vhd - Source code file
* IO.ucf - Configuration file
* IO.jed - JEDEC Program file
* LICENSE - License text
* README.md - This file

## Prerequisites

Xilinx’s ISE WebPACK Design Suite version 14.7 is required to do a build and can be obtained [here](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html)

Familiarity with the use and operation of the Xilinx ISE Design Suite is assumed and beyond the scope of this readme file.

## Installing

Place the source files into any convenient location on your PC.  NOTE:  The Xilinx ISE Design Suite can not handle spaces in directory and file names.

The JEDEC Program file IO.jed was created with Xilinx ISE WebPACK Design Suite version 14.7.  This can be used to program the Xilinx XC9572XL-10VQG44C CPLD without any further setup.  If you wish to do a build continue with the following steps.

Create a project called IO using the XC9572XL CPLD in a VQ44 package with a speed of -10.\
Set the following for the project:\
Top-Level Source Type = HDL\
Synthesis Tool = XST (VHDL/Verilog)\
Simulator ISim (VHDL/Verilog)\
Perferred Language = VHDL\
VHDL Source Analysis Standard = VHDL-93

Add the source code and configuration file to the project.  NOTE:  Universal.vhd needs to set as a global file in the compile list.

Synthesis options need to be set as:  
Input File Name                    : "IO.prj"\
Input Format                       : mixed\
Ignore Synthesis Constraint File   : NO\
Output File Name                   : "IO"\
Output Format                      : NGC\
Target Device                      : XC9500XL CPLDs\
Top Module Name                    : IO\
Automatic FSM Extraction           : YES\
FSM Encoding Algorithm             : Auto\
Safe Implementation                : Yes\
Mux Extraction                     : Yes\
Resource Sharing                   : YES\
Add IO Buffers                     : YES\
MACRO Preserve                     : YES\
XOR Preserve                       : YES\
Equivalent register Removal        : YES\
Optimization Goal                  : Speed\
Optimization Effort                : 1\
Keep Hierarchy                     : Yes\
Netlist Hierarchy                  : As_Optimized\
RTL Output                         : Yes\
Hierarchy Separator                : /\
Bus Delimiter                      : <>\
Case Specifier                     : Maintain\
Verilog 2001                       : YES\
Clock Enable                       : YES\
wysiwyg                            : NO

Fitter options need to be set as:\
Device(s) Specified                         : xc9572xl-10-VQ44\
Optimization Method                         : SPEED\
Multi-Level Logic Optimization              : ON\
Ignore Timing Specifications                : OFF\
Default Register Power Up Value             : LOW\
Keep User Location Constraints              : ON\
What-You-See-Is-What-You-Get                : OFF\
Exhaustive Fitting                          : OFF\
Keep Unused Inputs                          : OFF\
Slew Rate                                   : FAST\
Power Mode                                  : STD\
Ground on Unused IOs                        : ON\
Set I/O Pin Termination                     : FLOAT\
Global Clock Optimization                   : ON\
Global Set/Reset Optimization               : ON\
Global Ouput Enable Optimization            : ON\
Input Limit                                 : 54\
Pterm Limit                                 : 25

The design can now be implemented.

## Built With

* [Xilinx’s ISE WebPACK Design Suite version 14.7](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html) - The development, simulation, and programming environment used

## Version History

* v1.0.0 - 2019 
	- Initial release

## Authors

* **Donald J Bartley** - *Initial work* - [djbcoffee](https://github.com/djbcoffee)

## License

This project is licensed under the GNU Public License 2 - see the [LICENSE](LICENSE) file for details
