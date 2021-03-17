library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity sha_top is
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
end sha_top;

architecture sha_top_arc of sha_top is

--
	 signal flag : std_logic;
	 signal o_cnt_en : std_logic;
	 signal sel_1 : std_logic;
	 signal o_round_count : std_logic_vector (BLK_CNT-1 downto 0) ;
	 signal o_hash_reg : std_logic_vector ( HASH_SIZE-1 downto 0 );
	 signal o_hash_rnd :std_logic_vector (HASH_SIZE-1 downto 0);
	
--
	signal  h_a : std_logic_vector (MSG_BLK-1 downto 0);
	signal  h_b : std_logic_vector (MSG_BLK-1 downto 0);
	signal  h_c : std_logic_vector (MSG_BLK-1 downto 0);
	signal  h_d : std_logic_vector (MSG_BLK-1 downto 0);
	signal  h_e : std_logic_vector (MSG_BLK-1 downto 0);
	signal  h_f : std_logic_vector (MSG_BLK-1 downto 0);
	signal  h_g : std_logic_vector (MSG_BLK-1 downto 0);
	signal  h_h : std_logic_vector (MSG_BLK-1 downto 0);
	
--

component control_unit is
	port (
		clk        : in  std_logic; -- system clock signal 
		reset_n    : in  std_logic; -- system global reset_n active low logic
		i_start    : in  std_logic; -- To start calculating hash just as enable
		i_cnt_flag : in  std_logic; -- FSM state driver flag from counter
		o_cnt_en   : out std_logic; -- counter enable signal as output
		o_valid    : out std_logic;
		sel_1      : out std_logic
	);
end component;
component data_path is
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
		i_pre_hash 		: in std_logic_vector ( HASH_SIZE-1 downto 0) ;
		o_round_count   : out std_logic_vector ( BLK_CNT -1 downto 0) ;
		i_cnt_en        : in  std_logic;
		flag            : out std_logic;
		o_hash          : out std_logic_vector ( HASH_SIZE-1 downto 0)
	);
end component;

begin
	h_a <= o_hash_rnd(255 downto 224);
	h_b <= o_hash_rnd(223 downto 192);
	h_c <= o_hash_rnd(191 downto 160);
	h_d <= o_hash_rnd(159 downto 128);
	h_e <= o_hash_rnd(127 downto 96 );
	h_f <= o_hash_rnd(95 downto 64  );
	h_g <= o_hash_rnd(63 downto 32  );
	h_h <= o_hash_rnd(31 downto 0   );

	i_cu: control_unit
	port map(
		clk        => clk        ,
		reset_n    => reset_n    ,
		i_start    => i_start    ,
		i_cnt_flag => flag ,
		o_cnt_en   => o_cnt_en   ,
		o_valid    => o_valid    ,
		sel_1      => sel_1      
	);

	i_dp : data_path
	generic map (
		BLK_CNT   => BLK_CNT   ,   
		MSG_SIZ   => MSG_SIZ   ,   
		MSG_BLK   => MSG_BLK   ,   
		MAX_CNT   => MAX_CNT   ,   
		HASH_SIZE => HASH_SIZE   
	)
	port map (
		clk           =>clk           ,
		reset_n       =>reset_n       ,
		i_dp_en       =>o_cnt_en       ,
		i_msg         =>i_msg         ,
		i_pre_hash    => i_pre_hash   ,
		o_round_count =>o_round_count ,
		i_cnt_en      =>o_cnt_en      ,
		flag          =>flag          ,
		o_hash        =>o_hash_rnd        
	);
	
hash_flop : process(sel_1,h_a,h_b,h_c,h_d,h_e,h_f,h_g,h_h)
	begin
		if (sel_1='1') then
		--	o_hash_reg <=( h_a + x"6a09e667")&(h_b+x"bb67ae85")&(h_c+x"3c6ef372")&(h_d+x"a54ff53a")&(h_e+x"510e527f")&(h_f+x"9b05688c")&(h_g+x"1f83d9ab")&(h_h+x"5be0cd19");
			o_hash_reg <=( h_a + i_pre_hash(255 downto 224))&(h_b+i_pre_hash(223 downto 192))&(h_c+i_pre_hash(191 downto 160))&(h_d+i_pre_hash(159 downto 128))&(h_e+i_pre_hash(127 downto 96))&(h_f+i_pre_hash(95 downto 64))&(h_g+i_pre_hash(63 downto 32))&(h_h+i_pre_hash(31 downto 0));				
		else
				o_hash_reg<= ( others => '0');	
		end if;
	end process ; -- hash_flop	
	o_hash<=o_hash_reg;
end sha_top_arc;