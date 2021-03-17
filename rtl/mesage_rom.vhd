library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

-- All message will be loaded to this rom. At this level we are assuming we have a message with 3 blocks of 512
-- so we will use three location of rom

entity mesage_rom is
	generic (
		MESSAGE_INPUT_SIZE : integer := 512
	);
	port (
		clk    : in  std_logic ; --clk signal
		reset_n : in  std_logic ; --reset_n signal
		i_en    : in  std_logic ;
		o_msg   : out std_logic_vector (MESSAGE_INPUT_SIZE-1 downto 0)
	);
end mesage_rom;

architecture mesage_rom_arc of mesage_rom is

	type msg_buff is array (0 to 2) of std_logic_vector(511 downto 0);
	signal msg_bus: msg_buff ;
	signal count: std_logic_vector (1 downto 0) :="00";

begin
	msg_bus(0) <= x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
	msg_bus(1) <= x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022";
	msg_bus(2) <= x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000026";

	read_logic : process (reset_n, clk)
	begin
		if (reset_n = '0') then
			o_msg <= msg_bus(0);
		elsif (rising_edge(clk)) then
			o_msg <= msg_bus(to_integer(unsigned(count)));
		end if;
	end process read_logic;

add_count : process (reset_n, clk,i_en)
begin
  if (reset_n = '0') then
    count <= (others=> '0');
  elsif (rising_edge(clk)) then
  	if (i_en='1') then
  		if (count="10") then
  			count<="00";
  		else
  		count<=count+1;
  	end if;
  end if;
  end if;
end process add_count;

end mesage_rom_arc;