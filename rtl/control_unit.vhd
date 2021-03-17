library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity control_unit is
	port (
		clk        : in  std_logic; -- system clock signal 
		reset_n    : in  std_logic; -- system global reset_n active low logic
		i_start    : in  std_logic; -- To start calculating hash just as enable
		i_cnt_flag : in  std_logic; -- FSM state driver flag from counter
		o_cnt_en   : out std_logic; -- counter enable signal as output
		o_valid    : out std_logic;
		sel_1      : out std_logic
	);
end control_unit;

architecture control_unit_arc of control_unit is

	-----------------------------------------------------------------------------
	--  Control unit FSM states
	-----------------------------------------------------------------------------

	type control_logic is
		(
			IDLE ,
			RESET,
			BUSY,
			DONE
		);

	signal current_state : control_logic;
	signal next_state    : control_logic;
	signal re_reg        : std_logic;
	signal addrout_reg   : std_logic_vector (7 downto 0);
begin
	--------------------------------------------------------------------------------
	-- State Initialization
	--------------------------------------------------------------------------------

	stat_init : process(clk,reset_n)
	begin
		if(reset_n='0') then
			current_state <= IDLE;
		elsif(rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process; -- stat_init

	stat_tranistion : process(current_state,i_start,i_cnt_flag)
	begin
		case(current_state) is
			when IDLE =>
				next_state <= RESET;
			when RESET =>
				if (i_start='1') then
					next_state <= BUSY;
				else
					next_state <= RESET;
				end if;
			when BUSY =>
				if (i_cnt_flag='1') then
					next_state <= DONE;
				else
					next_state <= BUSY;
				end if;
			when DONE =>
				next_state <= IDLE;
			when others =>
				next_state <= IDLE;
		end case;
	end process stat_tranistion;

	stat_assignment : process( current_state )
	begin
		case(current_state) is
			when IDLE =>
				o_cnt_en <= '0';
				o_valid  <= '0';
				sel_1    <= '0';

			when RESET =>

				o_cnt_en <= '0';
				o_valid  <= '0';
				sel_1    <= '0';
			when BUSY =>
				o_cnt_en <= '1';
				o_valid  <= '0';
				sel_1    <= '0';
			when DONE =>
				o_cnt_en <= '0';
				o_valid  <= '1';
				sel_1    <= '1';

			when others =>
				o_cnt_en <= '0';
				o_valid  <= '0';
				sel_1    <= '0';
		end case;
	end process ; -- 	stat_assignment
end control_unit_arc;