library ieee;
use ieee.std_logic_1164.all;

entity reg2 is 
	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic_vector(1 downto 0);
		   q : out std_logic_vector(1 downto 0)
	    );
end reg2;

architecture reg2_arch of reg2 is
begin
	process(clk, reset)
	begin
		if (reset = '1') then 
			q <= (others=>'0');
		elsif rising_edge(clk) then
			if (en = '1') then
				q <= d;
			end if;
		end if;
	end process;
end reg2_arch;
