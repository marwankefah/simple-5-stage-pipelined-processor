LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY Processor IS
PORT (	--EXTERNAL INPUT
	CLK:		IN std_logic;
	Reset :	 	IN std_logic; 
	INTR_IN:	IN std_logic;
	IN_PORT:	IN std_logic_vector(31 DOWNTO 0);
	--OUTPUT
	OUT_PORT:	OUT std_logic_vector(31 DOWNTO 0)
			);
END Processor;

Architecture Processor_Archi of Processor IS




COMPONENT reg is 
	generic(
		n : integer
	);

	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic_vector(n-1 downto 0);
		   q : out std_logic_vector(n-1 downto 0)
	);
end COMPONENT;
COMPONENT Execute_Stage IS
PORT (	--EXTERNAL INPUT
CLK:		std_logic;
Reset :	 	std_logic; 
EX_INTS:	std_logic_vector(1 DOWNTO 0);
RD1:  IN std_logic_vector(31 DOWNTO 0);
 RD2 : IN std_logic_vector(31 DOWNTO 0);
--RD2 comming from memory stage
RD2N: IN std_logic_vector(31 DOWNTO 0);
WB:   IN std_logic_vector(31 DOWNTO 0);
ALUr: IN std_logic_vector(31 DOWNTO 0);
A:    IN std_logic_vector(1  DOWNTO 0);
B:    IN std_logic_vector(1  DOWNTO 0);
IMMe: IN std_logic_vector(31 DOWNTO 0);
--Control input begin
ID_EX_EX:   IN std_logic_vector(10 DOWNTO 0);
ID_EX_MEM:  IN std_logic_vector(10 DOWNTO 0);
ID_EX_WB:   IN std_logic_vector(4 DOWNTO 0);
--Control input end
EX_MEM_MEM: OUT std_logic_vector(10 DOWNTO 0);
EX_MEM_WB:  OUT std_logic_vector(4 DOWNTO 0);
CCR:  	   OUT std_logic_vector(3 DOWNTO 0);
ALUResult: OUT std_logic_vector(31 DOWNTO 0)
			);
END COMPONENT;

COMPONENT EX_MEM_Buffer IS
PORT( 		 
Clk,Rst,en : IN stD_logic;
--BEGIN INPUT_BUFFER
--WB CONTROL PROPAGATION
D_WB : 		IN std_logic_vector(4 downto 0);
--END WB CONTROL PROPAGATION
--MEMORY CONTROL PROPAGATION
D_MEM : 	IN std_logic_vector(10 downto 0);
--END MEMORY CONTROL PROPAGATION
--Execute Data PROPAGATION
D_ALUResult:	IN stD_logic_vector(31 DOWNTO 0);
D_PC : 		IN std_logic_vector(31 downto 0);
D_PCnext : 	IN std_logic_vector(31 downto 0);
D_RD1:		IN stD_logic_vector(31 DOWNTO 0);
D_RD2:		IN stD_logic_vector(31 DOWNTO 0);
D_EAe:		IN stD_logic_vector(31 DOWNTO 0);
D_WR1:		IN stD_logic_vector(2 DOWNTO 0);
D_WR2:		IN stD_logic_vector(2 DOWNTO 0);
D_RR1:		IN stD_logic_vector(2 DOWNTO 0);
D_RR2:		IN stD_logic_vector(2 DOWNTO 0);
--END Execute Data PROPAGATION
--OTHER PROPAGATION
D_OPCODE:	IN stD_logic_vector(5 DOWNTO 0);
D_INT:		IN stD_logic;
--END OTHER PROPAGATION
--END INPUT BUFFER
  --BEGIN OUTPUT_BUFFER		
--WB CONTROL PROPAGATION
Q_WB :  OUT std_logic_vector(4 downto 0);
--END WB CONTROL PROPAGATION
--MEMORY CONTROL PROPAGATION
Q_MEM : OUT std_logic_vector(10 downto 0);
--END MEMORY CONTROL PROPAGATION
--Execute Data PROPAGATION
Q_ALUResult:	OUT stD_logic_vector(31 DOWNTO 0);
Q_PC:	 	OUT stD_logic_vector(31 DOWNTO 0);
Q_PCnext:	OUT stD_logic_vector(31 DOWNTO 0);
Q_RD1:		OUT stD_logic_vector(31 DOWNTO 0);
Q_RD2:		OUT stD_logic_vector(31 DOWNTO 0);
Q_EAe:		OUT stD_logic_vector(31 DOWNTO 0);
Q_WR1:		OUT stD_logic_vector(2 DOWNTO 0);
Q_WR2:		OUT stD_logic_vector(2 DOWNTO 0);
Q_RR1:		OUT stD_logic_vector(2 DOWNTO 0);
Q_RR2:		OUT stD_logic_vector(2 DOWNTO 0);
--END Execute Data PROPAGATION
--OTHER PROPAGATION
Q_OPCODE:	OUT stD_logic_vector(5 DOWNTO 0);
Q_INT:		OUT stD_logic
--END OTHER PROPAGATION  
--END OUTPUT BUFFER			
);
		  
END COMPONENT;

--OUTPUT OF DECODE/EXECUTE BUFFER
Signal ID_EX_OUT_WB :  std_logic_vector(4 downto 0);
Signal ID_EX_OUT_MEM :  std_logic_vector(10 downto 0);
Signal ID_EX_OUT_EX :  std_logic_vector(10 downto 0);
Signal ID_EX_OUT_opcode :  std_logic_vector(5 downto 0);
Signal ID_EX_OUT_INPS :  std_logic_vector(1 downto 0);
Signal ID_EX_OUT_int :  std_logic;
Signal ID_EX_OUT_PC :  std_logic_vector(31 downto 0);
Signal ID_EX_OUT_PCnext :  std_logic_vector(31 downto 0);
Signal ID_EX_OUT_RD1 :  std_logic_vector(31 downto 0);
Signal ID_EX_OUT_RD2 :  std_logic_vector(31 downto 0);
Signal ID_EX_OUT_IMMe :  std_logic_vector(31 downto 0);
Signal ID_EX_OUT_EAe :  std_logic_vector(31 downto 0);
Signal ID_EX_OUT_WR1 :  std_logic_vector(2 downto 0);
Signal ID_EX_OUT_WR2 :  std_logic_vector(2 downto 0);
Signal ID_EX_OUT_RR1 :  std_logic_vector(2 downto 0);
Signal ID_EX_OUT_RR2 :  std_logic_vector(2 downto 0);

--EXECUTE STAGE OUTPUTs


signal EX_OUT_MEM :  	std_logic_vector(10 downto 0);
signal EX_OUT_WB :   	std_logic_vector(4 downto 0);
signal CCR 	:      	std_logic_vector(3 downto 0);
signal EX_ALUResult: 	std_logic_vector(31 downto 0);

--END EXECUTE STAGE OUTPUTS


--OUTPUT OF  EXECUTE/MEMORY BUFFER
Signal EX_MEM_OUT_WB :         std_logic_vector(4 downto 0);
Signal EX_MEM_OUT_MEM :        std_logic_vector(10 downto 0);
Signal EX_MEM_OUT_ALUResult:	std_logic_vector(31 downto 0);
Signal EX_MEM_OUT_PC:	 	std_logic_vector(31 downto 0);
Signal EX_MEM_OUT_PCnext:	std_logic_vector(31 downto 0);
Signal EX_MEM_OUT_RD1:		std_logic_vector(31 downto 0);
Signal EX_MEM_OUT_RD2:		std_logic_vector(31 downto 0);
Signal EX_MEM_OUT_EAe:		std_logic_vector(31 downto 0);
Signal EX_MEM_OUT_WR1:		std_logic_vector(2 downto 0);
Signal EX_MEM_OUT_WR2:		std_logic_vector(2 downto 0);
Signal EX_MEM_OUT_RR1:		std_logic_vector(2 downto 0);
Signal EX_MEM_OUT_RR2:		std_logic_vector(2 downto 0);
Signal EX_MEM_OUT_OPCODE:	std_logic_vector(5 downto 0);
Signal EX_MEM_OUT_INT:		std_logic;


--END EXECUTE/MEMORY BUFFER



--TODO AHMED
--OUTPUT OF  MEMORY/WB BUFFER



--END MEMORY/WB BUFFER

BEGIN




--DECODE/Execute  BUFFER






--END DECODE/Execute  BUFFER

--EXecute STAGE 

IF_STAGE: Execute_Stage  PORT MAP (	--EXTERNAL INPUT
				CLK=>		CLK	,
				Reset =>	Reset	, 
				EX_INTS=>	"01",		--TODO TO BE REPLACED WTH INT_HANDLING_UNIT OUTPUT
				RD1=>   	ID_EX_OUT_RD1  ,
				RD2 =>  	ID_EX_OUT_RD2,
				RD2N=>  	ID_EX_OUT_RD2 , -- TODO to be replaced with Forwarding out
				WB=>    	ID_EX_OUT_RD2  ,-- TODO to be replaced with Forwarding out
				ALUr=>  	ID_EX_OUT_RD2 , -- TODO to be replaced with Forwarding out
				A=>      	"00"  ,   	-- TODO to be replaced with Forwarding out
				B=>      	"00" ,	  	-- TODO to be replaced with forwarding out
				IMMe=> 		ID_EX_OUT_IMMe  ,
				--Control input begin
				ID_EX_EX=>	ID_EX_OUT_EX    ,
				ID_EX_MEM=>     ID_EX_OUT_MEM ,
				ID_EX_WB=>      ID_EX_OUT_WB,
				--Control input end
				EX_MEM_MEM=>    EX_OUT_MEM  ,
				EX_MEM_WB=>	EX_OUT_WB   ,
				CCR=>  	  	CCR    ,
				ALUResult=> 	EX_ALUResult
			);


--END Execute STAGE 

--OUTPUT REGISTER

OUTPUT_PORT_REG : REG Generic map(32) port map(clk=>clk,
					       reset=>reset,
					       en=>ID_EX_OUT_EX(10),
					       d=>EX_ALUResult,
					       q=>OUT_PORT
						);

--END OUTPUT REGISTER



--EXECUTE/MEM  BUFFER
EX_MEM_BUFF: EX_MEM_Buffer PORT MAP( 		 
					Clk=>		CLK,
					Rst=>		Reset,
					en =>		'1' ,   -- TODO UNDERSTAND
					--BEGIN INPUT_BUFFER
					--WB CONTROL PROPAGATION
					D_WB => 	EX_OUT_WB	   ,
					--END WB CONTROL PROPAGATION
					--MEMORY CONTROL PROPAGATION
					D_MEM => 	EX_OUT_MEM   ,
					--END MEMORY CONTROL PROPAGATION
					--Execute Data PROPAGATION
					D_ALUResult=>	EX_ALUResult   ,
					D_PC => 	ID_EX_OUT_PC   ,
					D_PCnext => 	ID_EX_OUT_PCnext   ,
					D_RD1=>		ID_EX_OUT_RD1  ,
					D_RD2=>		ID_EX_OUT_RD2,
					D_EAe=>		ID_EX_OUT_EAe,
					D_WR1=>		ID_EX_OUT_WR1,
					D_WR2=>		ID_EX_OUT_WR2,
					D_RR1=>		ID_EX_OUT_RR1,
					D_RR2=>		ID_EX_OUT_RR2,
					--END Execute Data PROPAGATION
					--OTHER PROPAGATION
					D_OPCODE=>	ID_EX_OUT_OPCODE  ,
					D_INT=>		ID_EX_OUT_INT,
					--END OTHER PROPAGATION
					--END INPUT BUFFER
					  --BEGIN OUTPUT_BUFFER		
					--WB CONTROL PROPAGATION
					Q_WB => 	EX_MEM_OUT_WB	   ,
					--END WB CONTROL PROPAGATION
					--MEMORY CONTROL PROPAGATION
					Q_MEM => 	EX_MEM_OUT_MEM   ,
					--END MEMORY CONTROL PROPAGATION
					--Execute Data PROPAGATION
					Q_ALUResult=>	EX_MEM_OUT_ALUResult   ,
					Q_PC => 	EX_MEM_OUT_PC   ,
					Q_PCnext => 	EX_MEM_OUT_PCnext   ,
					Q_RD1=>		EX_MEM_OUT_RD1  ,
					Q_RD2=>		EX_MEM_OUT_RD2,
					Q_EAe=>		EX_MEM_OUT_EAe,
					Q_WR1=>		EX_MEM_OUT_WR1,
					Q_WR2=>		EX_MEM_OUT_WR2,
					Q_RR1=>		EX_MEM_OUT_RR1,
					Q_RR2=>		EX_MEM_OUT_RR2,
					--END Execute Data PROPAGATION
					--OTHER PROPAGATION
					Q_OPCODE=>	EX_MEM_OUT_OPCODE  ,
					Q_INT=>		EX_MEM_OUT_INT
					--END OTHER PROPAGATION
					--END OUTPUT BUFFER			
					);





--END EXECUTE/MEM  BUFFER




END Processor_Archi;