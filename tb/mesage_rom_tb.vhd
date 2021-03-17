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
entity mesage_rom_tb is
end mesage_rom_tb;

architecture mesage_rom_tb_arc of mesage_rom_tb is

	signal clk     : std_logic := '1';
	signal reset_n : std_logic;
	signal i_en    : std_logic;
	signal o_msg   : std_logic_vector (511 downto 0);

component mesage_rom is
	generic (
		MESSAGE_INPUT_SIZE : integer := 512
	);
	port (
		clk    : in  std_logic ; --clk signal
		reset_n : in  std_logic ; --reset_n signal
		i_en    : in  std_logic ;
		o_msg   : out std_logic_vector (MESSAGE_INPUT_SIZE-1 downto 0)
	);
end component;

begin
i_mesage_rom : mesage_rom 
	generic map(
		MESSAGE_INPUT_SIZE =>512
	)
	port map(
		clk     => clk     ,                     
		reset_n => reset_n ,                         
		i_en    => i_en    ,        
		o_msg   => o_msg       
	);
	-------------------------------------------------------------------
  -- Clock process definitions
  ----------------------------------------------------------------
  sys_clock_sec : process
   begin
       wait for 10 ns; clk  <= not clk;
   end process sys_clock_sec; 

    -------------------------------------------------------------------
   -- Stimulus process
 -------------------------------------------------------------------
	stimulus : process
	begin
		reset_n  <='0';
		i_en <= '0';  
	wait for 15 ns;
		reset_n <= '1';
	wait until (clk'event and clk = '1');	
		i_en <= '1';
		wait for 5000 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus
end mesage_rom_tb_arc;
