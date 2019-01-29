--
--
-- Digital System Design Assignment UART
--
-- Module : Baudrate Timer for Simulation (Sender) 
-- 
-- BaudrateTimer_S_Simulation.vhd
--          
--	
-- 
--Adapted for Simulation frequency 500 kHz.
--
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity BaudrateTimer_S_Simulation is
   port(	Baudrate : in     std_logic_vector (1 downto 0);
			Clk      : in     std_logic;
			nRST     : in     std_logic;
			next_bit : out    std_logic
			);
end entity BaudrateTimer_S_Simulation;

--
architecture behavioral of BaudrateTimer_S_Simulation is

SIGNAL setPoint	:	integer range 0 to 1666		:= 0;
SIGNAL countVal	:	integer range 0 to 1666		:= 0;

begin
	PROCESS(Clk, nRST, countVal)
		BEGIN
			IF nRST = '1'  THEN
				IF rising_edge(Clk) THEN
					
					CASE Baudrate is
						when	"00"	=>	setPoint 	<=	1665;
						when	"01"	=>	setPoint	<=	832;
						when	"10"	=>	setPoint	<=	415;
						when	"11"	=>	setPoint	<=	207;
						when	OTHERS	=>	NULL;
					END CASE;
					
					IF countVal = setPoint THEN
						next_bit <= '1';
						countVal <= 0; 
					ELSE
						next_bit <= '0';
						countVal <= countVal + 1; 
					END IF;
				

				END IF;
			ELSIF nRST = '0' THEN
				countVal		<=	0;
				next_bit	<=	'0';
			END IF;
			
		IF countVal = 1666 THEN
					countVal <= 0;
				END IF;
		END PROCESS;


end architecture behavioral;

