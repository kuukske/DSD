--
--
-- Digital System Design Assignment UART
--
-- Module : Multiplexer (Sender) 
-- 
-- Mux_S.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux_S is
   port(	data_bit   : in     std_logic;
			parity_bit : in     std_logic;
			sel0       : in     std_logic;
			sel1       : in     std_logic;
			ser_out    : out    Std_Logic);
end entity Mux_S ;

--
architecture dataflow OF Mux_S IS
--  In this design
--  sel0 sel1
--   0    0      => 1
--   0    1      => data_bit
--   1    0      => parity_bit
--   1    1      => 0
	signal sel : std_logic_vector(1 downto 0);
  
begin
sel <= sel0 & sel1;

	PROCESS(data_bit, parity_bit, sel0, sel1)
		BEGIN
			CASE sel IS
			
			WHEN	"00"	=>	ser_out	<=	'1';
			WHEN	"01"	=>	ser_out	<=	data_bit;
			WHEN	"10"	=>	ser_out	<=	parity_bit;
			WHEN	"11"	=>	ser_out	<=	'0';
			WHEN	OTHERS	=>	ser_out <=	'X';
			
			END CASE;
		END PROCESS;


end architecture dataflow;

