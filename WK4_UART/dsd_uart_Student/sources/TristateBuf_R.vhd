--
-- Digital System Design Assignment UART
--
-- Module : Tri-State Buffer (Receiver) 
-- 
-- TristaeBuf_R.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TristateBuf_R is
   PORT(	EnOut    : in 	std_logic;
			ShiftReg : in 	std_logic_vector (7 DOWNTO 0);
			dbus     : out	Std_Logic_Vector (7 DOWNTO 0));
end entity TristateBuf_R ;

--
architecture dataflow of TristateBuf_R is
begin
	PROCESS(EnOut, ShiftReg)
		BEGIN
			IF EnOut = '1' THEN
				dbus <= ShiftReg;
			ELSE
				dbus <= "ZZZZZZZZ";
			END IF;
			
		END PROCESS;

end architecture dataflow;


