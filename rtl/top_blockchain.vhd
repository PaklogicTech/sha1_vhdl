library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity top_blockchain is
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
end top_blockchain;

architecture top_blockchain_arc of top_blockchain is

	signal clock : std_logic;

-- message buffer
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

component block_chain_sha256 is
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
		i_msg      : in  std_logic_vector(MESSAGE_INPUT_SIZE-1 downto 0); --message to finf hash
		i_pre_hash : in  std_logic_vector(HASH_SIZE-1 downto 0)         ; -- previous block hash
		o_ready    : out std_logic 										;
		o_valid    : out std_logic                                      ; -- valid output
		o_hash     : out std_logic_vector(HASH_SIZE-1 downto 0)           -- Hash value
	);
end component;	

--

	signal i_msg : std_logic_vector (MESSAGE_INPUT_SIZE-1 downto 0);
	signal o_ready : std_logic;
--
begin


i_mesage_rom: mesage_rom 
	generic map(
		MESSAGE_INPUT_SIZE=>MESSAGE_INPUT_SIZE
	)
	port map(
		clk     => clk     ,                                          
		reset_n => reset_n ,                               
		i_en    => o_ready ,              
		o_msg   => i_msg           
	);

i_block_sha : block_chain_sha256 
	generic map (
			BLK_CNT            =>BLK_CNT           ,
			MESSAGE_INPUT_SIZE =>MESSAGE_INPUT_SIZE,
			MSG_SIZ            =>MSG_SIZ           ,
			MSG_BLK            =>MSG_BLK           ,
			MAX_CNT            =>MAX_CNT           ,
			HASH_SIZE          =>HASH_SIZE         
		)
	port map(
		clk        =>clk        ,
		reset_n    =>reset_n    ,
		i_start    =>i_start    ,
		i_msg      =>i_msg      ,
		i_pre_hash =>i_pre_hash ,
		o_ready    => o_ready   , 
		o_valid    =>o_valid    ,
		o_hash     =>o_hash     
	);

end top_blockchain_arc;