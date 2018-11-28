-- WARNING: Do NOT edit the input and output ports in this file in a text
-- editor if you plan to continue editing the block that represents it in
-- the Block Editor! File corruption is VERY likely to occur.

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


-- Generated by Quartus Prime Version 18.1 (Build Build 625 09/12/2018)
-- Created on Tue Nov 27 20:30:32 2018

--Bram Kuijk
--Fontys Engineering

LIBRARY ieee;
USE ieee.std_logic_1164.all;


--  Entity Declaration

ENTITY compare_PWM IS
-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
PORT
(
sw_point : IN STD_LOGIC_VECTOR(7 DOWNTO 0);			--switch over point input
cntr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);				--counter input
PWM : OUT STD_LOGIC											--pwm output
);
-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!

END compare_PWM;


--  Architecture Body

ARCHITECTURE compare_PWM_architecture OF compare_PWM IS
BEGIN
	process(cntr, sw_point)
	begin
		if cntr < sw_point then			--if counter is < switch over point, output <= '1'
			PWM <= '1';
		else
			PWM <= '0';						--else (if counter is > switch over point), output <= '0'
		end if;
	end process;

END compare_PWM_architecture;