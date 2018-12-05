LIBRARY ieee;
USE ieee.std_logic_1164.all;

--///////////////////////////////////////////////////////////
--////////////////////ENTITY DECLARATION////////////////////
--/////////////////////////////////////////////////////////
ENTITY UP_DOWN_COUNTER IS

PORT
(
clk		:	IN	STD_LOGIC;
nrst	:	IN	STD_LOGIC;
up		:	IN	STD_LOGIC;

q		:	OUT INTEGER RANGE -1 TO 9
);

END UP_DOWN_COUNTER;

--///////////////////////////////////////////////////////////
--///////////////////////ARCHITECTURE///////////////////////
--/////////////////////////////////////////////////////////
ARCHITECTURE UP_DOWN_COUNTER_architecture OF UP_DOWN_COUNTER IS
SIGNAL count	:	INTEGER RANGE -1 TO 9 := -1; 

BEGIN

--///////////////////////////////////////////////////////////
--//////////////////////////PROCESS/////////////////////////
--/////////////////////////////////////////////////////////
q <= count;
up_down_count:	PROCESS(clk, nrst)
	BEGIN
		IF nrst = '1' THEN
			IF rising_edge(clk) THEN
				IF (up = '1') AND (count < 9) THEN
					count <= (count + 1) AFTER 10 ns;
				ELSIF (up = '0') AND (count > -1) THEN
					count <= (count - 1) AFTER 10 ns;
				ELSIF (count < 0) OR (count > 4) THEN
					count <= -1 AFTER 10 ns;
				END IF;
				
				
			END IF;
		ELSE
			count <= -1 AFTER 5 ns;
		END IF;
		
	END PROCESS up_down_count;

END UP_DOWN_COUNTER_architecture;
