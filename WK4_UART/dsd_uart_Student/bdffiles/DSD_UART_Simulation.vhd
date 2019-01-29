-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"
-- CREATED		"Tue Dec 11 15:26:33 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY DSD_UART_Simulation IS 
	PORT
	(
		cnd :  IN  STD_LOGIC;
		wr :  IN  STD_LOGIC;
		nRST :  IN  STD_LOGIC;
		BusAck :  IN  STD_LOGIC;
		SetMode :  IN  STD_LOGIC;
		Clk_sender :  IN  STD_LOGIC;
		Clk_receiver :  IN  STD_LOGIC;
		dbus_rec :  INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		dbus_send :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		ntxe :  OUT  STD_LOGIC;
		BusRq :  OUT  STD_LOGIC;
		error :  OUT  STD_LOGIC
	);
END DSD_UART_Simulation;

ARCHITECTURE bdf_type OF DSD_UART_Simulation IS 

COMPONENT ser2par_simulation
	PORT(cts : IN STD_LOGIC;
		 Clk : IN STD_LOGIC;
		 nRST : IN STD_LOGIC;
		 Ser_In : IN STD_LOGIC;
		 BusAck : IN STD_LOGIC;
		 SetMode : IN STD_LOGIC;
		 dbus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 dtro : OUT STD_LOGIC;
		 BusRq : OUT STD_LOGIC;
		 error : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT par2ser_simulation
	PORT(cnd : IN STD_LOGIC;
		 wr : IN STD_LOGIC;
		 Clk : IN STD_LOGIC;
		 nRST : IN STD_LOGIC;
		 dtr : IN STD_LOGIC;
		 d_bus : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ntxe : OUT STD_LOGIC;
		 ser_out : OUT STD_LOGIC;
		 ctso : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	cts :  STD_LOGIC;
SIGNAL	dtr :  STD_LOGIC;
SIGNAL	Ser_In :  STD_LOGIC;
SIGNAL	ser_out :  STD_LOGIC;
SIGNAL	vcc :  STD_LOGIC;


BEGIN 



PROCESS(Clk_receiver,vcc,vcc)
BEGIN
IF (vcc = '0') THEN
	Ser_In <= '0';
ELSIF (vcc = '0') THEN
	Ser_In <= '1';
ELSIF (RISING_EDGE(Clk_receiver)) THEN
	Ser_In <= ser_out;
END IF;
END PROCESS;



b2v_Receiver : ser2par_simulation
PORT MAP(cts => cts,
		 Clk => Clk_receiver,
		 nRST => nRST,
		 Ser_In => Ser_In,
		 BusAck => BusAck,
		 SetMode => SetMode,
		 dbus => dbus_rec,
		 dtro => dtr,
		 BusRq => BusRq,
		 error => error);


b2v_Sender : par2ser_simulation
PORT MAP(cnd => cnd,
		 wr => wr,
		 Clk => Clk_sender,
		 nRST => nRST,
		 dtr => dtr,
		 d_bus => dbus_send,
		 ntxe => ntxe,
		 ser_out => ser_out,
		 ctso => cts);


vcc <= '1';
END bdf_type;