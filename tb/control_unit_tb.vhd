library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity control_unit_tb is
end control_unit_tb;

architecture control_unit_tb_arc of control_unit_tb is

--
	signal clk        :  std_logic:='1';
	signal reset_n    :  std_logic;
	signal i_start    :  std_logic;
	signal i_cnt_flag :  std_logic;
	signal o_cnt_en   :  std_logic;
	signal o_valid    :  std_logic;
	signal sel_1      :  std_logic;
--
	signal cnt : std_logic_vector (2 downto 0):="000";
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


begin
	i_control_unit :control_unit 
	port map(
		clk        => clk        , -- system clock signal 
		reset_n    => reset_n    , -- system global reset_n active low logic
		i_start    => i_start    , -- To start calculating hash just as enable
		i_cnt_flag => i_cnt_flag , -- FSM state driver flag from counter
		o_cnt_en   => o_cnt_en   , -- counter enable signal as output
		o_valid    => o_valid    ,
		sel_1      => sel_1      
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
		i_start  <='0';   
	wait for 15 ns;
		reset_n  <=	'1';
		i_start  <= '1';
	wait for 10 ns;
		
		fsm_driver : for i in 0 to 7 loop
				wait until (clk'event and clk = '1');
				if (cnt="111") then
					i_cnt_flag<='1';
					
				else
					cnt<=cnt+1;
					i_cnt_flag<='0';		
				end if;
			end loop;	
	wait for 200 ns; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ; -- stimulus
end control_unit_tb_arc;