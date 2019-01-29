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
			parity_bit  : inout 	std_logic);
end entity ParityReg_S ;

--
architecture behavioral of ParityReg_S is

SIGNAL temp_parity	:	STD_LOGIC;

begin
parity_bit <= temp_parity;
	PROCESS
		BEGIN
			IF rising_edge(Clk) THEN
				IF clear = '0'
					IF sample = '1' THEN
						IF data_bit = '1' THEN
							temp_parity <= NOT temp_parity;
								IF even_parity = '0' THEN
									temp_parity <= NOT temp_parity;
								END IF;
						END IF;
					END IF;
				ELSE 
					temp_parity <= '0';
				END IF;
			END IF;
	END PROCESS; 

end architecture behavioral;
