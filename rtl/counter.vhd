library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter is

	generic (
		MAX_CNT  : integer := 63;
		CNT_SIZE : integer := 6
	);
	port (
		clk      : in  std_logic;
		reset_n  : in  std_logic;
		i_cnt_en : in  std_logic;
		flag     : out std_logic;
		count    : out std_logic_vector (CNT_SIZE-1 downto 0)
	);
end counter;

architecture counter_arc of counter is

	signal count_reg : std_logic_vector (CNT_SIZE-1 downto 0);

begin

	count_logic : process (reset_n, clk)
	begin
		if (reset_n = '0') then
			flag  <= '0';
			count_reg <="000000";
		elsif (rising_edge(clk)) then
			if (i_cnt_en = '1') then
				if (count_reg = MAX_CNT) then
					count_reg <= "111111";
					flag  <= '1';
				else
					count_reg <= count_reg+1;
					flag  <= '0';
				end if;
			else
				count_reg <= "000000";
				flag <= '0';					

			end if;

		end if;
	end process count_logic;

	count<=count_reg;
end counter_arc;
