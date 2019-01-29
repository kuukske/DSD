--
-- Digital System Design Assignment UART
--
-- Module : Shift Register (Receiver) 
-- 
-- ShiftReg_R.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftReg_R is
   port(	ChrLen   : in     std_logic_vector (1 downto 0);
			Clk      : in     std_logic;
			Ser_In   : in     Std_Logic;
			ShiftReg : inout  std_logic_vector (7 downto 0);
			Shsi     : in     std_logic);
end entity ShiftReg_R ;

--
architecture behavioral of ShiftReg_R is
begin
PROCESS(Clk)
	BEGIN
		IF rising_edge(Clk) THEN
			IF Shsi = '1' THEN
				CASE ChrLen	IS
					WHEN "00"	=>	ShiftReg <= "000" & Ser_In & ShiftReg(4 DOWNTO 1);
					WHEN "01"	=> 	ShiftReg <= "00" &	Ser_In & ShiftReg(5 DOWNTO 1); 
					WHEN "10"	=> 	ShiftReg <= "0"	& Ser_In & ShiftReg(6 DOWNTO 1);
					WHEN "11"	=> 	ShiftReg <= Ser_In & ShiftReg(7 DOWNTO 1);
					WHEN OTHERS	=>	ShiftReg <= "XXXXXXXX"; 
				END CASE; 
			END IF;
		END IF; 
	END PROCESS;
end architecture behavioral;

