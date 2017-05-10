LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xor_3 IS 

	PORT(in_a, in_b, in_c: IN STD_LOGIC; output: OUT STD_LOGIC);
	
END xor_3;


ARCHITECTURE data_flow OF xor_3 IS

BEGIN

	output <= in_a XOR in_b XOR in_c;
	
END data_flow;