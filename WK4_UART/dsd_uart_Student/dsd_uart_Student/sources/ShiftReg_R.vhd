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

end architecture behavioral;

