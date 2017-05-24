LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY single_digit_decimal_counter IS

	PORT(
		enable_in, true_reset, clock: IN STD_LOGIC;
		limit: IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
		output: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		carry: OUT STD_LOGIC
	);
	
END single_digit_decimal_counter;

ARCHITECTURE structural OF single_digit_decimal_counter IS
	
	COMPONENT and2
		PORT(in_a, in_b: IN STD_LOGIC; output: OUT STD_LOGIC);
	END COMPONENT;
	
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
	
	COMPONENT normalizer
		PORT(
			input: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			disable: IN STD_LOGIC; 
			output: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT not1
		PORT(input: IN STD_LOGIC; output: OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT prop
		PORT(input, carry_in: IN STD_LOGIC; output, carry_out: OUT STD_LOGIC );
	END COMPONENT;

	FOR ALL: and2 USE ENTITY work.and_2 (data_flow);
	FOR ALL: counterlimiter USE ENTITY work.counter_limiter(structural);
	FOR ALL: dflipflop USE ENTITY work.d_type_flip_flop(behaviour);
	FOR ALL: normalizer USE ENTITY work.four_bit_vector_disabler(structural);
	FOR ALL: not1 USE ENTITY work.not_1 (data_flow);
	FOR ALL: prop USE ENTITY work.propagator(data_flow);
	
	SIGNAL e_mid: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL p_out, norm_out, lm_out: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c_nrst, md_c: STD_LOGIC;
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
	lm: counterlimiter PORT MAP (enable_in, limit, norm_out, lm_out, md_c);
	
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
	nrst: not1 PORT MAP(true_reset, c_nrst);
	trc: and2 PORT MAP(c_nrst, md_c, carry);
	
END structural;