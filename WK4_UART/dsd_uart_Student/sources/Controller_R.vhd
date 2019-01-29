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
	type state is (	start,
							ld_mode0,
							ld_mode1,
							ld_mode2,
							ld_mode3,
							tran_start,
							start_bit,
							data_bit7,
							data_bit6,
							data_bit5,
							data_bit4,
							data_bit3,
							data_bit2,
							data_bit1,
							data_bit0,
							par_bit,
							stop_bit2,
							stop_bit1,
							stop_bit0,
							tran_end,
							data_prll0,
							data_prll1,
							data_prll2,
							err_state);
	signal present_state	:	state;
	signal next_state		:	state;
begin

	--memory (state regiter) (sequential block)
	mem_seq	:	process (Clk, nRST) is
	begin
		if (nRST = '0') then
			present_state <= start;
		elsif rising_edge(clk) then
			present_state <= next_state;
		end if;
	end process mem_seq;
	
	--next state decoder (combinational block)
	nsd_com	:	process (present_state, BusAck, ChrLen, NxtBit, ParBit, ParEnab, Ser_In, SetMode, StopBits, cts) is
	begin
		case present_state is
		
			when start =>
				if (SetMode = '1') then
					next_state <= ld_mode0;
				else
					next_state <= start;
				end if;
			
			when ld_mode0 =>
				if (BusAck = '1') then
					next_state <= ld_mode1;
				else
					next_state <= ld_mode0;
				end if;
				
			when ld_mode1 =>
				next_state <= ld_mode2;
				
			when ld_mode2 =>
				if (BusAck = '0') then
					next_state <= ld_mode3;
				else
					next_state <= ld_mode2;
				end if;
			
			when ld_mode3 =>
				case SetMode is
					when '1' => 
						next_state <= ld_mode0;
					when '0' =>
						if(cts = '1') then
							next_state <= tran_start;
						else
							next_state <= ld_mode3;
						end if;
					when others =>
						next_state <= err_state;
				end case;
			
			when tran_start =>
				if (Ser_In = '0') then
					next_state <= start_bit;
				else
					next_state <= tran_start;
				end if;
				
			when start_bit =>
				if (NxtBit = '1') then
					case ChrLen is
						when "00" =>
							next_state <= data_bit4;
						when "01" =>
							next_state <= data_bit5;
						when "10" =>
							next_state <= data_bit6;
						when "11" =>
							next_state <= data_bit7;
						when others =>
							next_state <= err_state;
					end case;
				else
					next_state <= start_bit;
				end if;
				
			when data_bit7 =>
				if (NxtBit = '1') then
					next_state <= data_bit6;
				else
					next_state <= data_bit7;
				end if;
				
			when data_bit6 =>
				if (NxtBit = '1') then
					next_state <= data_bit5;
				else
					next_state <= data_bit6;
				end if;
					
			when data_bit5 =>
				if (NxtBit = '1') then
					next_state <= data_bit4;
				else
					next_state <= data_bit5;
				end if;
					
			when data_bit4 =>
				if (NxtBit = '1') then
					next_state <= data_bit3;
				else
					next_state <= data_bit4;
				end if;
					
			when data_bit3 =>
				if (NxtBit = '1') then
					next_state <= data_bit2;
				else
					next_state <= data_bit3;
				end if;
					
			when data_bit2 =>
				if (NxtBit = '1') then
					next_state <= data_bit1;
				else
					next_state <= data_bit2;
				end if;
					
			when data_bit1 =>
				if (NxtBit = '1') then
					next_state <= data_bit0;
				else
					next_state <= data_bit1;
				end if;
					
			when data_bit0 =>
				if (NxtBit = '1') then
					if (ParEnab = '0') then
						case StopBits is
							when "00" =>
								next_state <= tran_end;
							when "01" =>
								next_state <= stop_bit0;
							when "10" =>
								next_state <= stop_bit1;
							when "11" =>
								next_state <= stop_bit2;
							when others =>
								next_state <= err_state;
						end case;	
					else
						next_state <= par_bit;
					end if;
				else
					next_state <= data_bit0;
				end if;
				
			when par_bit =>
				if (NxtBit = '1') then
					case ParBit is
						when '0' =>
							if (Ser_In = '0') then
								case StopBits is
									when "00" =>
										next_state <= tran_end;
									when "01" =>
										next_state <= stop_bit0;
									when "10" =>
										next_state <= stop_bit1;
									when "11" =>
										next_state <= stop_bit2;
									when others =>
										next_state <= err_state;
								end case;
							else
								next_state <= err_state;
							end if;
							
						when '1' =>
							if (Ser_In = '1') then
								case StopBits is
									when "00" =>
										next_state <= tran_end;
									when "01" =>
										next_state <= stop_bit0;
									when "10" =>
										next_state <= stop_bit1;
									when "11" =>
										next_state <= stop_bit2;
									when others =>
										next_state <= err_state;
								end case;
							else
								next_state <= err_state;
							end if;
						when others =>
							next_state <= err_state;
					end case;
						
				else
					next_state <= par_bit;
				end if;
				
			when stop_bit2 =>
				if (NxtBit = '1') then
					if (Ser_In = '0') then
						next_state <= stop_bit1;
					else
						next_state <= err_state;
					end if;
				else
					next_state <= stop_bit2;
				end if;
				
			when stop_bit1 =>
				if (NxtBit = '1') then
					if (Ser_In = '0') then
						next_state <= stop_bit0;
					else
						next_state <= err_state;
					end if;
				else
					next_state <= stop_bit1;
				end if;
				
			when stop_bit0 =>
				if (NxtBit = '1') then
					if (Ser_In = '0') then
						next_state <= tran_end;
					else
						next_state <= err_state;
					end if;
				else
					next_state <= stop_bit0;
				end if;
				
			when tran_end =>
				if (NxtBit = '1') then
					if (Ser_In = '1') then
						next_state <= data_prll0;
					else
						next_state <= err_state;
					end if;
				else
					next_state <= tran_end;
				end if;
				
			when data_prll0 =>
				if (cts = '0') then
					next_state <= data_prll1;
				else
					next_state <= data_prll0;
				end if;
				
			when data_prll1 =>
				if (BusAck = '1') then
					next_state <= data_prll2;
				else
					next_state <= data_prll1;
				end if;
			
			when data_prll2 =>
				if (BusAck = '0') then
					next_state <= ld_mode3;
				else
					next_state <= data_prll2;
				end if;
			
			when err_state =>
				next_state <= err_state;
		
		end case;
	end process nsd_com;	
	
	--output decoder (combinational block)
	od_com : process (present_state, NxtBit, Ser_In) is
	begin
		--default values
		BusRq		<= '0';
		ClrBrt	<= '0';
		ClrPar	<=	'0';
		EnOut		<= '0';
		Ldm		<=	'0';
		Shsi		<= '0';
		SplPar	<=	'0';
		dtro		<=	'0';
		error		<=	'0';
		
		case present_state is
			
			when start =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'0';
				error		<=	'0';
				
			when ld_mode0 =>
				BusRq		<= '1';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'0';
				error		<=	'0';
			
			when ld_mode1 =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'1';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'0';
				error		<=	'0';
			
			when ld_mode2 =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'0';
				error		<=	'0';
			
			when ld_mode3 =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'0';
				error		<=	'0';
			
			when tran_start =>
				if (Ser_In = '0') then
					BusRq		<= '0';
					ClrBrt	<= '1';
					ClrPar	<=	'1';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
			
			when start_bit =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'1';
				error		<=	'0';
			
			when data_bit7 =>
				if (NxtBit = '1') then
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '1';
					SplPar	<=	'1';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
				
			when data_bit6 =>
				if (NxtBit = '1') then
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '1';
					SplPar	<=	'1';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
				
			when data_bit5 =>
				if (NxtBit = '1') then
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '1';
					SplPar	<=	'1';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
				
			when data_bit4 =>
				if (NxtBit = '1') then
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '1';
					SplPar	<=	'1';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
				
			when data_bit3 =>
				if (NxtBit = '1') then
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '1';
					SplPar	<=	'1';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
				
			when data_bit2 =>
				if (NxtBit = '1') then
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '1';
					SplPar	<=	'1';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
				
			when data_bit1 =>
				if (NxtBit = '1') then
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '1';
					SplPar	<=	'1';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
				
			when data_bit0 =>
				if (NxtBit = '1') then
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '1';
					SplPar	<=	'1';
					dtro		<=	'1';
					error		<=	'0';
				else
					BusRq		<= '0';
					ClrBrt	<= '0';
					ClrPar	<=	'0';
					EnOut		<= '0';
					Ldm		<=	'0';
					Shsi		<= '0';
					SplPar	<=	'0';
					dtro		<=	'1';
					error		<=	'0';
				end if;
			
			when par_bit =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'1';
				error		<=	'0';
			
			when stop_bit2 =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'1';
				error		<=	'0';
			
			when stop_bit1 =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'1';
				error		<=	'0';
			
			when stop_bit0 =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'1';
				error		<=	'0';
			
			when tran_end =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'1';
				error		<=	'0';
			
			when data_prll0 =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'1';
				error		<=	'0';
			
			when data_prll1 =>
				BusRq		<= '1';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'0';
				error		<=	'0';
			
			when data_prll2 =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '1';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'0';
				error		<=	'0';
			
			when err_state =>
				BusRq		<= '0';
				ClrBrt	<= '0';
				ClrPar	<=	'0';
				EnOut		<= '0';
				Ldm		<=	'0';
				Shsi		<= '0';
				SplPar	<=	'0';
				dtro		<=	'0';
				error		<=	'1';
			
		end case;
		
	end process od_com;

end architecture rtl;

