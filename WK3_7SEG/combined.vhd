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
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Mon Dec 03 17:40:54 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY combined IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		up :  IN  STD_LOGIC;
		SEG_A :  OUT  STD_LOGIC;
		SEG_B :  OUT  STD_LOGIC;
		SEG_C :  OUT  STD_LOGIC;
		SEG_D :  OUT  STD_LOGIC;
		SEG_E :  OUT  STD_LOGIC;
		SEG_F :  OUT  STD_LOGIC;
		SEG_G :  OUT  STD_LOGIC
	);
END combined;

ARCHITECTURE bdf_type OF combined IS 

COMPONENT up_down_counter
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 up : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bcd_2_7seg_decoder
	PORT(STATE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 SEG_A : OUT STD_LOGIC;
		 SEG_B : OUT STD_LOGIC;
		 SEG_C : OUT STD_LOGIC;
		 SEG_D : OUT STD_LOGIC;
		 SEG_E : OUT STD_LOGIC;
		 SEG_F : OUT STD_LOGIC;
		 SEG_G : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	gdfx_temp0 :  STD_LOGIC;
SIGNAL	STATE_SIGNAL :  STD_LOGIC_VECTOR(4 DOWNTO 0);


BEGIN 



b2v_inst : up_down_counter
PORT MAP(clk => clk,
		 nrst => nrst,
		 up => up,
		 q => STATE_SIGNAL);


b2v_inst2 : bcd_2_7seg_decoder
PORT MAP(STATE => STATE_SIGNAL,
		 SEG_A => gdfx_temp0,
		 SEG_B => gdfx_temp0,
		 SEG_C => gdfx_temp0,
		 SEG_D => gdfx_temp0,
		 SEG_E => gdfx_temp0,
		 SEG_F => gdfx_temp0,
		 SEG_G => gdfx_temp0);

SEG_A <= gdfx_temp0;
SEG_B <= gdfx_temp0;
SEG_C <= gdfx_temp0;
SEG_D <= gdfx_temp0;
SEG_E <= gdfx_temp0;
SEG_F <= gdfx_temp0;
SEG_G <= gdfx_temp0;

END bdf_type;