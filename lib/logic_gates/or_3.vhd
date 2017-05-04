ENTITY or_3 IS

	PORT(in_a, in_b, in_c: IN BIT; output: OUT BIT);
	
END or_3;


ARCHITECTURE data_flow OF or_3 IS

BEGIN

	output <= in_a OR in_b OR in_c;
	
END data_flow;