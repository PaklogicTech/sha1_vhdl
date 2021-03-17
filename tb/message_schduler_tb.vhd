library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;


entity message_schduler_tb is
end message_schduler_tb;

architecture arc_message_schduler_tb of message_schduler_tb is
--
	signal BLK_CNT : integer :=6;
	signal MSG_SIZ : integer :=512;
	signal MSG_BLK : integer :=32;
--
	signal clk            : std_logic :='1';  					    
	signal reset_n        : std_logic ;  					        
	signal i_msg_schdl_en : std_logic ;  					        
	signal i_msg          : std_logic_vector (511 downto 0) ;  
	signal i_blk_nmbr     : std_logic_vector (5 downto 0) :="000000";  
	signal o_msg_blk      :  std_logic_vector (31 downto 0); 	
--
component message_schduler is
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
end component;

begin
	i_message_schduler: message_schduler 
	generic map(
			BLK_CNT =>6, 
			MSG_SIZ =>512, 
			MSG_BLK =>32

		)
	port map(
		clk            =>clk            ,
		reset_n        =>reset_n        ,
		i_msg_schdl_en =>i_msg_schdl_en ,       
		i_msg          =>i_msg          ,	      
		i_blk_nmbr     =>i_blk_nmbr     ,	           
		o_msg_blk      =>o_msg_blk      
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
		i_msg_schdl_en<='0';
		i_msg<=x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
	wait for 15 ns;
		reset_n  <='1';
		i_msg_schdl_en<='1';
	blk_gen : for i in 0 to 63 loop
			wait until (clk'event and clk = '1');
		i_blk_nmbr    <= i_blk_nmbr+1;
	end loop; --add_switch
	wait for 200 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus	
end architecture arc_message_schduler_tb;
