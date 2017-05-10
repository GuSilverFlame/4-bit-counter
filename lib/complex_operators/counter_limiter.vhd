LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_limiter IS

	PORT(
		enable: IN STD_LOGIC;
		limit, comparison: IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
		output: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
	
END counter_limiter;


ARCHITECTURE structural OF counter_limiter IS

	COMPONENT fourbitvectorenabler
		PORT(
			input: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			enable: IN STD_LOGIC; 
			output: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT subtractor4bits
		PORT(
			bin, enable: IN STD_LOGIC;
			x, y: IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
			output: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			bout: OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT not1 
		PORT(input: IN STD_LOGIC; output: OUT STD_LOGIC); 
	END COMPONENT;
	
	FOR ALL: fourbitvectorenabler USE ENTITY work.four_bit_vector_enabler (structural);
	FOR ALL:subtractor4bits USE ENTITY work.full_subtractor_4_bit(structural);
	FOR ALL: not1 USE ENTITY work.not_1 (data_flow);
		
	SIGNAL borrow, reverse_borrow: STD_LOGIC;
	
BEGIN
	
	calculate: subtractor4bits	
		PORT MAP(
			bin => '0',
			enable => enable,
			x => limit,
			y => comparison, 
			output => OPEN, 
			bout => borrow
		);
	invert: not1 PORT MAP(borrow, reverse_borrow);
	verify: fourbitvectorenabler PORT MAP(comparison, reverse_borrow, output);
		
END structural;