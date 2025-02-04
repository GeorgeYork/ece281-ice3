--+----------------------------------------------------------------------------
--| 
--| DESCRIPTION   : This file implements the top level module for a BASYS 
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--|     Ripple-Carry Adder: Sum = A + B
--|         A is 4-bit on sw(4 downto 1)
--|         B is 4-bit on sw(8 downto 5)
--|         Cin is 1-bit on sw(0)
--|         Sum is 4-bit on led(3 downto 0)
--|         Cout is 1-bit on led(15)
--|
--+----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
	port(
		-- Switches
		sw		:	in  std_logic_vector(8 downto 0);
		
		-- LEDs
		led	    :	out	std_logic_vector(15 downto 0)
	);
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
	
    -- declare the component of your top-level design
    component full_adder is
        port (
            i_A     : in std_logic;
            i_B     : in std_logic;
            i_Cin   : in std_logic;
            o_S     : out std_logic;
            o_Cout  : out std_logic
            );
        end component full_adder;
  -- declare any signals you will need	
      signal w_A, w_B, w_Sum : STD_LOGIC_VECTOR(3 downto 0); -- for sw inputs to operands
      signal w_carry  : STD_LOGIC_VECTOR(3 downto 0); -- for ripple between adders
begin
	-- PORT MAPS --------------------
    full_adder_0: full_adder
    port map(
        i_A     => w_A(0),
        i_B     => w_B(0),
        i_Cin   => sw(0),   -- Directly to input here
        o_S     => w_Sum(0),
        o_Cout  => w_carry(0)
    );

    full_adder_1: full_adder
    port map(
        i_A     => w_A(1),
        i_B     => w_B(1),
        i_Cin   => w_carry(0),
        o_S     => w_Sum(1),
        o_Cout  => w_carry(1)
    );  

    full_adder_2: full_adder
    port map(
            i_A     => w_A(2),
            i_B     => w_B(2),
            i_Cin   => w_carry(1),
            o_S     => w_Sum(2),
            o_Cout  => w_carry(2)
     );  
     
    full_adder_3: full_adder
     port map(
             i_A     => w_A(3),
             i_B     => w_B(3),
             i_Cin   => w_carry(2),
             o_S     => w_Sum(3),
             o_Cout  => led(15) -- hook directly to led
      ); 
	---------------------------------
	
	-- CONCURRENT STATEMENTS --------
	-- TODO: w_A, w_B, led(3 downto 0)
	led(14 downto 4) <= (others => '0'); -- Ground unused LEDs
	w_A <= sw(4 downto 1);
    w_B <= sw(8 downto 5);
    led(3 downto 0) <= w_Sum;
	---------------------------------
end top_basys3_arch;
