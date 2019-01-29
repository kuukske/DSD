--
--
-- Digital System Design Assignment UART
--
-- Module: Controller (Receiver) 
-- 
-- Controller_R.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Controller_R is
   port(	BusAck   : in     std_Logic;
			ChrLen   : in     std_logic_vector (1 downto 0);
			Clk      : in     std_logic;
			NxtBit   : in     std_logic;
			ParBit   : in     std_logic;
			ParEnab  : in     std_logic;
			Ser_In   : in     std_Logic;
			SetMode  : in     Std_Logic;
			StopBits : in     std_logic_vector (1 downto 0);
			cts      : in     Std_Logic;
			nRST     : in     std_logic;
			BusRq    : out    Std_Logic;
			ClrBrt   : out    std_logic;
			ClrPar   : out    std_logic;
			EnOut    : out    std_logic;
			Ldm      : out    std_logic;
			Shsi     : out    std_logic;
			SplPar   : out    std_logic;
			dtro     : out    Std_Logic;
			error    : out    std_Logic);

end entity Controller_R;

--
architecture rtl of Controller_R is

begin

	

end architecture rtl;

