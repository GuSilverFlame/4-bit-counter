LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY d_type_flip_flop IS

	PORT(clock, input: IN STD_LOGIC; output, inv_output: INOUT STD_LOGIC);
	
END d_type_flip_flop;


ARCHITECTURE data_flow OF d_type_flip_flop IS

	SIGNAL inv_in: STD_LOGIC;
	
BEGIN

	inv_in <= NOT input;
	output <= (input NAND clock) NOR inv_output;
	inv_output <= (inv_in NAND clock) NOR output; 
	
END data_flow;