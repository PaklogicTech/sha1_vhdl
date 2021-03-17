library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package msg_schdl_functions is
	function alpha_0(x : std_logic_vector) return std_logic_vector;
	function alpha_1(x : std_logic_vector) return std_logic_vector;
end package msg_schdl_functions;

package body msg_schdl_functions is
	function alpha_0(x : std_logic_vector) return std_logic_vector is
	begin
		return std_logic_vector(rotate_right(unsigned(x), 7) xor rotate_right(unsigned(x), 18) xor shift_right(unsigned(x), 3));
	end function alpha_0;

	function alpha_1(x : std_logic_vector) return std_logic_vector is
	begin
		return std_logic_vector(rotate_right(unsigned(x), 17) xor rotate_right(unsigned(x), 19) xor shift_right(unsigned(x), 10));
	end function alpha_1;
end package body msg_schdl_functions; -- msg_schdl_functions
