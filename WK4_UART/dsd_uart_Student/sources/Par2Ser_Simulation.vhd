-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"
-- CREATED		"Sun Oct 21 20:32:27 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Par2Ser_Simulation IS 
	PORT
	(
		Clk :  IN  STD_LOGIC;
		cnd :  IN  STD_LOGIC;
		dtr :  IN  STD_LOGIC;
		nRST :  IN  STD_LOGIC;
		wr :  IN  STD_LOGIC;
		d_bus :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		ctso :  OUT  STD_LOGIC;
		ntxe :  OUT  STD_LOGIC;
		ser_out :  OUT  STD_LOGIC
	);
END Par2Ser_Simulation;

ARCHITECTURE bdf_type OF Par2Ser_Simulation IS 

COMPONENT baudratetimer_s_simulation
	PORT(Clk : IN STD_LOGIC;
		 nRST : IN STD_LOGIC;
		 Baudrate : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 next_bit : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT controller_s
	PORT(Clk : IN STD_LOGIC;
		 cnd : IN STD_LOGIC;
		 dtr : IN STD_LOGIC;
		 nRST : IN STD_LOGIC;
		 next_bit : IN STD_LOGIC;
		 parity_enab : IN STD_LOGIC;
		 wr : IN STD_LOGIC;
		 Char_len : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 stopbits : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 clear : OUT STD_LOGIC;
		 ctso : OUT STD_LOGIC;
		 ldm : OUT STD_LOGIC;
		 lds : OUT STD_LOGIC;
		 ntxe : OUT STD_LOGIC;
		 sample : OUT STD_LOGIC;
		 sel0 : OUT STD_LOGIC;
		 sel1 : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT parityreg_s
	PORT(Clk : IN STD_LOGIC;
		 clear : IN STD_LOGIC;
		 data_bit : IN STD_LOGIC;
		 even_parity : IN STD_LOGIC;
		 sample : IN STD_LOGIC;
		 parity_bit : INOUT STD_LOGIC
	);
END COMPONENT;

COMPONENT mux_s
	PORT(data_bit : IN STD_LOGIC;
		 parity_bit : IN STD_LOGIC;
		 sel0 : IN STD_LOGIC;
		 sel1 : IN STD_LOGIC;
		 ser_out : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT mode_reg_s
	PORT(Clk : IN STD_LOGIC;
		 ldm : IN STD_LOGIC;
		 d_bus : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 even_parity : OUT STD_LOGIC;
		 parity_enab : OUT STD_LOGIC;
		 Baudrate : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Char_len : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 stopbits : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT shiftreg_s
	PORT(Clk : IN STD_LOGIC;
		 lds : IN STD_LOGIC;
		 sample : IN STD_LOGIC;
		 d_bus : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_bit : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	Baudrate :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	Char_len :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	clear :  STD_LOGIC;
SIGNAL	data_bit :  STD_LOGIC;
SIGNAL	even_parity :  STD_LOGIC;
SIGNAL	ldm :  STD_LOGIC;
SIGNAL	lds :  STD_LOGIC;
SIGNAL	next_bit :  STD_LOGIC;
SIGNAL	parity_bit :  STD_LOGIC;
SIGNAL	parity_enab :  STD_LOGIC;
SIGNAL	sample :  STD_LOGIC;
SIGNAL	sel0 :  STD_LOGIC;
SIGNAL	sel1 :  STD_LOGIC;
SIGNAL	stopbits :  STD_LOGIC_VECTOR(1 DOWNTO 0);


BEGIN 



b2v_BaudrateTimer_S : baudratetimer_s_simulation
PORT MAP(Clk => Clk,
		 nRST => nRST,
		 Baudrate => Baudrate,
		 next_bit => next_bit);


b2v_controller_s : controller_s
PORT MAP(Clk => Clk,
		 cnd => cnd,
		 dtr => dtr,
		 nRST => nRST,
		 next_bit => next_bit,
		 parity_enab => parity_enab,
		 wr => wr,
		 Char_len => Char_len,
		 stopbits => stopbits,
		 clear => clear,
		 ctso => ctso,
		 ldm => ldm,
		 lds => lds,
		 ntxe => ntxe,
		 sample => sample,
		 sel0 => sel0,
		 sel1 => sel1);


b2v_inst4 : parityreg_s
PORT MAP(Clk => Clk,
		 clear => clear,
		 data_bit => data_bit,
		 even_parity => even_parity,
		 sample => sample,
		 parity_bit => parity_bit);


b2v_inst5 : mux_s
PORT MAP(data_bit => data_bit,
		 parity_bit => parity_bit,
		 sel0 => sel0,
		 sel1 => sel1,
		 ser_out => ser_out);


b2v_Mode_Reg_S : mode_reg_s
PORT MAP(Clk => Clk,
		 ldm => ldm,
		 d_bus => d_bus,
		 even_parity => even_parity,
		 parity_enab => parity_enab,
		 Baudrate => Baudrate,
		 Char_len => Char_len,
		 stopbits => stopbits);


b2v_Shiftreg_S : shiftreg_s
PORT MAP(Clk => Clk,
		 lds => lds,
		 sample => sample,
		 d_bus => d_bus,
		 data_bit => data_bit);


END bdf_type;