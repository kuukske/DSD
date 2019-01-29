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
use ieee.

entity BaudrateTimer_S_Simulation is
   port(	Baudrate : in     std_logic_vector (1 downto 0);
			Clk      : in     std_logic;
			nRST     : in     std_logic;
			next_bit : out    std_logic);
end entity BaudrateTimer_S_Simulation;

--
architecture behavioral of BaudrateTimer_S_Simulation is
SIGNAL setPoint	:	INTEGER	RANGE 0 TO 1665	:= 0;
SIGNAL count	:	INTEGER	RANGE 0 TO 1665 := 0;

begin
switch:     PROCESS(Clk, nRST)
		BEGIN
			IF nRST = '1'  THEN
				IF rising_edge(Clk) THEN
					
					CASE Baudrate is
						when	"00"	=>	setPoint 	<=	1665;
						when	"01"	=>	setPoint	<=	832;
						when	"10"	=>	setPoint	<=	415;
						when	"11	"	=>	setPoint	<=	207;
						when	OTHERS	=>	setPoint	<=	0;
					END CASE;
					
					IF count = setPoint THEN
						next_bit <= '1';
						count <= 0;
					ELSE
						next_bit <= '0';
					END IF; 
					count <= count + 1;
					
				END IF;
			ELSIF nRST = '0' THEN
				count		<=	0;
				next_bit	<=	'0';
			END IF;
		END PROCESS switch;


end architecture behavioral;

