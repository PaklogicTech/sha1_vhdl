library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity data_path is
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
end data_path;

architecture data_path_arc of data_path is

	--	signal clock : std_logic;

	-- 1. Schedular --
	component message_schduler is
		generic (
			BLK_CNT : integer := 6;
			MSG_SIZ : integer := 512;
			MSG_BLK : integer := 32

		);
		port (
			clk            : in  std_logic ;
			reset_n        : in  std_logic ;
			i_msg_schdl_en : in  std_logic ;
			i_msg          : in  std_logic_vector (MSG_SIZ-1 downto 0) ;
			i_blk_nmbr     : in  std_logic_vector (BLK_CNT-1 downto 0) ;
			o_msg_blk      : out std_logic_vector (MSG_BLK-1 downto 0)
		);
	end component;
	-- 2. round constant --
	component round_constant is
		generic (
			ADDR_WTH : integer := 6;
			WRD_SIZE : integer := 32

		);
		port (
			clk              : in  std_logic ;                              --clk signal
			reset_n          : in  std_logic ;                              --reset_n signal
			enable           : in  std_logic ;                              -- enable signal
			add              : in  std_logic_vector (ADDR_WTH-1 downto 0) ; -- address as counter value to read rc
			o_round_constant : out std_logic_vector (WRD_SIZE-1 downto 0)   --round_constant for each round

		);
	end component;

	-- 3. counter --
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
	-- 4. round block --
	component round is
		generic (
			BLK_SIZE : integer := 256;
			WRD_SIZE : integer := 32
		);
		port (
			clk              : in  std_logic;                              -- clock signal
			reset_n          : in  std_logic;                           -- reset_n signal active low	
			i_round_en       : in  std_logic;                              -- enable signal
			i_round_constant : in  std_logic_vector (WRD_SIZE-1 downto 0); -- round constant value from ROM
			i_pre_blck_hash  : in  std_logic_vector (BLK_SIZE-1 downto 0); -- hash of previous block
			i_msg_blck       : in  std_logic_vector (WRD_SIZE-1 downto 0); -- Message block
			o_hash           : out std_logic_vector(BLK_SIZE-1 downto 0)   -- hash output of round
		);
	end component;
	
--	signal IV               : std_logic_vector (255 downto 0) := x"6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19";
	signal o_msg_blk        : std_logic_vector (MSG_BLK-1 downto 0);
	signal o_round_constant : std_logic_vector (MSG_BLK-1 downto 0);
	signal round_count : std_logic_vector ( BLK_CNT -1 downto 0) ;
	signal   i_pre_blck_hash : std_logic_vector (HASH_SIZE-1 downto 0);
	signal o_hash_reg          : std_logic_vector ( HASH_SIZE-1 downto 0);

begin
	i_message_schduler : message_schduler
		generic map (
			BLK_CNT => BLK_CNT ,
			MSG_SIZ => MSG_SIZ ,
			MSG_BLK => MSG_BLK
		)
		port map (
			clk            => clk ,
			reset_n        => reset_n ,
			i_msg_schdl_en => i_dp_en,
			i_msg          => i_msg ,
			i_blk_nmbr     => round_count ,
			o_msg_blk      => o_msg_blk
		);
	i_round_constant : round_constant
		generic map (
			ADDR_WTH=>BLK_CNT,
			WRD_SIZE=>MSG_BLK
		)
		port map (
			clk              => clk             ,
			reset_n          => reset_n         ,
			enable           => i_dp_en         ,
			add              => round_count     ,
			o_round_constant => o_round_constant 
		);

	i_counter : counter
		generic map (
			MAX_CNT  => MAX_CNT ,
			CNT_SIZE => BLK_CNT 
		)
		port map (
			clk      => clk        ,
			reset_n  => reset_n    ,
			i_cnt_en => i_cnt_en   ,
			flag     => flag       ,
			count    => round_count 
		);

	i_round : round
		generic map (
			BLK_SIZE => HASH_SIZE,
			WRD_SIZE => MSG_BLK 
		)
		port map (
			clk              => clk             ,
			reset_n          => reset_n         ,
			i_round_en       => i_dp_en         ,
			i_round_constant => o_round_constant,
			i_pre_blck_hash  => i_pre_blck_hash ,
			i_msg_blck       => o_msg_blk       ,
			o_hash           => o_hash_reg           
		);

i_pre_blck_hash <= i_pre_hash when (i_dp_en='1' and (round_count="000001"))  else o_hash_reg;--o_hash;--o_hash;
o_round_count<=round_count;
o_hash<=o_hash_reg;
end data_path_arc;