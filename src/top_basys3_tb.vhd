--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : top_basys3_tb.vhd
--| AUTHOR(S)     : Capt Johnson
--| CREATED       : 01/30/2019 Last Modified 06/24/2020
--| DESCRIPTION   : This file implements a test bench for the full adder top level design.
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : top_basys3.vhd
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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_basys3_tb is
end top_basys3_tb;

architecture test_bench of top_basys3_tb is 
	
  -- declare the component of your top-level design unit under test (UUT)
  component top_basys3 is
	port(
		-- Switches
		sw		:	in  std_logic_vector(8 downto 0);
		
		-- LEDs
		led	    :	out	std_logic_vector(15 downto 0)
	);
	end component top_basys3;
  
 
	-- declare signals needed to stimulate the UUT inputs
	signal w_sw    : std_logic_vector(7 downto 0) := x"00";
	signal w_sum   : std_logic_vector(3 downto 0) := x"0";
	signal w_Cin, w_Cout : std_logic;
	signal w_other_led : std_logic_vector(10 downto 0);

begin
	-- PORT MAPS ----------------------------------------
	top_basys3_uut : top_basys3 port map (
	   sw(8 downto 1)  => w_sw,
	   sw(0)           => w_Cin, 
	   led(3 downto 0) => w_sum,
	   led(15)         => w_Cout,
	   led(14 downto 4) => w_other_led
	);
	
	-- PROCESSES ----------------------------------------	
	-- Test Plan Process
	-- Implement the test plan here.  Body of process is continuously from time = 0  
	test_process : process 
	begin
	
	   -- Test all zeros input
	   w_sw <= x"00"; w_Cin <= '0'; wait for 10 ns;
	       assert (w_sum = x"0" and w_Cout = '0') report "bad with zeros" severity failure;
       -- Test all ones input
       -- TODO
	   w_sw <= x"FF"; w_Cin <= '1'; wait for 10 ns;
           assert (w_sum = x"F" and w_Cout = '1') report "bad all ones" severity failure;	   
	   -- A few other test cases
	   -- TODO 	
	   w_sw <= x"00"; w_Cin <= '1'; wait for 10 ns;
           assert (w_sum = x"1" and w_Cout = '0') report "bad 0 + 0 + 1" severity failure;    
	   w_sw <= x"22"; w_Cin <= '1'; wait for 10 ns;
               assert (w_sum = x"5" and w_Cout = '0') report "bad 2 + 2 + 1" severity failure;              
 	   w_sw <= x"2F"; w_Cin <= '0'; wait for 10 ns;
               assert (w_sum = x"1" and w_Cout = '1') report "bad 2 minus 1" severity failure;          	
	   assert true = false report "all tests worked" severity failure;
	end process;	
	-----------------------------------------------------	
	
end test_bench;
