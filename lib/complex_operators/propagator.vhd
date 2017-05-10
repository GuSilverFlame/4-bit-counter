LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY propagator IS
 PORT(input, carry_in: IN STD_LOGIC; output, carry_out: OUT STD_LOGIC );
END propagator;

ARCHITECTURE data_flow OF propagator IS
BEGIN
	output <= input XOR carry_in;
	carry_out <= input AND carry_in;
END data_flow;