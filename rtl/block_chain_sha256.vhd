library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity block_chain_sha256 is
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
		o_ready    : out std_logic 										; -- to read next message block
		o_valid    : out std_logic                                      ; -- valid output
		o_hash     : out std_logic_vector(HASH_SIZE-1 downto 0)           -- Hash value
	);
end block_chain_sha256;

architecture block_chain_sha256_arc of block_chain_sha256 is

	signal clock : std_logic;

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
		clk        : in  std_logic                                      ; --system clock signal
		reset_n    : in  std_logic                                      ; --system global reset_n active low logic
		i_start    : in  std_logic                                      ; --To start calculating hash just as enable
		i_msg      : in  std_logic_vector(MESSAGE_INPUT_SIZE-1 downto 0); --message to finf hash
		i_pre_hash : in  std_logic_vector(HASH_SIZE-1 downto 0)         ; -- previous block hash
		o_valid    : out std_logic                                      ; -- valid output
		o_hash     : out std_logic_vector(HASH_SIZE-1 downto 0)           -- Hash value
	);	
end component sha_top;

	signal i_prehash_1 :   std_logic_vector(HASH_SIZE-1 downto 0) ;
	signal i_prehash_2 :   std_logic_vector(HASH_SIZE-1 downto 0) ;

	signal i_start_1 :  std_logic;
	signal i_start_2 :  std_logic;

begin

-- for first message --

i_sha_0: sha_top
generic map (
	BLK_CNT            =>BLK_CNT            ,  
	MESSAGE_INPUT_SIZE =>MESSAGE_INPUT_SIZE ,
	MSG_SIZ            =>MSG_SIZ            ,
	MSG_BLK            =>MSG_BLK            ,
	MAX_CNT            =>MAX_CNT            , 
	HASH_SIZE          =>HASH_SIZE          
	)
port map (
	clk        =>clk       ,
	reset_n    =>reset_n   ,
	i_start    =>i_start   ,
	i_msg      =>i_msg     ,
	i_pre_hash =>i_pre_hash,
	o_valid    =>i_start_1 ,  
	o_hash     =>i_prehash_1   
);

-- for second message
i_sha_1: sha_top
generic map (
	BLK_CNT            =>BLK_CNT            ,  
	MESSAGE_INPUT_SIZE =>MESSAGE_INPUT_SIZE ,
	MSG_SIZ            =>MSG_SIZ            ,
	MSG_BLK            =>MSG_BLK            ,
	MAX_CNT            =>MAX_CNT            , 
	HASH_SIZE          =>HASH_SIZE          
	)
port map (
	clk        =>clk          ,
	reset_n    =>reset_n      ,
	i_start    =>i_start_1    , 
	i_msg      =>i_msg        ,
	i_pre_hash =>i_prehash_1  ,
	o_valid    =>i_start_2    ,
	o_hash     =>i_prehash_2    
);

-- for third message
i_sha_2: sha_top
generic map (
	BLK_CNT            =>BLK_CNT            ,  
	MESSAGE_INPUT_SIZE =>MESSAGE_INPUT_SIZE ,
	MSG_SIZ            =>MSG_SIZ            ,
	MSG_BLK            =>MSG_BLK            ,
	MAX_CNT            =>MAX_CNT            , 
	HASH_SIZE          =>HASH_SIZE          
	)
port map (
	clk        =>clk        ,
	reset_n    =>reset_n    ,
	i_start    =>i_start_2    ,
	i_msg      =>i_msg      ,
	i_pre_hash =>i_prehash_2 ,
	o_valid    =>o_valid    ,
	o_hash     =>o_hash     
);

o_ready <= i_start_2 or i_start_1;
 
end block_chain_sha256_arc;


