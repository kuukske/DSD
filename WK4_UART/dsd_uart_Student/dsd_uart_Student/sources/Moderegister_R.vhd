--
--
-- Digital System Design Assignment UART
--
-- Module : Mode Register (Receiver) 
-- 
-- Moderegister_R.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Moderegister_R is
   port(	Clk      : in     std_logic;
			Ldm      : in     std_logic;
			Baudrate : out    std_logic_vector (1 downto 0);
			ChrLen   : out    std_logic_vector (1 downto 0);
			EvenPar  : out    std_logic;
			ParEnab  : out    std_logic;
			StopBits : out    std_logic_vector (1 downto 0);
			dbus     : in  	std_logic_vector (7 downto 0));
end entity Moderegister_R ;

--
architecture behavioral of Moderegister_R is
  
--   MSB .......................................................LSB  
--   XX         X             X               XX                 XX
--   stopbits   even_parity   parity_enable   character_length   baudrate
  
begin

end architecture behavioral;

