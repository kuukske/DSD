--
--
-- Digital System Design Assignment UART
--
-- Module :Controller (Sender) 
-- 
-- Controller_S.vhd
--          
--	
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Controller_S is
   port(	Char_len    : in     std_logic_vector (1 DOWNTO 0);
			Clk         : in     std_logic;
			cnd         : in     Std_Logic;
			dtr         : in     Std_Logic;
			nRST        : in     std_logic;
			next_bit    : in     std_logic;
			parity_enab : in     std_logic;
			stopbits    : in     std_logic_vector (1 DOWNTO 0);
			wr          : in     Std_Logic;
			clear       : out    std_logic;
			ctso        : out    Std_Logic;
			ldm         : out    std_logic;
			lds         : out    std_logic;
			ntxe        : out    Std_Logic;
			sample      : out    std_logic;
			sel0        : out    std_logic;
			sel1        : out    std_logic);

-- Declarations

end Controller_S ;

architecture rtl of Controller_S is
	type state is (	start,
							ld_mode0,
							ld_mode1,
							ld_mode2,
							ld_data0,
							ld_data1,
							ld_data2,
							clear_par,
							wait_dtr,
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
							tran_end1,
							tran_end0,
							err_state);
	signal present_state	:	state;
	signal next_state		:	state;
	signal sel				:	std_logic_vector(1 downto 0);
begin

	sel0 <= sel(0);
	sel1 <= sel(1);

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
	nsd_com	:	process (present_state, cnd, Char_len, dtr, next_bit, parity_enab, stopbits, wr) is
	begin
		case present_state is
		
			when start =>
				if (cnd = '1') then
					next_state <= ld_mode0;
				else
					next_state <= start;
				end if;
			
			when ld_mode0 =>
				if (wr = '1') then
					next_state <= ld_mode1;
				else
					next_state <= ld_mode0;
				end if;
				
			when ld_mode1 =>
				next_state <= ld_mode2;
				
			when ld_mode2 =>
				if (wr = '0') then
					next_state <= ld_data0;
				else
					next_state <= ld_mode2;
				end if;	
			
			when ld_data0 =>
				if (wr = '1') then
					if (cnd = '1') then
						next_state <= ld_mode1;
					else
						next_state <= ld_data1;
					end if;
				else
					next_state <= ld_data0;
				end if;
				
			when ld_data1 =>
				next_state <= ld_data2;
				
			when ld_data2 =>
				if (wr = '0') then
					case parity_enab is
						when '0' =>
							next_state <= wait_dtr;
						when '1' =>
							next_state <= clear_par;
						when others =>
							next_state <= err_state;
					end case;
				else
					next_state <= ld_data2;
				end if;
				
			when clear_par =>
				next_state <= wait_dtr;
				
			when wait_dtr =>
				if (dtr = '1') then
					if (next_bit = '1') then
						next_state <= start_bit;
					else
						next_state <= wait_dtr;
					end if;	
				else
					next_state <= wait_dtr;
				end if;
			
			when start_bit =>
				if (next_bit = '1') then
					case Char_len is
						when "11" =>
							next_state <= data_bit7;
						when "10" =>
							next_state <= data_bit6;
						when "01" =>
							next_state <= data_bit5;
						when "00" =>
							next_state <= data_bit4;
						when others =>
							next_state <= err_state;
					end case;
				else
					next_state <= start_bit;
				end if;
				
			when data_bit7 =>
				if (next_bit = '1') then
					next_state <= data_bit6;
				else
					next_state <= data_bit7;
				end if;
			
			when data_bit6 =>
				if (next_bit = '1') then
					next_state <= data_bit5;
				else
					next_state <= data_bit6;
				end if;
			
			when data_bit5 =>
				if (next_bit = '1') then
					next_state <= data_bit4;
				else
					next_state <= data_bit5;
				end if;
				
			when data_bit4 =>
				if (next_bit = '1') then
					next_state <= data_bit3;
				else
					next_state <= data_bit4;
				end if;
				
			when data_bit3 =>
				if (next_bit = '1') then
					next_state <= data_bit2;
				else
					next_state <= data_bit3;
				end if;
				
			when data_bit2 =>
				if (next_bit = '1') then
					next_state <= data_bit1;
				else
					next_state <= data_bit2;
				end if;
				
			when data_bit1 =>
				if (next_bit = '1') then
					next_state <= data_bit0;
				else
					next_state <= data_bit1;
				end if;
				
			when data_bit0 =>
				if (next_bit = '1') then
					if (parity_enab = '1') then
						next_state <= par_bit;
					elsif (parity_enab = '0') then
						case stopbits is
							when "11" =>
								next_state <= stop_bit2;
							when "10" =>
								next_state <= stop_bit1;
							when "01" =>
								next_state <= stop_bit0;
							when "00" =>
								next_state <= tran_end0;
							when others =>
								next_state <= err_state;
						end case;
					else
						next_state <= err_state;
					end if;
								
				else
					next_state <= data_bit0;
				end if;
			
			when par_bit =>
				if (next_bit = '1') then
					case stopbits is
						when "11" =>
							next_state <= stop_bit2;
						when "10" =>
							next_state <= stop_bit1;
						when "01" =>
							next_state <= stop_bit0;
						when "00" =>
							next_state <= tran_end0;
						when others =>
							next_state <= err_state;
					end case;
				else
					next_state <= par_bit;
				end if;
				
			when stop_bit2 =>
				if (next_bit = '1') then
					next_state <= stop_bit1;
				 else
					next_state <= stop_bit2;
				end if;
				
			when stop_bit1 =>
				if (next_bit = '1') then
					next_state <= stop_bit0;
				else
					next_state <= stop_bit1;
				end if;
				
			when stop_bit0 =>
				if (next_bit = '1') then
					next_state <= tran_end0;
				else
					next_state <= stop_bit0;
				end if;
				
			when tran_end0 =>
				next_state <= tran_end1;
				
			when tran_end1 =>
				if (dtr = '0') then
					next_state <= ld_data0;
				else
					next_state <= tran_end1;
				end if;
				
			when err_state =>
				next_state <= err_state;
				
		end case;
	end process nsd_com;
	
	--output decoder (combinational block)
	od_com : process (present_state, next_bit) is
	begin
		--default values
		clear 	<= '0';
		ctso 		<= '0';
		ldm 		<= '0';
		lds		<= '0';
		ntxe 		<= '0';
		sample 	<= '0';
		sel 		<= "00";
		
		case present_state is
		
			when start =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '0';
				sample 	<= '0';
				sel 		<= "00";
				
			when ld_mode0 =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '0';
				sample 	<= '0';
				sel 		<= "00";
				
			when ld_mode1 =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm 		<= '1';
				lds 		<= '0';
				ntxe 		<= '0';
				sample 	<= '0';
				sel 		<= "00";
				
			when ld_mode2 =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "00";
				
			when ld_data0 =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm		<= '0';
				lds 		<= '0';
				ntxe 		<= '0';
				sample 	<= '0';
				sel 		<= "00";
				
			when ld_data1 =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm 		<= '0';
				lds 		<= '1';
				ntxe 		<= '0';
				sample 	<= '0';
				sel 		<= "00";
				
			when ld_data2 =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "00";
				
			when clear_par =>
				clear 	<= '1';
				ctso 		<= '0';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "00";
				
			when wait_dtr =>
				clear 	<= '0';
				ctso 		<= '1';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "00";
				
			when start_bit =>
				clear 	<= '0';
				ctso 		<= '1';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "11";
				
			when data_bit7 =>
				if (next_bit = '1') then
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '1';
					sel 		<= "01";
				else
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '0';
					sel 		<= "01";
				end if;
				
				
			when data_bit6 =>
				if (next_bit = '1') then
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '1';
					sel 		<= "01";
				else
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '0';
					sel 		<= "01";
				end if;
				
			when data_bit5 =>
				if (next_bit = '1') then
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '1';
					sel 		<= "01";
				else
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '0';
					sel 		<= "01";
				end if;
				
			when data_bit4 =>
				if (next_bit = '1') then
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '1';
					sel 		<= "01";
				else
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '0';
					sel 		<= "01";
				end if;
				
			when data_bit3 =>
				if (next_bit = '1') then
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '1';
					sel 		<= "01";
				else
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '0';
					sel 		<= "01";
				end if;
				
			when data_bit2 =>
				if (next_bit = '1') then
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '1';
					sel 		<= "01";
				else
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '0';
					sel 		<= "01";
				end if;
				
			when data_bit1 =>
				if (next_bit = '1') then
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '1';
					sel 		<= "01";
				else
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '0';
					sel 		<= "01";
				end if;
				
			when data_bit0 =>
				if (next_bit = '1') then
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '1';
					sel 		<= "01";
				else
					clear 	<= '0';
					ctso 		<= '1';
					ldm 		<= '0';
					lds 		<= '0';
					ntxe 		<= '1';
					sample 	<= '0';
					sel 		<= "01";
				end if;
				
			when par_bit =>
				clear 	<= '0';
				ctso 		<= '1';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "10";
				
			when stop_bit2 =>
				clear 	<= '0';
				ctso 		<= '1';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "11";
				
			when stop_bit1 =>
				clear 	<= '0';
				ctso 		<= '1';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "11";
				
			when stop_bit0 =>
				clear 	<= '0';
				ctso 		<= '1';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "11";
				
			when tran_end0 =>
				clear 	<= '0';
				ctso 		<= '1';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "00";
				
			when tran_end1 =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '1';
				sample 	<= '0';
				sel 		<= "00";
				
			when err_state =>
				clear 	<= '0';
				ctso 		<= '0';
				ldm 		<= '0';
				lds 		<= '0';
				ntxe 		<= '0';
				sample 	<= '0';
				sel 		<= "00";
		end case;
	end process od_com;
end architecture rtl;
