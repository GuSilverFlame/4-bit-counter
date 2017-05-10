LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY four_bit_vector_enabler IS

	PORT(
		input: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		enable: IN STD_LOGIC; 
		output: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
	
END four_bit_vector_enabler;


ARCHITECTURE structural OF four_bit_vector_enabler IS

	COMPONENT and2 
		PORT(in_a, in_b: IN STD_LOGIC; output: OUT STD_LOGIC); 
	END COMPONENT;
	
	FOR ALL: and2 USE ENTITY work.and_2 (data_flow);

BEGIN

	out0: and2 PORT MAP(input(0), enable, output(0));
	out1: and2 PORT MAP(input(1), enable, output(1));
	out2: and2 PORT MAP(input(2), enable, output(2));
	out3: and2 PORT MAP(input(3), enable, output(3));
	
END structural;