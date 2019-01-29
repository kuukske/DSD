--
--
-- Digital System Design Assignment UART
--
-- Module : Mode Register (Sender) 
-- 
-- Mode_Reg_S.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mode_Reg_S is
   port(	Clk         : in     std_logic;
			d_bus       : in     std_Logic_vector (7 DOWNTO 0);
			ldm         : in     std_logic;
			Baudrate    : out    std_logic_vector (1 DOWNTO 0);
			Char_len    : out    std_logic_vector (1 DOWNTO 0);
			even_parity : out    std_logic;
			parity_enab : out    std_logic;
			stopbits    : out    std_logic_vector (1 DOWNTO 0));
end entity Mode_Reg_S;

--
architecture behavioral of Mode_Reg_S is
--   MSB .......................................................LSB  
--   XX         X             X               XX                 XX
--   stopbits   even_parity   parity_enable   character_length   baudrate
begin

	process(clk)
	begin
		
		if rising_edge(clk) then
		
			if (ldm = '1') then
				stopbits 	<= d_bus(7 downto 6);
				even_parity <= d_bus(5);
				parity_enab <= d_bus(4);
				Char_len 	<= d_bus(3 downto 2);
				Baudrate 	<= d_bus(1 downto 0); 
				
			else
				null;
			 
			end if;
		else
			null;
		end if;
	end process;
end architecture behavioral;