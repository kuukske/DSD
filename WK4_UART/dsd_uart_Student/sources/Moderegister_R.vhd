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
SIGNAL mode_vector	:	Std_Logic_Vector(7 DOWNTO 0);
 
begin
	mode_vector 	<= 	dbus(7 DOWNTO 0);
	StopBits 		<= 	mode_vector(7 DOWNTO 6);
	EvenPar 	<= 	mode_vector(5);
	ParEnab 	<= 	mode_vector(4);
	ChrLen 		<= 	mode_vector(3 DOWNTO 2);
	Baudrate		<= 	mode_vector(1 DOWNTO 0);
	
PROCESS(Clk)
		BEGIN
			IF rising_edge(Clk) THEN
				IF Ldm = '1' THEN
					mode_vector <= dbus(7 DOWNTO 0);
				END IF;
			END IF;
	END PROCESS;

end architecture behavioral;

