library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
package round_functions is

   -- Random mathematical functions used in round:
   function Ch(e, f, g : std_logic_vector) return std_logic_vector;
   function Maj(a, b, c : std_logic_vector) return std_logic_vector;

   -- Big sigma functions, using S because of lacking Unicode support:
   function sigma_a(a : std_logic_vector) return std_logic_vector;
   function sigma_e(e : std_logic_vector) return std_logic_vector;
   function cs (i_csa, i_csb: std_logic_vector) return std_logic_vector;


end package round_functions;


package body round_functions is

function Ch(e, f, g : std_logic_vector) return std_logic_vector is
   begin
      return (e and f) xor ((not e) and g);
   end function Ch;

   function Maj(a, b, c : std_logic_vector) return std_logic_vector is
   begin
      return (a and b) xor (a and c) xor (b and c);
   end function Maj;

   function sigma_a(a : std_logic_vector) return std_logic_vector is
   begin
      return std_logic_vector(rotate_right(unsigned(a), 2) xor rotate_right(unsigned(a), 13) xor rotate_right(unsigned(a), 22));
   end function sigma_a;

      function sigma_e(e : std_logic_vector) return std_logic_vector is
   begin
      return std_logic_vector(rotate_right(unsigned(e), 6) xor rotate_right(unsigned(e), 11) xor rotate_right(unsigned(e), 25));
   end function sigma_e;

function cs (i_csa, i_csb: std_logic_vector) return std_logic_vector is
begin
      
   return std_logic_vector(i_csa + i_csb);
end function;

end package body round_functions;   