# HDL-MODULES
A collection of generic VHDL/Verilog modules to be used in projects and design. The following modules are provided:

  - ALUs/alu: a simple ALU able to perform addition, subtraction and the AND/OR/XOR/NAND/NOR/XNOR bitwise logical operations.
  - Adders/carry_select_adder: a simple carry select adder based on ripple-carry adders.
  - Adders/ripple_carry_adder: the simplest structural ripple-carry adder made of a chain of full adders.
  - Adders/sparse_tree_adder: a valence-2 Sklansky sparse tree adder similar to the Intel Pentium 4's one.
  - Counters/programmable_counter: a programmable counter allowing for up/downcounting, custom value counting, one-shot/repeated counting and endowed with a prescaler.
  - Counters/pwm_generator: a simple PWM generator with asynchronous reset and the ability to achieve a true 0 duty cycle.
  - Counters/synchronous_counter: a synchronous upcounter allowing for custom value counting.
  - Logicals/bitwise_logical_calculator: a bitwise AND/OR/XOR/NAND/NOR/XNOR calculator based on a two-level NAND structure.
  - Memories/register_file: a simple register file with two parallel asynchronous reading port and one synchronous writing port.
  - Memories/windowed_register_file: a windowed register file with 32 registers for each window; no memory spilling/filling function is provided.
  - Multiplexers/multiplexer: a Nx1 multiplexer built from stages of 2x1 multiplexers.
  - Multipliers/booth_multiplier: a valence-4 Booth multiplier extended so to be able to work also with operands having an odd number of bits.
  - Testbench: a De Bruijn FSR-based testbench template.
  
Every module is guaranteed to work when istantiated on 8, 16, 32 and 64 bits.
