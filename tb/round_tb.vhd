library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity round_tb is
end round_tb;

architecture round_tb_arc of round_tb is

--
	signal BLK_SIZE           : integer := 256;
	signal WRD_SIZE 			: integer := 32;
--
	signal clk              :  std_logic:='1';                              -- clock signal
	signal reset_n          :  std_logic;                              -- reset_n signal active low	
	signal i_round_en       :  std_logic;           				   -- enable signal
	signal i_round_constant :  std_logic_vector (31 downto 0); -- round constant value from 
	signal i_pre_blck_hash  :  std_logic_vector (255 downto 0); -- hash of previous block
	signal i_msg_blck       :  std_logic_vector (31 downto 0); -- Message block
	signal o_hash           :  std_logic_vector(255 downto 0);  -- hash output of round
--
component round is
	generic (
		BLK_SIZE           : integer := 256;
		WRD_SIZE 			: integer := 32
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
end component;

begin

i_round: round 
	generic map(
		BLK_SIZE =>256,
		WRD_SIZE =>32
	)
	port map(
		clk              =>clk              ,     -- clock signal
		reset_n          =>reset_n          ,  -- reset_n signal active low	
		i_round_en       =>i_round_en       , --  round enable
		i_round_constant =>i_round_constant ,  -- round constant value from ROM
		i_pre_blck_hash  =>i_pre_blck_hash  ,  -- hash of previous block
		i_msg_blck       =>i_msg_blck       ,  -- Message block
		o_hash           =>o_hash             -- hash output of round
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
		reset_n    <='0';
		i_round_en <='0';
		i_round_constant<= (others=>'0');
		i_pre_blck_hash <= (others=>'0');   
	wait for 15 ns;
		reset_n  <='1';
		i_round_en <= '1';
		i_round_constant<=x"428a2f98";
		i_pre_blck_hash<=x"6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19";
		i_msg_blck<=x"00000018";

	wait for 200 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus	
end round_tb_arc;

