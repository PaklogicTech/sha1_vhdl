library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity sha_top_tb is
end sha_top_tb;

architecture sha_top_tb_arc of sha_top_tb is
	signal BLK_CNT            : integer := 6  ;
	signal MESSAGE_INPUT_SIZE : integer := 512;
	signal MSG_SIZ            : integer := 512;
	signal MSG_BLK            : integer := 32 ;
	signal MAX_CNT            : integer := 63 ;
	signal HASH_SIZE          : integer := 256; 

	signal clk     	:  std_logic :='1'                                ;
	signal reset_n 	:  std_logic                                      ;
	signal i_start  :  std_logic                                      ;
	signal i_msg    :  std_logic_vector(511 downto 0);
	signal i_pre_hash: std_logic_vector (255 downto 0);
	signal o_valid  :  std_logic                                      ;
	signal o_hash   :  std_logic_vector(255 downto 0)   	 		  ;       

component sha_top is
	generic (
		BLK_CNT            : integer := 6  ;
		MESSAGE_INPUT_SIZE : integer := 512;
		MSG_SIZ            : integer := 512;
		MSG_BLK            : integer := 32 ;
		MAX_CNT            : integer := 63 ;
		HASH_SIZE          : integer := 256 
	);
	port (
		clk     	: in  std_logic                                      ; --system clock signal
		reset_n 	: in  std_logic                                      ; --system global reset_n active low logic
		i_start     : in  std_logic                                      ; --To start calculating hash just as enable
		i_msg       : in  std_logic_vector(MESSAGE_INPUT_SIZE-1 downto 0); --message to finf hash
		i_pre_hash  : in  std_logic_vector(HASH_SIZE-1 downto 0) ; -- prvious block hash	
		o_valid     : out std_logic                                      ; -- valid output
		o_hash      : out std_logic_vector(HASH_SIZE-1 downto 0)           -- Hash value
	);
end component;

begin
 i_sha_top : sha_top 
	generic map(
		BLK_CNT            => 6  ,
		MESSAGE_INPUT_SIZE => 512,
		MSG_SIZ            => 512,
		MSG_BLK            => 32 ,
		MAX_CNT            => 63 ,
		HASH_SIZE          => 256
	)
	port map(
		clk     => clk    ,
		reset_n => reset_n,
		i_start => i_start,
		i_msg   => i_msg  ,
		i_pre_hash=>i_pre_hash,
		o_valid => o_valid,
		o_hash  => o_hash 
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
		i_start  <='0';
		i_msg	 <=(others=>'0');   
	wait for 15 ns;
		reset_n  <= '1';
		i_start  <= '1';
		i_msg    <=x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";

	wait for 5000 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus
end sha_top_tb_arc;

