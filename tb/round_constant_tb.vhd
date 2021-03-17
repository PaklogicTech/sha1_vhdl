library ieee;
--library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
--use work.round_functions.all;
--use work.msg_schdl_functions.all;

entity round_constant_tb is
end round_constant_tb;

architecture round_constant_arc of round_constant_tb is

--
	signal ADDR_WTH : integer := 6;
	signal WRD_SIZE : integer := 32;
--
	signal clk              : std_logic :='1';                              --clk signal
	signal reset_n          : std_logic ;                              --reset_n signal
	signal enable           : std_logic ;                              -- enable signal
	signal add              : std_logic_vector (5 downto 0) :="000000"; -- address as counter value to read rc
	signal o_round_constant : std_logic_vector (31 downto 0);   --round_constant for each round

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

begin
	i_rc: round_constant 
	generic map(
		ADDR_WTH =>6,
		WRD_SIZE =>32

	)
	port map(
		clk              =>clk             , --clk signal
		reset_n          =>reset_n         , --reset_n signal
		enable           =>enable          , -- enable signal
		add              =>add             , -- address as counter value to read rc
		o_round_constant =>o_round_constant --round_constant for each round
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
		enable <='0';   
	wait for 15 ns;
		reset_n  <='1';
		enable <='1';
	wait for 	10 ns;
	sel_add : for i in 0 to 63 loop
			wait until (clk'event and clk = '1');
		add    <= add+1;
	end loop; --add_switch
	
	wait for 200 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus
end round_constant_arc;

