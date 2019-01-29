--
--
-- Digital System Design Assignment UART
--
-- Module : Baudrate Timer for Simulation (Receiver) 
-- 
-- BaudrateTimer_R_Simulation.vhd
--          
--	
-- 
--Adapted for Simulation frequency 500 kHz.
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BaudrateTimer_R_Simulation is
   port(	Baudrate : IN		std_logic_vector (1 downto 0);
			Clk      : IN 		std_logic;
			ClrBrt   : IN 		std_logic;
			NxtBit   : OUT		std_logic);
end entity BaudrateTimer_R_Simulation;

--
architecture behavioral of BaudrateTimer_R_Simulation is
SIGNAL setPoint	:	integer range 0 to 1666		:= 0;
SIGNAL countVal	:	integer range 0 to 1666		:= 0;
SIGNAL turnOver	:	integer range 0 to 833		:= 0;

begin
	PROCESS(Clk, ClrBrt, countVal)
		BEGIN
		
		IF rising_edge(Clk) THEN
			IF ClrBrt = '0' THEN
				CASE Baudrate IS
					WHEN "00"	=>
						setPoint <= 1665;
						turnOver <= setPoint/2;
					WHEN "01" =>
						setPoint <= 832;
						turnOver <= setPoint/2;
					WHEN "10"	=>
						setPoint <= 415;
						turnOver <= setPoint/2;
					WHEN "11" => 
						setPoint <=  207;
						turnOver <= setPoint/2;
					WHEN others => NULL;
				END CASE; 
				
				IF countVal = turnOver THEN
					NxtBit <= '1';
					countVal <= countVal + 1;
				ELSIF countVal = setPoint THEN
					countVal <= 0;
					NxtBit <= '0';
				ELSE
					NxtBit <= '0';
					countVal <= countVal +1;
				END IF;
			END IF;
		END IF;
			
		IF countVal = 1666 THEN
					countVal <= 0;
				END IF;
		END PROCESS;


end architecture behavioral;

