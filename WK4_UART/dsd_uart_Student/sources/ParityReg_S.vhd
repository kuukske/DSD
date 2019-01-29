--
-- Digital System Design Assignment UART
--
-- Module : Parity Register (Sender) 
-- 
-- ParityReg_S.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ParityReg_S is
   port( Clk         : in     std_logic;
			clear       : in     std_logic;
			data_bit    : in     std_logic;
			even_parity : in     std_logic;
			sample      : in     std_logic;
			parity_bit  : inout 	std_logic
			);
end entity ParityReg_S ;

--
architecture behavioral of ParityReg_S is

begin
	PROCESS(Clk)
		BEGIN
			IF rising_edge(Clk) THEN
				IF clear = '1' THEN
					parity_bit <= '0';
				ELSIF sample = '1'  THEN
					IF even_parity = '1' THEN
						parity_bit <= parity_bit XOR data_bit;
					ELSE
						parity_bit <= parity_bit XNOR data_bit;
					END IF;
				END IF;
			END IF;
		END PROCESS; 

end architecture behavioral;
