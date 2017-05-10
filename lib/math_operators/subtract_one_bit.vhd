LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY subtract_one_bit IS

	PORT(
		x, y, enable, bin: IN STD_LOGIC;
		bout, output: OUT STD_LOGIC
	);
	
END subtract_one_bit;

ARCHITECTURE structural OF subtract_one_bit IS

	COMPONENT and2 
		PORT(in_a, in_b: IN STD_LOGIC; output: OUT STD_LOGIC); 
	END COMPONENT;
	
	COMPONENT not1 
		PORT(input: IN STD_LOGIC; output: OUT STD_LOGIC); 
	END COMPONENT;
	
	COMPONENT or3 
		PORT(in_a, in_b, in_c: IN STD_LOGIC; output: OUT STD_LOGIC); 
	END COMPONENT;
	
	COMPONENT xor3 
		PORT(in_a, in_b, in_c: IN STD_LOGIC; output: OUT STD_LOGIC); 
	END COMPONENT;
	
	FOR ALL: and2 USE ENTITY work.and_2 (data_flow);
	FOR ALL: not1 USE ENTITY work.not_1 (data_flow);
	FOR ALL: or3 USE ENTITY work.or_3 (data_flow);
	FOR ALL: xor3 USE ENTITY work.xor_3 (data_flow);
	
	SIGNAL nx, nx_y, nx_bin, y_bin, pre_output, pre_bout: STD_LOGIC;

BEGIN

	--not expression
	not_exp_1: not1 PORT MAP(x,nx);
	
	--preparations for borrow
	and_exp_1: and2 PORT MAP(nx, y, nx_y);
	and_exp_2: and2 PORT MAP(nx, bin, nx_bin);
	and_exp_3: and2 PORT MAP(y, bin, y_bin);
	
	--before enable
	xor_exp: xor3 PORT MAP(x, y, bin, pre_output);
	or_exp: or3 PORT MAP(nx_y, nx_bin, y_bin, pre_bout);
	
	--compare enable
	output_f: and2 PORT MAP(pre_output, enable, output);
	borrow_f: and2 PORT MAP(pre_bout, enable, bout);
	
END structural;