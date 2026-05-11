library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port (  CLK: in std_logic; 
            START, RST, CONF: in std_logic;  
            NT, NC, NR: out STD_LOGIC;
            TCKT: out STD_LOGIC;
            AN: out std_logic_vector(3 downto 0);
            SEG: out std_logic_vector (6 downto 0);          
            ENH: in std_logic;
            ENT: in std_logic;               
            EN1: in std_logic;
            EN2: in std_logic;
            EN5: in std_logic;
            EN10: in std_logic;
            EN20: in std_logic;
            EN50: in std_logic;
            
            S0, S1, S2, S3, S4, S5, S6: out std_logic
            );
end main;
    
architecture BEHAVIORAL of main is
    
component CU is
     Port ( CLK : in STD_LOGIC;
            START, RST, CONF: in STD_LOGIC;
            NT, NC, NR: out STD_LOGIC;
            TCKT: out STD_LOGIC;
            -- receive what I have to display through an intermediate signal between the EU and CU and then link the output from the CU to the output of main
            iAN_DC, iAN_CC, iAN_CB, iAN_CA: in std_logic_vector(3 downto 0);
            iSEG_DC, iSEG_CC, iSEG_CB, iSEG_CA: in std_logic_vector (6 downto 0);
            LAN: out std_logic_vector(3 downto 0);
            LSEG: out std_logic_vector (6 downto 0);
            NO_TICKETS, NO_CASH, NO_REST: in STD_LOGIC;
            -- receive the enable from main and through an intermediate signal between the CU and EU give feed it to the EU
            iENH, iENT: in std_logic;  
            oENH, oENT: out std_logic;  
            iEN1, iEN2, iEN5, iEN10, iEN20, iEN50: in std_logic;  
            oEN1, oEN2, oEN5, oEN10, oEN20, oEN50: out std_logic;
            GR, EQ: out std_logic;
            EN_TM: out std_logic;
            UPD, CB: in std_logic;
            ERST: out std_logic;
            S0, S1, S2, S3, S4, S5, S6: out std_logic 
            );
end component;
    
component EU is
     Port ( CLK : in std_logic;
            CLK_OUT: out std_logic;
            START, RST, CONF: in STD_LOGIC;
            START_CU, RST_CU, CONF_CU: out STD_LOGIC;
            AN_DC, AN_CC, AN_CB, AN_CA: out std_logic_vector(3 downto 0);
            SEG_DC, SEG_CC, SEG_CB, SEG_CA: out std_logic_vector (6 downto 0);
            NT, NC, NR: out std_logic;
            ENT, ENH: in std_logic;
            EN1, EN2, EN5, EN10, EN20, EN50: in STD_LOGIC;
            GR, EQ: out std_logic;
            EN_TM: in std_logic;
            UPD, CB: out std_logic;
            ERST: in std_logic
           );
end component;
    
    signal clk_wire: std_logic; 
    signal start_wire, rst_wire, conf_wire: std_logic;
    signal no_tickets, no_cash, no_rest: std_logic;
    signal an_wire_dc, an_wire_cc, an_wire_cb, an_wire_ca: std_logic_vector(3 downto 0);
    signal seg_wire_dc, seg_wire_cc, seg_wire_cb, seg_wire_ca: std_logic_vector (6 downto 0);
    signal cu_enh, cu_ent: std_logic;
    signal cu_en1, cu_en2, cu_en5, cu_en10, cu_en20, cu_en50: std_logic;
    signal cash_gr_cost, cash_eq_cost: std_logic;
    signal enable_tm: std_logic;
    signal update_done: std_logic;
    signal end_reset: std_logic;
    signal cash_back: std_logic;
    
begin
    
    EU1: EU port map(CLK => CLK, CLK_OUT => clk_wire, 
                     START => START, RST => RST, CONF => CONF,
                     START_CU => start_wire, RST_CU => rst_wire, CONF_CU => conf_wire,
                     AN_DC => an_wire_dc, AN_CC => an_wire_cc, AN_CB => an_wire_cb, AN_CA => an_wire_ca,
                     SEG_DC => seg_wire_dc, SEG_CC => seg_wire_cc, SEG_CB => seg_wire_cb, SEG_CA => seg_wire_ca,
                     NT => no_tickets, NC => no_cash, NR => no_rest,
                     ENH => cu_enh, ENT => cu_ent, 
                     EN1 => cu_en1, EN2 => cu_en2, EN5 => cu_en5, EN10 => cu_en10, EN20 => cu_en20, EN50 => cu_en50,
                     GR => cash_gr_cost, EQ => cash_eq_cost, EN_TM => enable_tm, UPD => update_done, CB => cash_back, ERST => end_reset
                     );
                        
    CU1: CU port map(CLK => clk_wire,
                     START => start_wire, RST => rst_wire, CONF => conf_wire,
                     NT => NT, NC => NC, NR => NR, 
                     TCKT => TCKT,
                     iAN_DC => an_wire_dc, iAN_CC => an_wire_cc, iAN_CB => an_wire_cb, iAN_CA => an_wire_ca,
                     iSEG_DC => seg_wire_dc, iSEG_CC => seg_wire_cc, iSEG_CB => seg_wire_cb, iSEG_CA => seg_wire_ca,
                     LAN => AN, LSEG => SEG, 
                     NO_TICKETS => no_tickets, NO_CASH => no_cash, NO_REST => no_rest,
                     iENH => ENH, iENT => ENT, oENH => cu_enh, oENT => cu_ent, 
                     iEN1 => EN1, iEN2 => EN2, iEN5 => EN5, iEN10 => EN10, iEN20 => EN20, iEN50 => EN50,
                     oEN1 => cu_en1, oEN2 => cu_en2, oEN5 => cu_en5, oEN10 => cu_en10, oEN20 => cu_en20, oEN50 => cu_en50,
                     GR => cash_gr_cost, EQ => cash_eq_cost, EN_TM => enable_tm, UPD => update_done, CB => cash_back, ERST => end_reset,
                     S0 => S0, S1 => S1, S2 => S2, S3 => S3, S4 => S4, S5 => S5, S6 => S6);
    
end BEHAVIORAL;
