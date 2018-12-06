-- Bram Kuijk
-- EE7
-- DSD
-- Fontys Engineering Eindhoven

LIBRARY ieee;
USE ieee.std_logic_1164.all;


--  Entity Declaration

ENTITY BCD_2_7SEG_DECODER IS
-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
PORT
(
STATE : IN INTEGER RANGE -1 TO 9;

SEG_A : OUT STD_LOGIC;
SEG_B : OUT STD_LOGIC;
SEG_C : OUT STD_LOGIC;
SEG_D : OUT STD_LOGIC;
SEG_E : OUT STD_LOGIC;
SEG_F : OUT STD_LOGIC;
SEG_G : OUT STD_LOGIC
);
-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!

END BCD_2_7SEG_DECODER;


--  Architecture Body

ARCHITECTURE BCD_2_7SEG_DECODER_architecture OF BCD_2_7SEG_DECODER IS


BEGIN

BCD_2_7SEG_DECODER:	PROCESS(STATE)
	BEGIN
		CASE STATE IS
			WHEN	0	=> 	--OUT = 0
			SEG_A		<=		'1'	AFTER	10 ns	;
			SEG_B		<=		'1'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'1'	AFTER	10 ns	;
			SEG_E		<=		'1'	AFTER	10 ns	;
			SEG_F		<=		'1'	AFTER	10 ns	;
			SEG_G		<=		'0'	AFTER	10 ns	;
			
			WHEN	1	=>		--OUT 1
			SEG_A		<=		'0'	AFTER	10 ns	;
			SEG_B		<=		'1'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'0'	AFTER	10 ns	;
			SEG_E		<=		'0'	AFTER	10 ns	;
			SEG_F		<=		'0'	AFTER	10 ns	;
			SEG_G		<=		'0'	AFTER	10 ns	;
			
			WHEN	2	=>		--OUT 2
			SEG_A		<=		'1'	AFTER	10 ns	;
			SEG_B		<=		'1'	AFTER	10 ns	;
			SEG_C		<=		'0'	AFTER	10 ns	;
			SEG_D		<=		'1'	AFTER	10 ns	;
			SEG_E		<=		'1'	AFTER	10 ns	;
			SEG_F		<=		'0'	AFTER	10 ns	;
			SEG_G		<=		'1'	AFTER	10 ns	;
			
			WHEN	3	=>		--OUT 3
			SEG_A		<=		'1'	AFTER	10 ns	;
			SEG_B		<=		'1'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'1'	AFTER	10 ns	;
			SEG_E		<=		'0'	AFTER	10 ns	;
			SEG_F		<=		'0'	AFTER	10 ns	;
			SEG_G		<=		'1'	AFTER	10 ns	;
			
			WHEN	4	=>		--OUT 4
			SEG_A		<=		'0'	AFTER	10 ns	;
			SEG_B		<=		'1'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'0'	AFTER	10 ns	;
			SEG_E		<=		'0'	AFTER	10 ns	;
			SEG_F		<=		'1'	AFTER	10 ns	;
			SEG_G		<=		'1'	AFTER	10 ns	;
			
			WHEN	5	=>		--OUT 5
			SEG_A		<=		'1'	AFTER	10 ns	;
			SEG_B		<=		'0'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'1'	AFTER	10 ns	;
			SEG_E		<=		'0'	AFTER	10 ns	;
			SEG_F		<=		'1'	AFTER	10 ns	;
			SEG_G		<=		'1'	AFTER	10 ns	;
			
			WHEN	6	=>		--OUT 6
			SEG_A		<=		'1'	AFTER	10 ns	;
			SEG_B		<=		'0'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'1'	AFTER	10 ns	;
			SEG_E		<=		'1'	AFTER	10 ns	;		
			SEG_F		<=		'1'	AFTER	10 ns	;
			SEG_G		<=		'1'	AFTER	10 ns	;
			
			WHEN	7	=>		--OUT 7
			SEG_A		<=		'1'	AFTER	10 ns	;
			SEG_B		<=		'1'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'0'	AFTER	10 ns	;
			SEG_E		<=		'0'	AFTER	10 ns	;
			SEG_F		<=		'0'	AFTER	10 ns	;
			SEG_G		<=		'0'	AFTER	10 ns	;
			
			WHEN	8	=>		--OUT 8
			SEG_A		<=		'1'	AFTER	10 ns	;
			SEG_B		<=		'1'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'1'	AFTER	10 ns	;
			SEG_E		<=		'1'	AFTER	10 ns	;
			SEG_F		<=		'1'	AFTER	10 ns	;
			SEG_G		<=		'1'	AFTER	10 ns	;
			
			WHEN	9	=>		--OUT 9
			SEG_A		<=		'1'	AFTER	10 ns	;
			SEG_B		<=		'1'	AFTER	10 ns	;
			SEG_C		<=		'1'	AFTER	10 ns	;
			SEG_D		<=		'1'	AFTER	10 ns	;
			SEG_E		<=		'0'	AFTER	10 ns	;
			SEG_F		<=		'1'	AFTER	10 ns	;
			SEG_G		<=		'1'	AFTER	10 ns	;
			
			WHEN OTHERS		=>		--OUT INVALID
			SEG_A		<=		'X'	AFTER	10 ns	;
			SEG_B		<=		'X'	AFTER	10 ns	;
			SEG_C		<=		'X'	AFTER	10 ns	;
			SEG_D		<=		'X'	AFTER	10 ns	;
			SEG_E		<=		'X'	AFTER	10 ns	;
			SEG_F		<=		'X'	AFTER	10 ns	;
			SEG_G		<=		'X'	AFTER	10 ns	;
			
		END CASE;
	END PROCESS BCD_2_7SEG_DECODER;
		
			

END BCD_2_7SEG_DECODER_architecture;
