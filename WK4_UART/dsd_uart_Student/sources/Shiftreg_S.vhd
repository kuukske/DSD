--
-- Digital System Design Assignment UART
--
-- Module : Shift Register (Sender) 
-- 
-- Shiftreg_S.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

entity Shiftreg_S is
   port(	Clk      : in     std_logic;
			d_bus    : in     Std_Logic_Vector (7 DOWNTO 0);
			lds      : in     std_logic;
			sample   : in     std_logic;
			data_bit : out    std_logic);
end entity Shiftreg_S ;


architecture behavioral of Shiftreg_S is
SIGNAL shift_reg  : Std_Logic_Vector(7 DOWNTO 0);

begin
	data_bit <= shift_reg(0);
		PROCESS(Clk)
			BEGIN
				IF rising_edge(Clk) THEN
					IF lds = '1' THEN
						shift_reg <= d_bus;
					ELSIF sample = '1' THEN
						shift_reg <= '0' & shift_reg(7 DOWNTO 1); 
					END IF;
				END IF;
		END PROCESS;

end architecture behavioral;

