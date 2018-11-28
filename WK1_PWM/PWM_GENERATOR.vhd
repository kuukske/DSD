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
-- CREATED		"Wed Nov 28 10:20:53 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY PWM_GENERATOR IS 
	PORT
	(
		Avail :  IN  STD_LOGIC;
		Init :  IN  STD_LOGIC;
		CLK :  IN  STD_LOGIC;
		NRST :  IN  STD_LOGIC;
		D_in :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		RDY :  OUT  STD_LOGIC;
		VALID :  OUT  STD_LOGIC;
		PWM :  OUT  STD_LOGIC
	);
END PWM_GENERATOR;

ARCHITECTURE bdf_type OF PWM_GENERATOR IS 

COMPONENT load_1
	PORT(clk : IN STD_LOGIC;
		 ld : IN STD_LOGIC;
		 d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT counter
	PORT(clear : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT compare_period
	PORT(cntr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sw_point : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 equal : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT pwm_controller
	PORT(CLK : IN STD_LOGIC;
		 NRST : IN STD_LOGIC;
		 Init : IN STD_LOGIC;
		 Avail : IN STD_LOGIC;
		 Equal : IN STD_LOGIC;
		 Rdy : OUT STD_LOGIC;
		 Valid : OUT STD_LOGIC;
		 Load_1 : OUT STD_LOGIC;
		 Load_2 : OUT STD_LOGIC;
		 Clear_cntr : OUT STD_LOGIC;
		 tri_state_out : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT compare_pwm
	PORT(cntr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sw_point : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PWM : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	cntr_clr :  STD_LOGIC;
SIGNAL	count_vector :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	equal_wire :  STD_LOGIC;
SIGNAL	load_1_wire :  STD_LOGIC;
SIGNAL	load_2_wire :  STD_LOGIC;
SIGNAL	PWM_compare_out :  STD_LOGIC;
SIGNAL	reg_1_data :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	reg_2_data :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	tri_state_wire :  STD_LOGIC;


BEGIN 



b2v_inst : load_1
PORT MAP(clk => CLK,
		 ld => load_1_wire,
		 d => D_in,
		 q => reg_1_data);


b2v_inst1 : counter
PORT MAP(clear => cntr_clr,
		 clk => CLK,
		 nrst => NRST,
		 q => count_vector);


b2v_inst10 : compare_period
PORT MAP(cntr => count_vector,
		 sw_point => reg_2_data,
		 equal => equal_wire);


b2v_inst12 : pwm_controller
PORT MAP(CLK => CLK,
		 NRST => NRST,
		 Init => Init,
		 Avail => Avail,
		 Equal => equal_wire,
		 Rdy => RDY,
		 Valid => VALID,
		 Load_1 => load_1_wire,
		 Load_2 => load_2_wire,
		 Clear_cntr => cntr_clr,
		 tri_state_out => tri_state_wire);


PROCESS(PWM_compare_out,tri_state_wire)
BEGIN
if (tri_state_wire = '1') THEN
	PWM <= PWM_compare_out;
ELSE
	PWM <= 'Z';
END IF;
END PROCESS;


b2v_inst6 : load_1
PORT MAP(clk => CLK,
		 ld => load_2_wire,
		 d => D_in,
		 q => reg_2_data);


b2v_inst8 : compare_pwm
PORT MAP(cntr => count_vector,
		 sw_point => reg_1_data,
		 PWM => PWM_compare_out);


END bdf_type;