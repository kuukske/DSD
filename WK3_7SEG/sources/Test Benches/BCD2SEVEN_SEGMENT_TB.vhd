-- Bram Kuijk
-- EE7
-- DSD
-- Fontys Engineering Eindhoven

LIBRARY ieee;
USE ieee.std_logic_1164.all;


--  Entity Declaration
ENTITY TEST_BCD IS
END TEST_BCD;

ARCHITECTURE BENCH OF TEST_BCD IS
	COMPONENT BCD_2_7SEG_DECODER
		PORT (
				STATE	:	IN	INTEGER RANGE -1 TO 9;
				SEG_A : OUT STD_LOGIC;
				SEG_B : OUT STD_LOGIC;
				SEG_C : OUT STD_LOGIC;
				SEG_D : OUT STD_LOGIC;
				SEG_E : OUT STD_LOGIC;
				SEG_F : OUT STD_LOGIC;
				SEG_G : OUT STD_LOGIC
				);
		END COMPONENT;
	
	SIGNAL STATE_STIM	:	INTEGER RANGE -1 TO 9;
	
	SIGNAL SEG_A_IN	:	STD_LOGIC;
	SIGNAL SEG_B_IN	:	STD_LOGIC;
	SIGNAL SEG_C_IN	:	STD_LOGIC;
	SIGNAL SEG_D_IN	:	STD_LOGIC;
	SIGNAL SEG_E_IN	:	STD_LOGIC;
	SIGNAL SEG_F_IN	:	STD_LOGIC;
	SIGNAL SEG_G_IN	:	STD_LOGIC;
	
	SIGNAL SEG_COMB	:	STD_LOGIC_VECTOR(6 DOWNTO 0);
	
	BEGIN
	SEG_COMB <= SEG_A_IN & 			--Concatonate all inputs to one signal. 
					SEG_B_IN & 
					SEG_C_IN & 
					SEG_D_IN & 
					SEG_E_IN & 
					SEG_F_IN & 
					SEG_G_IN;
					
u1	:	BCD_2_7SEG_DECODER PORT MAP(		--Connect BCD_2_7SEG_DECODER block to test bench
			STATE	=>	STATE_STIM,
			SEG_A	=>	SEG_A_IN,
			SEG_B	=>	SEG_B_IN,
			SEG_C	=>	SEG_C_IN,
			SEG_D	=>	SEG_D_IN,
			SEG_E	=>	SEG_E_IN,
			SEG_F	=>	SEG_F_IN,
			SEG_G	=>	SEG_G_IN
			);
		
	PROCESS
		BEGIN
		
		STATE_STIM <= 0;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "1111110"
			REPORT	"INCORRECT OUTPUT IN BCD 0"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 1;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "0110000"
			REPORT	"INCORRECT OUTPUT IN BCD 1"
			SEVERITY error;
		
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 2;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "1101101"
			REPORT	"INCORRECT OUTPUT IN BCD 2"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 3;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "1111001"
			REPORT	"INCORRECT OUTPUT IN BCD 3"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 4;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "0110011"
			REPORT	"INCORRECT OUTPUT IN BCD 4"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 5;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "1011011"
			REPORT	"INCORRECT OUTPUT IN BCD 5"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 6;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "1011111"
			REPORT	"INCORRECT OUTPUT IN BCD 6"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 7;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "1110000"
			REPORT	"INCORRECT OUTPUT IN BCD 7"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 8;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "1111111"
			REPORT	"INCORRECT OUTPUT IN BCD 8"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
		
		STATE_STIM <= 9;
		WAIT FOR 20 ns;		--Propogation delay
		ASSERT SEG_COMB = "1111011"
			REPORT	"INCORRECT OUTPUT IN BCD 9"
			SEVERITY	error;
			
		WAIT FOR 10 ns;		--Sim loop delay
			
		ASSERT 1 = 0					--Note that test is completed
			REPORT "TEST COMPLETED"
			SEVERITY	note;
		WAIT;
	END PROCESS;
	
END BENCH;
					
					
					