Please read carefully 

 1. RTL Design

 a) Micro architecture is deigned. So if you check round page of microcarchitecture will found
 	all the functions like Ch, Maj, Sigma

 	i) all functions are coded in rtl as package and can be found in
 		/rtl/round_function.vhd
 	
 	ii) rtl//round.vhd	using those functions to implement round

 b)	Message Scheduling block from microarchitecture

 	i) functions are implemented in rtl file as package
 		/rt/message_schdl.vhd

 	ii) /rtl/message_schedule.vhd using package to implement scheduling

 c) round constant keys
 	
 	i) can be found in /rt/round_constant

 d) rtl/data_path.vhd	instantiating all blocks

 e) rtl/cu.vhd implementing controller FSM


 2. Simulation

 	a) All testbenches of the above rtl mention in 1 can be foung under /tb/ directory

 	b) simulation result of each block is also captured in screenshot and can be found uner sim_wave directory

 3. Summary
 
 	project summary document is also provided under Handouts folder.

 Note:
 	to run top simulation run it for 5000ns to get results.


 ....
 Thanks
 Aamir
						
