library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;


entity message_schduler is
	generic (
			BLK_CNT : integer :=6;
			MSG_SIZ : integer :=512;
			MSG_BLK : integer :=32

		);
	port (
		clk           : in std_logic ;  					    
		reset_n       : in std_logic ;  					        
		i_msg_schdl_en : in std_logic ;  					               
		i_msg         : in std_logic_vector (MSG_SIZ-1 downto 0) ;  	      
		i_blk_nmbr    : in std_logic_vector (BLK_CNT-1 downto 0) ;  	           
		o_msg_blk      : out std_logic_vector (MSG_BLK-1 downto 0) 
	);
end message_schduler;
architecture behav of message_schduler is

	--signal clk : std_logic;
	type message_block is array (0 to 63) of std_logic_vector(31 downto 0);
	signal message_weight: message_block;
begin
	message_weight(15) <= i_msg(31  downto 0  );
	message_weight(14) <= i_msg(63  downto 32 );
	message_weight(13) <= i_msg(95  downto 64 );
	message_weight(12) <= i_msg(127 downto 96 );
	message_weight(11) <= i_msg(159 downto 128);
	message_weight(10) <= i_msg(191 downto 160);
	message_weight(9 ) <= i_msg(223 downto 192);
	message_weight(8 ) <= i_msg(255 downto 224);
	message_weight(7 ) <= i_msg(287 downto 256);
	message_weight(6 ) <= i_msg(319 downto 288);
	message_weight(5)  <= i_msg(351 downto 320);
	message_weight(4)  <= i_msg(383 downto 352);
	message_weight(3)  <= i_msg(415 downto 384);
	message_weight(2)  <= i_msg(447 downto 416);
	message_weight(1)  <= i_msg(479 downto 448);
	message_weight(0)  <= i_msg(511 downto 480);

msg_word : for i in 16 to 63 generate
	 message_weight(i) <=  alpha_1(message_weight(i-2))+ alpha_0(message_weight(i-15)) + message_weight(i-7)+ message_weight(i-16);
	-- message_weight(i) <=x"00000000";	
end generate msg_word;

msg_round_in : process (reset_n, clk)
begin
  if (reset_n = '0') then
    o_msg_blk <=x"00000000";
  elsif (rising_edge(clk)) then
  	if (i_msg_schdl_en = '1') then
  		o_msg_blk<=message_weight(to_integer(unsigned(i_blk_nmbr))); -- cross check
  	end if;
  end if;
end process msg_round_in;

end behav;


