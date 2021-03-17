library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter_tb is
end counter_tb;

architecture counter_tb_arc of counter_tb is

--
	signal MAX_CNT  : integer := 63;
	signal CNT_SIZE : integer := 6;
--
	signal clk      :  std_logic :='1';
	signal reset_n  :  std_logic;
	signal i_cnt_en :  std_logic;
	signal flag     :  std_logic;
	signal count    :  std_logic_vector (5 downto 0);
--

component counter is

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
end component;

begin
 i_counter:counter 

	generic map(
		MAX_CNT  => 63, 
		CNT_SIZE => 6  
	)
	port map(
		clk      =>clk      ,
		reset_n  =>reset_n  ,
		i_cnt_en =>i_cnt_en ,
		flag     =>flag     ,
		count    =>count    
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
		i_cnt_en <= '0';   
	wait for 15 ns;
		reset_n  <='1';
		i_cnt_en <='1'; 
	wait for 200 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus	
end counter_tb_arc;