LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY d_type_flip_flop IS

	PORT(clock, input: IN STD_LOGIC; output, inv_output: INOUT STD_LOGIC);
	
END d_type_flip_flop;


ARCHITECTURE behaviour OF d_type_flip_flop IS
	
BEGIN

    PROCESS (clock) IS
    BEGIN

        IF rising_edge(clock) THEN
            output <= input;
            inv_output <= NOT input;
        END IF;

   END PROCESS;

END behaviour;
