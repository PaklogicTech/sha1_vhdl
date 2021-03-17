library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity top_blockchain_tb is
end top_blockchain_tb;

architecture top_blockchain_tb_arc of top_blockchain_tb is

component top_blockchain is
	generic (
			BLK_CNT            : integer := 6  ;
			MESSAGE_INPUT_SIZE : integer := 512;
			MSG_SIZ            : integer := 512;
			MSG_BLK            : integer := 32 ;
			MAX_CNT            : integer := 63 ;
			HASH_SIZE          : integer := 256 
		);
		port (
		clk        : in  std_logic                                      ; --system clock signal
		reset_n    : in  std_logic                                      ; --system global reset_n active low logic
		i_start    : in  std_logic                                      ; --To start calculating hash just as enable
	    i_pre_hash : in  std_logic_vector(HASH_SIZE-1 downto 0)         ; -- previous block hash
		o_valid    : out std_logic                                      ; -- valid output
		o_hash     : out std_logic_vector(HASH_SIZE-1 downto 0)           -- Hash value
		);
end component;

	signal clk        :  std_logic :='1'                                     ; --system clock signal
	signal reset_n    :  std_logic                                      ; --system global reset_n active low logic
	signal i_start    :  std_logic                                      ; --To start calculating hash just as enable
	signal i_pre_hash :  std_logic_vector(255 downto 0)         ; -- previous block hash
	signal o_valid    :  std_logic                                      ; -- valid output
	signal o_hash     :  std_logic_vector(255 downto 0)     	;       -- Hash value

begin


i_top_blockchain : 	top_blockchain 
generic map (
	BLK_CNT             => 6  ,
	MESSAGE_INPUT_SIZE  => 512,
	MSG_SIZ             => 512,
	MSG_BLK             => 32 ,
	MAX_CNT             => 63 ,
	HASH_SIZE           => 256
)
port map (
	clk        =>clk        ,    
	reset_n    =>reset_n    ,
	i_start    =>i_start    ,
	i_pre_hash =>i_pre_hash ,
	o_valid    =>o_valid    ,
	o_hash     =>o_hash     
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
 ------------------------------------------------------------------

 	stimulus : process
	begin
		i_pre_hash <= x"6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19";
		reset_n  <='0';
		i_start <= '0';  
	wait for 15 ns;
		reset_n <= '1';
	wait until (clk'event and clk = '1');	
		i_start <= '1';
	wait for 5000 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus
end top_blockchain_tb_arc;

