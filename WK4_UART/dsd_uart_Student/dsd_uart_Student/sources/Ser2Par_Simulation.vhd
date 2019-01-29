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
-- CREATED		"Tue Nov 06 19:54:28 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Ser2Par_Simulation IS 
	PORT
	(
		BusAck :  IN  STD_LOGIC;
		Clk :  IN  STD_LOGIC;
		Ser_In :  IN  STD_LOGIC;
		SetMode :  IN  STD_LOGIC;
		cts :  IN  STD_LOGIC;
		nRST :  IN  STD_LOGIC;
		dbus :  INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		BusRq :  OUT  STD_LOGIC;
		dtro :  OUT  STD_LOGIC;
		error :  OUT  STD_LOGIC
	);
END Ser2Par_Simulation;

ARCHITECTURE bdf_type OF Ser2Par_Simulation IS 

COMPONENT controller_r
	PORT(BusAck : IN STD_LOGIC;
		 Clk : IN STD_LOGIC;
		 NxtBit : IN STD_LOGIC;
		 ParBit : IN STD_LOGIC;
		 ParEnab : IN STD_LOGIC;
		 Ser_In : IN STD_LOGIC;
		 SetMode : IN STD_LOGIC;
		 cts : IN STD_LOGIC;
		 nRST : IN STD_LOGIC;
		 ChrLen : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 StopBits : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 BusRq : OUT STD_LOGIC;
		 ClrBrt : OUT STD_LOGIC;
		 ClrPar : OUT STD_LOGIC;
		 EnOut : OUT STD_LOGIC;
		 Ldm : OUT STD_LOGIC;
		 Shsi : OUT STD_LOGIC;
		 SplPar : OUT STD_LOGIC;
		 dtro : OUT STD_LOGIC;
		 error : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT tristatebuf_r
	PORT(EnOut : IN STD_LOGIC;
		 ShiftReg : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 dbus : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT baudratetimer_r_simulation
	PORT(Clk : IN STD_LOGIC;
		 ClrBrt : IN STD_LOGIC;
		 Baudrate : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 NxtBit : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT moderegister_r
	PORT(Clk : IN STD_LOGIC;
		 Ldm : IN STD_LOGIC;
		 dbus : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 EvenPar : OUT STD_LOGIC;
		 ParEnab : OUT STD_LOGIC;
		 Baudrate : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ChrLen : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 StopBits : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT parityreg_r
	PORT(Clk : IN STD_LOGIC;
		 ClrPar : IN STD_LOGIC;
		 EvenPar : IN STD_LOGIC;
		 Ser_In : IN STD_LOGIC;
		 SplPar : IN STD_LOGIC;
		 ParBit : INOUT STD_LOGIC
	);
END COMPONENT;

COMPONENT shiftreg_r
	PORT(Clk : IN STD_LOGIC;
		 Ser_In : IN STD_LOGIC;
		 Shsi : IN STD_LOGIC;
		 ChrLen : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ShiftReg : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	Baudrate :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	ChrLen :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	ClrBrt :  STD_LOGIC;
SIGNAL	ClrPar :  STD_LOGIC;
SIGNAL	EnOut :  STD_LOGIC;
SIGNAL	EvenPar :  STD_LOGIC;
SIGNAL	Ldm :  STD_LOGIC;
SIGNAL	NxtBit :  STD_LOGIC;
SIGNAL	ParBit :  STD_LOGIC;
SIGNAL	ParEnab :  STD_LOGIC;
SIGNAL	ShiftReg :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	Shsi :  STD_LOGIC;
SIGNAL	SplPar :  STD_LOGIC;
SIGNAL	StopBits :  STD_LOGIC_VECTOR(1 DOWNTO 0);


BEGIN 



b2v_controller_r : controller_r
PORT MAP(BusAck => BusAck,
		 Clk => Clk,
		 NxtBit => NxtBit,
		 ParBit => ParBit,
		 ParEnab => ParEnab,
		 Ser_In => Ser_In,
		 SetMode => SetMode,
		 cts => cts,
		 nRST => nRST,
		 ChrLen => ChrLen,
		 StopBits => StopBits,
		 BusRq => BusRq,
		 ClrBrt => ClrBrt,
		 ClrPar => ClrPar,
		 EnOut => EnOut,
		 Ldm => Ldm,
		 Shsi => Shsi,
		 SplPar => SplPar,
		 dtro => dtro,
		 error => error);


b2v_inst : tristatebuf_r
PORT MAP(EnOut => EnOut,
		 ShiftReg => ShiftReg,
		 dbus => dbus);


b2v_inst6 : baudratetimer_r_simulation
PORT MAP(Clk => Clk,
		 ClrBrt => ClrBrt,
		 Baudrate => Baudrate,
		 NxtBit => NxtBit);


b2v_modereg_r : moderegister_r
PORT MAP(Clk => Clk,
		 Ldm => Ldm,
		 dbus => dbus,
		 EvenPar => EvenPar,
		 ParEnab => ParEnab,
		 Baudrate => Baudrate,
		 ChrLen => ChrLen,
		 StopBits => StopBits);


b2v_parityreg_R : parityreg_r
PORT MAP(Clk => Clk,
		 ClrPar => ClrPar,
		 EvenPar => EvenPar,
		 Ser_In => Ser_In,
		 SplPar => SplPar,
		 ParBit => ParBit);


b2v_shiftreg_r : shiftreg_r
PORT MAP(Clk => Clk,
		 Ser_In => Ser_In,
		 Shsi => Shsi,
		 ChrLen => ChrLen,
		 ShiftReg => ShiftReg);


END bdf_type;