-- Bram Kuijk
-- EE7
-- DSD
-- Fontys Engineering Eindhoven
LIBRARY ieee;
USE ieee.std_logic_1164.all;

--////////////////////ENTITY DECLARATION////////////////////
ENTITY U_D_COUNTER_TB IS
END U_D_COUNTER_TB;

ARCHITECTURE BENCH OF U_D_COUNTER_TB IS
	COMPONENT	UP_DOWN_COUNTER
		PORT(
			clk		:	IN	STD_LOGIC;
			nrst	:	IN	STD_LOGIC;
			up		:	IN	STD_LOGIC;

			q		:	OUT INTEGER RANGE -1 TO 9
		);
	END COMPONENT;
	
	SIGNAL q_in			:	INTEGER RANGE -1 TO 9;	
	
	SIGNAL clk_stim		:	STD_LOGIC;
	SIGNAL nrst_stim	:	STD_LOGIC := '0';
	SIGNAL up_stim		:	STD_LOGIC := '0';
	
	CONSTANT	clk_period	:	TIME	:= 30 ns;
	
	BEGIN			--Begin architecture
	
--/////////////////////////PORT MAP/////////////////////////

			clk		=>	clk_stim,
			nrst	=>	nrst_stim,
			up		=>	up_stim,
			
			q		=> q_in
			);
			

--////////////////////////////PROCESS///////////////////////	
	PROCESS
		BEGIN
			clk_stim <= '1';
			WAIT FOR (clk_period / 2);
			clk_stim <= '0';
			WAIT FOR (clk_period / 2);
	END PROCESS;

	PROCESS
		BEGIN
			
			nrst_stim <= '1'; 
			up_stim <= '1';
			
			WAIT FOR (clk_period / 2);
			
			ASSERT 1 = 0
				REPORT "TESTING OUTPUT = -1"		--Report what is being tested (for debug)
				SEVERITY 	note;
			ASSERT q_in = -1
				REPORT "INCORRECT INITIAL VALUE, SHOULD BE -1"
				SEVERITY	error;
			
			
			FOR i IN 0 TO 9 LOOP	--Count up until 9, report what is being tested (for debug)
				WAIT FOR clk_period;
				ASSERT 1 = 0
					REPORT "TESTING OUTPUT = " &integer'image(i)
					SEVERITY	note;
				ASSERT q_in = i 
					REPORT "INCORECT COUNTER VALUE (COUNT UP)" &integer'image(i)
					SEVERITY 	error; 
			END LOOP;
			
			up_stim <= '0';
			
			FOR i IN 0 TO 8 LOOP	--Count down until -1, report what is being tested (for debug) 
				WAIT FOR clk_period;
				ASSERT 1 = 0
					REPORT "TESTING OUTPUT = " &integer'image(8 - i)
					SEVERITY	note;
				ASSERT q_in = (8 - i)
					REPORT "INCORRECT COUNTER VALUE (COUNT DOWN). i = " &integer'image(8 - i)
					SEVERITY	error;
			END LOOP;
			
		--Report testing complete
		ASSERT 1 = 0
			REPORT "TEST COMPLETE"
			SEVERITY	note;
		
		WAIT;
	END PROCESS;
	
END BENCH;
