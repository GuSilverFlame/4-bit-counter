LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY full_subtractor_4_bit IS

	PORT(
		bin, enable: IN STD_LOGIC;
		x, y: IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
		output: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		bout: OUT STD_LOGIC
	);
	
END full_subtractor_4_bit;


ARCHITECTURE structural OF full_subtractor_4_bit IS

	COMPONENT subtract1bit 
		PORT(x, y, enable, bin: IN STD_LOGIC; bout, output: OUT STD_LOGIC);
	END COMPONENT;
	
	FOR ALL:subtract1bit USE ENTITY work.subtract_one_bit(structural);
	
	SIGNAL bmid: STD_LOGIC_VECTOR (2 DOWNTO 0);
	
BEGIN

	c1:subtract1bit PORT MAP(x(0), y(0), enable, bin, bmid(0), output(0));
	c2:subtract1bit PORT MAP(x(1), y(1), enable, bmid(0), bmid(1), output(1));
	c3:subtract1bit PORT MAP(x(2), y(2), enable, bmid(1), bmid(2), output(2));
	c4:subtract1bit PORT MAP(x(3), y(3), enable, bmid(2), bout, output(3));
	
END structural;
	


