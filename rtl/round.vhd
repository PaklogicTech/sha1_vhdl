library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity round is
	generic (
		BLK_SIZE           : integer := 256;
		WRD_SIZE : integer := 32
	);
	port (
		clk              : in  std_logic;                              -- clock signal
		reset_n          : in  std_logic;                           -- reset_n signal active low	
		i_round_en       : in  std_logic;           -- enable signal
		i_round_constant : in  std_logic_vector (WRD_SIZE-1 downto 0); -- round constant value from ROM
		i_pre_blck_hash  : in  std_logic_vector (BLK_SIZE-1 downto 0); -- hash of previous block
		i_msg_blck       : in  std_logic_vector (WRD_SIZE-1 downto 0); -- Message block
		o_hash           : out std_logic_vector(BLK_SIZE-1 downto 0)   -- hash output of round
	);
end round;

architecture round_arc of round is

	----******* split i_pre_blck_hash to 4-byte words *********-----
	signal  i_a: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  i_b: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  i_c: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  i_d: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  i_e: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  i_f: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  i_g: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  i_h: std_logic_vector (WRD_SIZE-1 downto 0);
	--******** out hash of round -***************************--
	signal  o_a: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  o_b: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  o_c: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  o_d: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  o_e: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  o_f: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  o_g: std_logic_vector (WRD_SIZE-1 downto 0);
	signal  o_h: std_logic_vector (WRD_SIZE-1 downto 0);
	--******** out hash of round -***************************--
	signal  i_fn_sigma_a : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_fn_sigma_e : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_sum_a_0	 : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_sum_a_1	 : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_fn_maj	 : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_fn_ch		 : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_sum_d_0	 : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_sum_h_0	 : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_sum_h_1	 : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_sum_h_2	 : std_logic_vector (WRD_SIZE-1 downto 0) ;
	signal  i_sum_h_3	 : std_logic_vector (WRD_SIZE-1 downto 0) ;




begin
----*******  i_pre_blck_hash word initialization *******************--
	i_a <= i_pre_blck_hash (255 downto 224);
	i_b <= i_pre_blck_hash (223 downto 192);
	i_c <= i_pre_blck_hash (191 downto 160);
	i_d <= i_pre_blck_hash (159 downto 128);
	i_e <= i_pre_blck_hash (127 downto 96 );
	i_f <= i_pre_blck_hash (95 downto 64  );
	i_g <= i_pre_blck_hash (63 downto 32  );
	i_h <= i_pre_blck_hash (31 downto 0   );
	-- used round function here to calculate the different function values
	i_fn_ch			<= ch (i_e,i_f,i_g)				 	 when (i_round_en='1')	else (others=> '0')	;
	i_sum_h_0		<= cs (i_fn_ch,i_h)				 	 when (i_round_en='1')	else (others=> '0')	;
	i_fn_sigma_e	<= sigma_e(i_e)						 when (i_round_en='1')	else (others=> '0')	;
	i_sum_h_1		<= cs (i_fn_sigma_e,i_sum_h_0)		 when (i_round_en='1')	else (others=> '0')	;
	i_sum_h_2		<= cs (i_sum_h_1,i_msg_blck)		 when (i_round_en='1')	else (others=> '0')	;
	i_sum_h_3		<= cs (i_sum_h_2, i_round_constant)  when (i_round_en='1')	else (others=> '0')	;
	i_sum_d_0		<= cs (i_sum_h_3, i_d)				 when (i_round_en='1')	else (others=> '0')	;
	i_fn_maj		<= maj (i_a,i_b,i_c)				 when (i_round_en='1')	else (others=> '0')	;
	i_fn_sigma_a	<= sigma_a (i_a)					 when (i_round_en='1')	else (others=> '0')	;
	i_sum_a_0		<= cs (i_fn_sigma_a,i_fn_maj)		 when (i_round_en='1')	else (others=> '0')	;
	i_sum_a_1		<= cs (i_sum_h_3,i_sum_a_0)		 	 when (i_round_en='1')	else (others=> '0')	;

-- flop the hash of each round
o_flop_hash : process (reset_n,clk)
begin
  if (reset_n = '0') then
    o_hash <= (others=>'0');
  elsif (rising_edge(clk)) then
  	-- cancatenation
  	o_hash			<=	i_sum_a_1&i_a&i_b&i_c&i_sum_d_0&i_e&i_f&i_g;
  end if;
end process o_flop_hash;

end round_arc;