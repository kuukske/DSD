--
-- Digital System Design Assignment UART
--
-- Module : Parity Register (Receiver) 
-- 
-- parityreg_R.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity parityreg_R is
   PORT( 
      Clk     : in     	std_logic;
      ClrPar  : in     	std_logic;
      EvenPar : in     	std_logic;
      Ser_In  : in     	Std_Logic;
      SplPar  : in     	std_logic;
      ParBit  : inout	std_logic);
end entity parityreg_R;

--
architecture behavioral of parityreg_R is
begin


end architecture behavioral;

