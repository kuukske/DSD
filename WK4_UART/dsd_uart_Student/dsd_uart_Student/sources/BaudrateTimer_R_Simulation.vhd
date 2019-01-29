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
	signal sync_pulse : std_logic;
	signal count		: std_logic_vector(3 downto 0);
begin

end architecture behavioral;

