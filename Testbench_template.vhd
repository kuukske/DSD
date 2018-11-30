LIBRARY ieee;
USE ieee.std_logic_1164.all;


--///////////////////////////////////////////////////////////
--////////////////////ENTITY DECLARATION////////////////////
--/////////////////////////////////////////////////////////
ENTITY TEST_ENTITY IS
END TEST_ENTITY;

ARCHITECTURE BENCH OF TEST_ENTITY IS
	COMPONENT	COMPONENT_NAME
		PORT(
			COMPONENT_INPUT		:	IN		STD_LOGIC;
			COMPONENT_OUTPUT	:	OUT 	STD_LOGIC;
			);
	END COMPONENT;
	
	SIGNAL TB_INPUT_1	:	STD_LOGIC;		--Read from component
	SIGNAL TB_OUTPUT_1	:	STD_LOGIC;		--Stimuli to component
	
	SIGNAL TB_INPUT_2	:	STD_LOGIC;
	SIGNAL TB_OUTPUT_2	:	STD_LOGIC;
	
	BEGIN
	
--///////////////////////////////////////////////////////////
--/////////////////////////PORT MAP/////////////////////////
--/////////////////////////////////////////////////////////
u1	:	COMPONENT_NAME PORT MAP(
			COMPONENT_INPUT		=>	TB_OUTPUT_1;
			COMPONENT_OUTPUT	=>	TB_INPUT_1;
			);
			
u2	:	COMPONENT_NAME PORT MAP(
			COMPONENT_INPUT		=>	TB_OUTPUT_2;
			COMPONENT_OUTPUT	=>	TB_INPUT_2;
			);
			
--///////////////////////////////////////////////////////////
--////////////////////////////PROCESS///////////////////////
--/////////////////////////////////////////////////////////			
	PROCESS
		BEGIN
		
		TB_OUTPUT_2 <= "0"
		WAIT FOR 20 ns;		
		ASSERT TB_INPUT_1 = "1"
			REPORT	"INCORRECT OUTPUT ON COMPONENT_OUTPUT"
			SEVERITY	error;
		
		WAIT;
	END PROCESS;
	
END BENCH;
	