LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY or_3 IS

	PORT(in_a, in_b, in_c: IN STD_LOGIC; output: OUT STD_LOGIC);
	
END or_3;


ARCHITECTURE data_flow OF or_3 IS

BEGIN

	output <= in_a OR in_b OR in_c;
	
END data_flow;