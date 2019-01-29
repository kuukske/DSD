-- Digital System Design Assignment UART
--
-- Module: UART test bench 
-- 
-- tb_dsd_uart_simulation.vhd
--          
--	Author: Bhonwal, S (2223440) 23-October-2018

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity tb_dsd_uart_simulation is
end entity tb_dsd_uart_simulation;

architecture test_bench of tb_dsd_uart_simulation is

	constant CLOCK_PERIOD : time := 2000 ns;

	--Sim finished signal to end clock generation
	signal sim_finished : boolean := FALSE;
	
	--Error found signal
	signal error_found : boolean := FALSE;
	
	type even_parity_t is (ODD,EVEN);
	type parity_enable_t is (DISABLE,ENABLE);
	
	signal test_name 			: string(1 to 50);
	signal denote2_sender 	: string(1 to 50);
	signal denote3_sender	: string(1 to 50);
	signal denote4_sender	: string(1 to 50);
	signal denote2_receiver : string(1 to 50);
	signal denote3_receiver	: string(1 to 50);
	signal denote4_receiver	: string(1 to 50);
	
	--DSD_UART_Simualtion ports
	signal Clk_sender		:	STD_LOGIC;
	signal Clk_receiver	:	STD_LOGIC;
	signal cnd 				:  STD_LOGIC;
	signal wr 				:  STD_LOGIC;
	signal nRST 			:  STD_LOGIC;
	signal BusAck 			:  STD_LOGIC;
	signal SetMode 		:  STD_LOGIC;
	signal dbus_send 		:  STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal dbus_rec		:  STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal ntxe 			:  STD_LOGIC;
	signal BusRq 			:  STD_LOGIC;
	signal error_1			:  STD_LOGIC;

begin

	--Instantiate DUT
	dut : entity work.DSD_UART_Simulation
	
	port map(	Clk_sender		=> Clk_sender,
					Clk_receiver	=> Clk_receiver,
					cnd 				=> cnd,
					wr 				=>	wr,
					nRST 				=>	nRST,
					BusAck 			=>	BusAck,
					SetMode			=> SetMode,
					dbus_send 		=> dbus_send,
					dbus_rec 		=> dbus_rec,
					ntxe 				=> ntxe,
					BusRq				=> BusRq,
					error 			=> error_1);
					
	clk_gen_sender : process is
		variable seed1, seed2 : INTEGER := 42;
		variable rnd : REAL;
	begin
		if (NOT sim_finished) then
			Clk_Sender <= '0';
			uniform(seed1, seed2, rnd);
			wait for (CLOCK_PERIOD / 2) + ((rnd - 0.5)*real(400))*NS;
			Clk_sender <= '1';
			uniform(seed1, seed2, rnd);
			wait for (CLOCK_PERIOD / 2) + ((rnd - 0.5)*real(400))*NS;
		else
			wait;
		end if;
	end process clk_gen_sender;
	
	clk_gen_receiver : process
	begin
		if (NOT sim_finished) then
			Clk_receiver <= '1';
			wait for CLOCK_PERIOD / 2;
			Clk_receiver <= '0';
			wait for CLOCK_PERIOD / 2;
		else
			wait;
		end if;
	end process clk_gen_receiver;
	
					
	--Simulation DSD_UART complex sequential system
	simulation : process
		
		procedure async_LOW_active_reset is
		begin
			wait until rising_edge(Clk_receiver);
			wait for CLOCK_PERIOD / 4;
			nRST <= '0';
			wait for CLOCK_PERIOD / 2;
			nRST <= '1';
		end procedure async_LOW_active_reset;
		
		
		--Procedure for testing the test vectors against the results from DUT
		procedure error_check(	constant result		:	in	std_logic_vector(7 downto 0);
										constant result_exp	:	in std_logic_vector(7 downto 0)) is
			variable res		:	natural	:= 0;
			variable res_exp	:	natural	:= 0;
		begin
			res 		:= to_integer(unsigned(result));
			res_exp 	:= to_integer(unsigned(result_exp));
			
			assert res = res_exp	
			report 	"Unexpected result. Test error Test vector: " & 
						integer'image(res) & 
						" does not match received data: " & 
						integer'image(res_exp)	
						severity error;
			
			assert res /= res_exp
			report	"Test Passed, Test vector: " &
						integer'image(res) &
						" does matches received data: " &
						integer'image(res_exp)
						severity note;
			
			if (res /= res_exp) then
				error_found <= true;
			end if;
		end procedure error_check;
		
		--Procedure test UART
		procedure test_uart(	constant	stop_bits	:	natural;
									constant even_parity	:	even_parity_t;
									constant parity_enab	:	parity_enable_t;
									constant char_length	:	natural;
									constant baud_rate	:	natural;
									constant test_data	:	std_logic_vector(7 downto 0)) is
			variable mode_reg		:	std_logic_vector(7 downto 0);
			variable rec_data		:	std_logic_vector(7 downto 0);
			variable test_vector	:	std_logic_vector(7 downto 0);
		begin
			--Mode register initialization
			case stop_bits is
				when 0 =>
					mode_reg(7 downto 6) := "00";
				when 1 =>
					mode_reg(7 downto 6) := "01";
				when 2 =>
					mode_reg(7 downto 6) := "10";
				when 3 =>
					mode_reg(7 downto 6) := "11";
				when others =>
					report "Mode register test vecrtor error at stop bits";
			end case;
					
			case even_parity is
				when ODD =>
					mode_reg(5) := '0';
				when EVEN =>
					mode_reg(5) := '1';
			end case;
					
			case parity_enab is
				when DISABLE =>
					mode_reg(4) := '0';
				when ENABLE =>
					mode_reg(4) := '1';
			end case;
			
			case char_length is
				when 5 =>
					mode_reg(3 downto 2) := "00";
					test_vector := "000" & test_data(4 downto 0); 
				when 6 =>
					mode_reg(3 downto 2) := "01";
					test_vector := "00" & test_data(5 downto 0); 
				when 7 =>
					mode_reg(3 downto 2) := "10";
					test_vector := "0" & test_data(6 downto 0);
				when 8 =>
					mode_reg(3 downto 2) := "11";
					test_vector := test_data(7 downto 0);
				when others=>
					report "Mode register test vector error at character length";
			end case;
					
			case baud_rate is
				when 300 =>
					mode_reg(1 downto 0) := "00";
				when 600 =>
					mode_reg(1 downto 0) := "01";
				when 1200 =>
					mode_reg(1 downto 0) := "10";
				when 2400 =>
					mode_reg(1 downto 0) := "11";
				when others =>
					report "Mode register test vector error at Baud Rate";
			end case;
				
			--Send mode register data to sender
			denote2_sender		<= "Sender Mode word handshake                        ";
			
			wait until rising_edge(Clk_Sender);
			cnd <= '1';
			wr <= '1';
			dbus_send <= mode_reg;
			denote3_sender 	<= "Mode wrd data on dbus_send, assert cnd and wr HIGH";
			denote4_sender 	<= "Waiting on ntxe HIGH                              ";
			wait until ntxe = '1';
			denote4_sender 	<= "ntxe HIGH received                                ";
			wait until rising_edge(Clk_sender);
			cnd <= '0';
			wr <= '0';
			denote3_sender 	<= "Assert cnd and wr LOW                             ";
			denote4_sender 	<= "Waiting on ntxe LOW                               ";
			dbus_send <= (others => '0');
			wait until ntxe = '0';
			denote4_sender 	<= "ntxe LOW received                                 ";
			denote2_sender 	<= "Sender Mode word handshake complete               ";
			
			--Send mode register data to receiver
			denote2_receiver	<= "Receiver Mode word handshake                      ";
			wait until rising_edge(Clk_receiver);
			denote3_receiver	<= "Assert SetMode HIGH                               ";
			denote4_receiver	<= "Waiting on BusRq HIGH                             ";
			SetMode <= '1';
			wait until BusRq = '1';
			denote4_receiver	<= "BusRq HIGH received                               ";
			wait until rising_edge(Clk_receiver);
			SetMode <= '0';
			BusAck <= '1';
			dbus_rec <= mode_reg;
			denote3_receiver	<= "Assert SetMode LOW BusAck HIGH, mode wrd dara_rec ";
			denote4_receiver	<= "Waiting on BusRq LOW                              ";
			wait until BusRq = '0';
			denote4_receiver	<= "BusRq LOW received                                ";
			wait until rising_edge(Clk_receiver);
			BusAck <= '0';
			denote3_receiver	<= "Assert BusAck LOW                                 ";
			denote2_receiver	<= "Receiver Mode word handshake completed            ";
			dbus_rec <= (others => 'Z');
			wait for CLOCK_PERIOD;
			denote2_receiver	<= "Receiver data parallel out handshake              ";
			denote3_receiver	<= "                                                  ";
			denote4_receiver  <= "Waiting on BusRq HIGH                             ";
			
			
			--Send Test data to sender
			denote2_sender		<= "Sender data word handshake                        ";
			wait until rising_edge(Clk_sender);
			wr <= '1';
			dbus_send <= test_data;
			denote3_sender 	<= "data wrd data on dbus_send, assert wr HIGH        ";
			denote4_sender 	<= "Waiting on ntxe HIGH                              ";
			wait until ntxe = '1';
			denote4_sender 	<= "ntxe HIGH received                                ";
			wait until rising_edge(Clk_sender);
			wr <= '0';
			dbus_send <= (others => '0');
			denote3_sender 	<= "Assert and wr LOW                                 ";
			denote4_sender 	<= "Waiting on ntxe LOW                               ";
			wait until ntxe = '0';
			denote4_sender 	<= "ntxe LOW received                                 ";
			denote2_sender 	<= "Sender data word handshake complete               ";
			
			--Receive data from receiver
			denote2_receiver	<= "Receiver data parallel out handshake              ";
			denote3_receiver	<= "                                                  ";
			if BusRq /= '1' then
				wait until BusRq = '1';
			end if;
			
			denote4_receiver  <= "BusRq HIGH recieved                               ";

			wait until rising_edge(Clk_receiver);
			BusAck <= '1';
			denote3_receiver  <= "Asserting BusAck HIGH                             ";
			denote4_receiver  <= "Waiting on BusRq LOW                              ";
			wait until BusRq = '0';
			denote4_receiver  <= "BusRq LOW  recieved                               ";
			--wait for 10000 ns;
			wait until rising_edge(Clk_receiver);
			rec_data := dbus_rec;
			BusAck <= '0';
			denote3_receiver  <= "Asserting BusAck LOW                              ";
			denote2_receiver	<= "Receiver data parallel out handshake complete     ";
			wait for CLOCK_PERIOD;
			
			error_check(test_vector,rec_data);
			
		end procedure test_uart;
		
	begin
		--default value
		cnd 			<= '0';
		wr 			<=	'0';
		nRST 			<=	'1';
		BusAck 		<=	'0';
		SetMode		<= '0';
		dbus_send 	<= (others => '0');
		dbus_rec		<= (others => 'Z');
		
		test_name 			<= "Test1: 8 bits data no parity and no stop bits     ";
		report "Running Test1: 8 bits data no parity and no stop bits";
		denote2_sender 	<= "                                                  ";
		denote3_sender 	<= "                                                  ";
		denote4_sender 	<= "                                                  ";
		denote2_receiver 	<= "                                                  ";
		denote3_receiver 	<= "                                                  ";
		denote4_receiver	<= "                                                  ";
		
		wait for CLOCK_PERIOD;
		
		async_LOW_active_reset;
		
		test_uart(0,EVEN,DISABLE,8,2400,"10101111");
		
		test_name 			<= "Test2: 8 bits data even parity and no stop bits   ";
		report "\n\rRunning Test2: 8 bits data even parity and no stop bits";
		test_uart(0,EVEN,ENABLE,8,2400,"10101111");
		
		test_name 			<= "Test3: 6 bits data odd parity and 1 stop bit      ";
		report "Running Test3: 6 bits data odd parity and 1 stop bit";
		test_uart(1,ODD,ENABLE,6,2400,"10101111");
		
		test_name 			<= "Test4: 6 bits data even parity and 2 stop bits    ";
		report "Running Test4: 6 bits data even parity and 2 stop bits";
		test_uart(2,EVEN,ENABLE,6,2400,"10101111");
		
		test_name 			<= "Test5: 5 bits data even parity and 3 stop bits    ";
		report "Running Test5: 5 bits data even parity and 3 stop bits";
		test_uart(3,EVEN,ENABLE,5,2400,"10101111");
		
		test_name 			<= "Test6: 8 bits data odd parity and 3 stop bits     ";
		report "Running Test6: 8 bits data odd parity and 3 stop bits";
		test_uart(3,ODD,ENABLE,8,2400,"10101111");
		
		test_name 			<= "Test7: 8 bits data no parity and 2 stop bits      ";
		report "Running Test7: 8 bits data no parity and 2 stop bits";
		test_uart(2,ODD,DISABLE,8,2400,"10101111");
		
		test_name 			<= "Test8: 7 bits data no parity and 2 stop bits      ";
		report "Running Test8: 7 bits data no parity and 2 stop bits";
		test_uart(2,ODD,DISABLE,7,2400,"10101111");
		
		test_name 			<= "Test9: 7 bits data no parity and 2 stop bits 1200 ";
		report "Running Test9: 7 bits data no parity and 2 stop bits 1200";
		test_uart(2,ODD,DISABLE,7,1200,"10101111");
		
		test_name 			<= "Test11: 5 bits data evenparity and 3 stop bits 600";
		report "Running Test11: 5 bits data evenparity and 3 stop bits 600";
		test_uart(3,EVEN,ENABLE,5,600,"10101111");
	
		test_name 			<= "Test12: 6 bits data odd parity and 2 stop bits 300";
		report "Running Test12: 6 bits data odd parity and 2 stop bits 300";
		test_uart(2,ODD,ENABLE,6,300,"10101111");
		
		test_name 			<= "Test14: 8bits data evenparity and 3 stop bits 2400";
		report "Running Test14: 8bits data evenparity and 3 stop bits 2400";
		test_uart(3,EVEN,ENABLE,8,2400,"10101111");
		
		test_name 			<= "Test15: 5 bits data odd parity and 3 stop bits 300";
		report "Running Test15: 5 bits data odd parity and 3 stop bits 300";
		test_uart(3,ODD,ENABLE,5,300,"10101111");
		
		
		
		if not error_found then
			report "No Errors found, UART all tests passed!";
		else
			report "Errors found, UART one or more test failed!";
		end if;
		
			
		sim_finished <= true;
		wait;
	end process simulation;
end architecture test_bench;