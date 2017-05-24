LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY single_digit_decimal_counter IS

	PORT(
		enable_in, true_reset, clock: IN STD_LOGIC;
		limit: IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
		output: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		carry: INOUT STD_LOGIC
	);
	
END single_digit_decimal_counter;

ARCHITECTURE structural OF single_digit_decimal_counter IS
	
	COMPONENT counterlimiter
		PORT(
			enable: IN STD_LOGIC;
			limit, comparison: IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
			output: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			carry: INOUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT dflipflop
		PORT(clock, input: IN STD_LOGIC; output, inv_output: INOUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT prop
		PORT(input, carry_in: IN STD_LOGIC; output, carry_out: OUT STD_LOGIC );
	END COMPONENT;
	
	COMPONENT normalizer
		PORT(
			input: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			disable: IN STD_LOGIC; 
			output: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	FOR ALL: counterlimiter USE ENTITY work.counter_limiter(structural);
	FOR ALL: dflipflop USE ENTITY work.d_type_flip_flop(behaviour);
	FOR ALL: prop USE ENTITY work.propagator(data_flow);
	FOR ALL: normalizer USE ENTITY work.four_bit_vector_disabler(structural);
	
	SIGNAL e_mid: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL p_out, norm_out, lm_out: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

	-- enablers propagate
	pro0: prop PORT MAP(output(0), enable_in, norm_out(0),e_mid(0));
	pro1: prop PORT MAP(output(1), e_mid(0), norm_out(1),e_mid(1));
	pro2: prop PORT MAP(output(2), e_mid(1), norm_out(2),e_mid(2));
	pro3: prop PORT MAP(
		input => output(3), 
		carry_in => e_mid(2), 
		output => norm_out(3),
		carry_out => OPEN
	);
	
	-- reset over limit
	lm: counterlimiter PORT MAP (enable_in, limit, norm_out, lm_out, carry);
	
	-- set flip-flops get next output
	d0: dflipflop PORT MAP (
		clock => clock, 
		input => lm_out(0),
		output => p_out(0),
		inv_output => OPEN
	);
	
	d1: dflipflop PORT MAP (
		clock => clock, 
		input => lm_out(1),
		output => p_out(1),
		inv_output => OPEN
	);
	d2: dflipflop PORT MAP (
		clock => clock, 
		input => lm_out(2),
		output => p_out(2),
		inv_output => OPEN
	);
	d3: dflipflop PORT MAP (
		clock => clock, 
		input => lm_out(3),
		output => p_out(3),
		inv_output => OPEN
	);
	
	-- true reset
	tr: normalizer PORT MAP(p_out, true_reset, output);
	
END structural;