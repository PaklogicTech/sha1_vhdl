library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- include the package files here
use work.round_functions.all;
use work.msg_schdl_functions.all;

entity round_constant is
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
end round_constant;

architecture behav of round_constant is
signal i : integer;
begin

	rc : process (reset_n, clk)
	begin
		if (reset_n = '0') then
			o_round_constant <= x"00000000";
		elsif (rising_edge(clk)) then
			if (enable = '1') then
				case(to_integer(unsigned(add))) is
					 when 0 => o_round_constant<= x"428a2f98" ;
					 when 1  => o_round_constant<= x"71374491" ;
					 when 2  => o_round_constant<= x"b5c0fbcf" ;
					 when 3  => o_round_constant<= x"e9b5dba5" ;
					 when 4  => o_round_constant<= x"3956c25b" ;
					 when 5  => o_round_constant<= x"59f111f1" ;
					 when 6  => o_round_constant<= x"923f82a4" ;
					 when 7  => o_round_constant<= x"ab1c5ed5" ;
					 when 8  => o_round_constant<= x"d807aa98" ;
					 when 9  => o_round_constant<= x"12835b01" ;
					 when 10 => o_round_constant <= x"243185be" ;
					 when 11 => o_round_constant <= x"550c7dc3" ;
					 when 12 => o_round_constant <= x"72be5d74" ;
					 when 13 => o_round_constant <= x"80deb1fe" ;
					 when 14 => o_round_constant <= x"9bdc06a7" ;
					 when 15 => o_round_constant <= x"c19bf174" ;
					 when 16 => o_round_constant <= x"e49b69c1" ;
					 when 17 => o_round_constant <= x"efbe4786" ;
					 when 18 => o_round_constant <= x"0fc19dc6" ;
					 when 19 => o_round_constant <= x"240ca1cc" ;
					 when 20 => o_round_constant <= x"2de92c6f" ;
					 when 21 => o_round_constant <= x"4a7484aa" ;
					 when 22 => o_round_constant <= x"5cb0a9dc" ;
					 when 23 => o_round_constant <= x"76f988da" ;
					 when 24 => o_round_constant <= x"983e5152" ;
					 when 25 => o_round_constant <= x"a831c66d" ;
					 when 26 => o_round_constant <= x"b00327c8" ;
					 when 27 => o_round_constant <= x"bf597fc7" ;
					 when 28 => o_round_constant <= x"c6e00bf3" ;
					 when 29 => o_round_constant <= x"d5a79147" ;
					 when 30 => o_round_constant <= x"06ca6351" ;
					 when 31 => o_round_constant <= x"14292967" ;
					 when 32 => o_round_constant <= x"27b70a85" ;
					 when 33 => o_round_constant <= x"2e1b2138" ;
					 when 34 => o_round_constant <= x"4d2c6dfc" ;
					 when 35 => o_round_constant <= x"53380d13" ;
					 when 36 => o_round_constant <= x"650a7354" ;
					 when 37 => o_round_constant <= x"766a0abb" ;
					 when 38 => o_round_constant <= x"81c2c92e" ;
					 when 39 => o_round_constant <= x"92722c85" ;
					 when 40 => o_round_constant <= x"a2bfe8a1" ;
					 when 41 => o_round_constant <= x"a81a664b" ;
					 when 42 => o_round_constant <= x"c24b8b70" ;
					 when 43 => o_round_constant <= x"c76c51a3" ;
					 when 44 => o_round_constant <= x"d192e819" ;
					 when 45 => o_round_constant <= x"d6990624" ;
					 when 46 => o_round_constant <= x"f40e3585" ;
					 when 47 => o_round_constant <= x"106aa070" ;
					 when 48 => o_round_constant <= x"19a4c116" ;
					 when 49 => o_round_constant <= x"1e376c08" ;
					 when 50 => o_round_constant <= x"2748774c" ;
					 when 51 => o_round_constant <= x"34b0bcb5" ;
					 when 52 => o_round_constant <= x"391c0cb3" ;
					 when 53 => o_round_constant <= x"4ed8aa4a" ;
					 when 54 => o_round_constant <= x"5b9cca4f" ;
					 when 55 => o_round_constant <= x"682e6ff3" ;
					 when 56 => o_round_constant <= x"748f82ee" ;
					 when 57 => o_round_constant <= x"78a5636f" ;
					 when 58 => o_round_constant <= x"84c87814" ;
					 when 59 => o_round_constant <= x"8cc70208" ;
					 when 60 => o_round_constant <= x"90befffa" ;
					 when 61 => o_round_constant <= x"a4506ceb" ;
					 when 62 => o_round_constant <= x"bef9a3f7" ;
					 when 63 => o_round_constant <= x"c67178f2" ;

					when others =>
						o_round_constant<=x"00000000";
				end case;

			end if;
		end if;
	end process rc;

end architecture behav;

