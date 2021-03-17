library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity data_path_tb is
end data_path_tb;

architecture data_path_tb_arc of data_path_tb is

--
	signal BLK_CNT   : integer := 6;
	signal MSG_SIZ   : integer := 512;
	signal MSG_BLK   : integer := 32;
	signal MAX_CNT   : integer := 63;
	signal HASH_SIZE : integer := 256;
--
	signal clk             :  std_logic :='1';
	signal reset_n         :  std_logic;
	signal i_dp_en         :  std_logic;
	signal i_msg           :  std_logic_vector ( 511 downto 0) ;
	signal i_pre_hash 		:  std_logic_vector ( 255 downto 0);
	signal o_round_count   :  std_logic_vector ( 5 downto 0) ;
	signal i_cnt_en        :  std_logic;
	signal flag            :  std_logic;
	signal o_hash          :  std_logic_vector ( 255 downto 0);	

component	data_path is
	generic (
		BLK_CNT   : integer := 6;
		MSG_SIZ   : integer := 512;
		MSG_BLK   : integer := 32;
		MAX_CNT   : integer := 63;
		HASH_SIZE : integer := 256

	);
	port (
		clk             : in  std_logic;
		reset_n         : in  std_logic;
		i_dp_en         : in  std_logic;
		i_msg           : in  std_logic_vector ( MSG_SIZ -1 downto 0) ;
		i_pre_hash 		: in std_logic_vector ( HASH_SIZE-1 downto 0);
		o_round_count   : out std_logic_vector ( BLK_CNT -1 downto 0) ;
		i_cnt_en        : in  std_logic;
		flag            : out std_logic;
		o_hash          : out std_logic_vector ( HASH_SIZE-1 downto 0)
	);
end component;

begin
i_data_path: data_path 
	generic map(
		BLK_CNT    =>6,
		MSG_SIZ    =>512, 
		MSG_BLK    =>32,
		MAX_CNT    =>63,
		HASH_SIZE  =>256

	)
	port map(
		clk             => clk             ,
		reset_n         => reset_n         ,
		i_dp_en         => i_dp_en         ,
		i_msg           => i_msg           ,
		i_pre_hash 		=>i_pre_hash 	   ,
		o_round_count   => o_round_count   ,
		i_cnt_en        => i_cnt_en        ,
		flag            => flag            ,
		o_hash          => o_hash          
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
		i_pre_hash <= x"6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19";
		reset_n  <= '0';
		i_dp_en	 <= '0';
		i_cnt_en <= '0';
		i_msg 	 <= (others=>'0');    
	wait for 15 ns;
		reset_n  <= '1';
		i_dp_en	 <= '1';
		i_cnt_en <= '1';
		i_msg 	 <= x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";

	wait for 200 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus	
end data_path_tb_arc;