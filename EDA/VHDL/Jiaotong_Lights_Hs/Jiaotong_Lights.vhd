LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY Jiaotong_Lights IS
	PORT(
	mainroad_lights,branchroad_lights:OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 		--红灯,黄灯,绿灯
	mainroad_time_BCD,branchroad_time_BCD:OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	clk,ctr:IN STD_LOGIC;
	cnt:BUFFER INTEGER RANGE 69 DOWNTO 0:=0

	);
END Jiaotong_Lights;

ARCHITECTURE bhv OF Jiaotong_Lights IS

BEGIN
	
	PROCESS(clk,cnt)		--时钟进程
	BEGIN
		IF clk'EVENT AND clk='1' THEN
			IF cnt=69 THEN cnt<=0;		--70进制计数器
			ELSIF(ctr='1') THEN cnt<=0;
			ELSE cnt<=cnt+1;
			END IF;
		END IF;
	END PROCESS;
	
   PROCESS(clk,cnt,ctr)			--交通灯控制进程
	BEGIN
		IF(ctr='1') THEN 		--主次干道全显示红灯特殊状态处理
            mainroad_lights<="100";
				branchroad_lights<="100";
		ELSE 
			IF(cnt<=39) THEN
				mainroad_lights<="001";
				branchroad_lights<="100";
			ELSIF(cnt<=44) THEN 
				mainroad_lights<="010";
				branchroad_lights<="100";
			ELSIF(cnt<=64) THEN 
				mainroad_lights<="100";
				branchroad_lights<="001";
			ELSIF(cnt<=69) THEN 
				mainroad_lights<="100";
				branchroad_lights<="010";			
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(clk,cnt,ctr)				--倒计时显示进程
		VARIABLE mainroad_time:INTEGER;
		VARIABLE branchroad_time:INTEGER;
		
			BEGIN
			IF(ctr='1') THEN 
			mainroad_time:=0; 
			branchroad_time:=0;
			ELSE 
				IF(cnt<=39) THEN mainroad_time:=39-cnt; 
				ELSIF cnt<=44 THEN mainroad_time:=44-cnt;
				ELSIF cnt<=69 THEN mainroad_time:=69-cnt;
				END IF;
	
				IF(cnt<=44) THEN branchroad_time:=44-cnt;
				ELSIF(cnt<=64) THEN branchroad_time:=64-cnt;
				ELSIF(cnt<=69) THEN branchroad_time:=69-cnt;
				END IF;
			END IF;
				
				mainroad_time_BCD(7 DOWNTO 4)<=CONV_STD_LOGIC_VECTOR(mainroad_time/10 MOD 10,4);
				mainroad_time_BCD(3 DOWNTO 0)<=CONV_STD_LOGIC_VECTOR(mainroad_time REM 10,4);
				branchroad_time_BCD(7 DOWNTO 4)<=CONV_STD_LOGIC_VECTOR(branchroad_time/10 MOD 10,4);
				branchroad_time_BCD(3 DOWNTO 0)<=CONV_STD_LOGIC_VECTOR(branchroad_time REM 10,4);			
				
	END PROCESS;
	
END bhv;