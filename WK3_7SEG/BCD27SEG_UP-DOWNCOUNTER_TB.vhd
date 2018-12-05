LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.STD_LOGIC_UNSIGNED.all;


--///////////////////////////////////////////////////////////
--////////////////////ENTITY DECLARATION////////////////////
--/////////////////////////////////////////////////////////
ENTITY UDC_BCD27SEG_TB IS
END UDC_BCD27SEG_TB;

ARCHITECTURE BENCH OF UDC_BCD27SEG_TB IS
	COMPONENT	UP_DOWN_COUNTER
		PORT(
			clk		:	IN	STD_LOGIC;
			nrst	:	IN	STD_LOGIC;
			up		:	IN	STD_LOGIC;

			q		:	OUT INTEGER RANGE -1 TO 9
			);
	END COMPONENT;
	
	COMPONENT BCD_2_7SEG_DECODER
		PORT(
			STATE	:	IN	INTEGER RANGE -1 TO 9;
			
			SEG_A : OUT STD_LOGIC;
			SEG_B : OUT STD_LOGIC;
			SEG_C : OUT STD_LOGIC;
			SEG_D : OUT STD_LOGIC;
			SEG_E : OUT STD_LOGIC;
			SEG_F : OUT STD_LOGIC;
			SEG_G : OUT STD_LOGIC			
		);
	
	--Read from component
	SIGNAL SEG_A_IN	:	STD_LOGIC;
	SIGNAL SEG_B_IN	:	STD_LOGIC;
	SIGNAL SEG_C_IN	:	STD_LOGIC;
	SIGNAL SEG_D_IN	:	STD_LOGIC;
	SIGNAL SEG_E_IN	:	STD_LOGIC;
	SIGNAL SEG_F_IN	:	STD_LOGIC;
	SIGNAL SEG_G_IN	:	STD_LOGIC;
	
	SIGNAL SEG_COMB	:	STD_LOGIC_VECTOR(6 DOWNTO 0);	--Combined signal from component
	
	--Stimuli
	SIGNAL	clk_stim	:	STD_LOGIC;
	SIGNAL	nrst_stim	:	STD_LOGIC	:=	'0';
	SIGNAL	up_stim		:	STD_LOGIC	:=	'0';
	
	--Internal signals
	SIGNAL	state_signal	:	INTEGER RANGE -1 TO 9;
	
	--Constants
	CONSTANT	clk_period	:	TIME	:=	30 ns;
	
	BEGIN
	SEG_COMB <= SEG_A_IN & 			--Concatonate all inputs to one signal. 
					SEG_B_IN & 
					SEG_C_IN & 
					SEG_D_IN & 
					SEG_E_IN & 
					SEG_F_IN & 
					SEG_G_IN;
	
	TYPE assert_7seg IS ARRAY (9 DOWNTO 0) OF STD_LOGIC_VECTOR(6 DOWNTO 0);
	assert_7seg(-1) <= "XXXXXXX";
	assert_7seg(0) <= "1111110";
	assert_7seg(1) <= "0110000";
	assert_7seg(2) <= "1101101";
	assert_7seg(3) <= "1111001";
	assert_7seg(4) <= "0110011";
	assert_7seg(5) <= "1011011";
	assert_7seg(6) <= "1011111";
	assert_7seg(7) <= "1110000";
	assert_7seg(8) <= "1111111";
	assert_7seg(9) <= "1111011";
	
	SIGNAL	count	:	INTEGER RANGE -1 TO 0;
	
--///////////////////////////////////////////////////////////
--/////////////////////////PORT MAP/////////////////////////
--/////////////////////////////////////////////////////////
u1	:	UP_DOWN_COUNTER PORT MAP(
			clk		=>	clk_stim,
			nrst	=>	nrst_stim,
			up		=>	up_stim,
			
			q		=>	state_signal;
			);
			
u2	:	BCD_2_7SEG_DECODER PORT MAP(
			STATE	=> state_signal,
			
			STATE	=>	STATE_STIM,
			SEG_A	=>	SEG_A_IN,
			SEG_B	=>	SEG_B_IN,
			SEG_C	=>	SEG_C_IN,
			SEG_D	=>	SEG_D_IN,
			SEG_E	=>	SEG_E_IN,
			SEG_F	=>	SEG_F_IN,
			SEG_G	=>	SEG_G_IN
			);
			
--///////////////////////////////////////////////////////////
--////////////////////////////PROCESS///////////////////////
--/////////////////////////////////////////////////////////
	PROCESS
		BEGIN
			clk_stim <= '1';
			WAIT FOR (clk_period / 2);
			clk_stim <= '0';
			WAIT FOR (clk_period / 2); 
		END PROCESS
		
	PROCESS
		BEGIN
		
		up_stim <= '1';
		nrst_stim <= '0';
		WAIT FOR (2 * clk_period);
		nrst_stim <= '1';
		
		WAIT FOR (clk_period / 2);
		
		FOR i IN -1 TO 8 LOOP
			WAIT FOR clk_period;
			ASSERT SEG_COMB = assert_7seg(1 - i)
				REPORT	"WRONG OUTPUT. i = "	&integer'image(1 - i)
				SEVERITY	error;
			END LOOP;
		
		up_stim <= '0';
		
		FOR i IN -1 TO 9 LOOP
			WAIT FOR clk_period;
			ASSERT SEG_COMB
		
		WAIT;
	END PROCESS;
	
END BENCH;
	