library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EU is
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
end EU;

architecture BEHAVIORAL of EU is

component FREQUENCY_DIVIDER_CU is
    Port (CLK_FAST: in std_logic;
          CLK_SLOW: out std_logic);
end component;  

component BTN_DEBOUNCER is
  Port ( BTN: in std_logic;
         CLK_100: in std_logic;
         BTN_DB: out std_logic);
end component;

component TICKET_MANAGER is
    Port ( CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           NT : out STD_LOGIC
           );
end component;

component DISTANCE_COUNTERS is
    Port ( CLK : in STD_LOGIC;
    
           ENH : in STD_LOGIC;
           ENT : in STD_LOGIC;
           RST : in STD_LOGIC;
           ERST: in std_logic;
           WHOLE: out integer;
           LAN: out std_logic_vector(3 downto 0);
           LSEG: out std_logic_vector (6 downto 0)
         );
end component;
signal DIST_INT: integer;

component COST_COMPUTATION is
        Port ( CLK: in std_logic;
               DIST : in integer;
               
               COST: out integer;
               
               LAN: out std_logic_vector(3 downto 0);
               LSEG: out std_logic_vector (6 downto 0)
             );
end component;
signal COST_INT: integer;

component CASH_BUILDER is
    Port ( CLK: in STD_LOGIC;
           RST: in std_logic;
           ERST: in std_logic;
           MEN: in STD_LOGIC; -- master enable
           NC: out STD_LOGIC;
           TOTAL_CASH: out integer;
           
           EN1, EN2, EN5, EN10, EN20, EN50: in STD_LOGIC;
           CASH_VECTOR: out STD_LOGIC_VECTOR(23 DOWNTO 0);
           LAN: out std_logic_vector(3 downto 0);
           LSEG: out std_logic_vector (6 downto 0)
           );
end component;
signal TC: integer;
signal CASH_VECTOR: STD_LOGIC_VECTOR(23 DOWNTO 0);

component INPUT_BILL_LOCK is
    Port ( CASH: in integer;
           COST: in integer;
           LOCK: out std_logic;
           EQUAL: out std_logic          
           );
end component;
signal LME: std_logic;
signal EQUAL: std_logic;

component CHANGE_ALG is
    Port ( CLK : in STD_LOGIC;
           
           CASH: in integer;
           COST: in integer;
           MONEY_VECTOR : in STD_LOGIC_VECTOR (47 downto 0);
           REST_VECTOR: out STD_LOGIC_VECTOR (23 downto 0);
           NR, CB : out STD_LOGIC;
           
           LAN: out std_logic_vector(3 downto 0);
           LSEG: out std_logic_vector(6 downto 0));
end component;
signal REST_VECTOR: STD_LOGIC_VECTOR (23 downto 0);

-- count up enables
signal EU1, EU2, EU5, EU10, EU20, EU50 : STD_LOGIC;
-- count down enables
signal ED1, ED2, ED5, ED10, ED20, ED50 : STD_LOGIC;
component MONEY_BUILDER is
    Port ( CLK : in STD_LOGIC;          
           -- count up enables
           EU1, EU2, EU5, EU10, EU20, EU50 : in STD_LOGIC;
           -- count down enables
           ED1, ED2, ED5, ED10, ED20, ED50 : in STD_LOGIC;
           
           MONEY_VECTOR: out std_logic_vector(47 downto 0)
           );
end component;
signal MONEY_VECTOR: std_logic_vector(47 downto 0);

component MONEY_UPDATE is
    Port ( CLK : in STD_LOGIC;
           EQ : in std_logic;
           CASH_VECTOR : in STD_LOGIC_VECTOR (23 downto 0);
           REST_VECTOR : in STD_LOGIC_VECTOR (23 downto 0);
           EU1, EU2, EU5, EU10, EU20, EU50 : out STD_LOGIC;   
           ED1, ED2, ED5, ED10, ED20, ED50 : out STD_LOGIC;
           UPDATE_DONE: out std_logic
           );
end component;

begin
    -- the CU should run on a divided clock
    FDCU: FREQUENCY_DIVIDER_CU port map(CLK_FAST => CLK, CLK_SLOW => CLK_OUT);
    
    -- BD: debounce each button and then feed the output to the CU
    BD1: BTN_DEBOUNCER port map(BTN => START, CLK_100 => CLK, BTN_DB => START_CU);
    BD2: BTN_DEBOUNCER port map(BTN => CONF, CLK_100 => CLK, BTN_DB => CONF_CU);
    BD3: BTN_DEBOUNCER port map(BTN => RST, CLK_100 => CLK, BTN_DB => RST_CU);

    -- TICKET MANAGER: the EN is commanded by the CU and NT is outputed for the CU
    TM: TICKET_MANAGER port map(CLK => CLK, EN => EN_TM, NT => NT);
    -- DISTANCE COUNTERS: ENH & ENT are commanded by the CU; AN & SEG are used for the display and DIST_INT will be further used in the CC
    DC: DISTANCE_COUNTERS port map(CLK => CLK, ENT => ENT, ENH => ENH, RST => RST, ERST => ERST, WHOLE => DIST_INT, LAN => AN_DC, LSEG => SEG_DC);
    -- COST COMPUTATION: the COST is computed based on DIST_INT and outputed through COST_INT that will be further used in the IBL
    CC: COST_COMPUTATION port map(CLK => CLK, DIST => DIST_INT, COST => COST_INT, LAN => AN_CC, LSEG => SEG_CC);
    -- INPUT BILL LOCK: the inputs are the COST and the inputed CASH as an integer; on the outputs I receive a LOCK that will be used to block the inputs in the CB once the sum is met and another that signal that the sum is equal to the inputed one
    IBL: INPUT_BILL_LOCK port map(CASH => TC, COST => COST_INT, LOCK => LME, EQUAL => EQUAL); GR <= LME; EQ <= EQUAL;
    -- CASH BUILDER: the enables are commanded by the CU; the CASH_VECTOR is saved for further is in the CA, a led is lit until the right amount of cash is inputed, and the enable inputs are locked if the sum is met with the LME input
    CB1: CASH_BUILDER port map(CLK => CLK, RST => RST, ERST => ERST, MEN => LME, NC => NC, TOTAL_CASH => TC,
                            EN1 => EN1, EN2 => EN2, EN5 => EN5, EN10 => EN10, EN20 => EN20, EN50 => EN50,
                            CASH_VECTOR => CASH_VECTOR, LAN => AN_CB, LSEG => SEG_CB);               
    -- CHANGE ALGORITHM:
    CA: CHANGE_ALG port map(CLK => CLK,
                             CASH => TC, COST => COST_INT, 
                             MONEY_VECTOR => MONEY_VECTOR, REST_VECTOR => REST_VECTOR,
                             NR => NR, CB => CB, LAN => AN_CA, LSEG => SEG_CA);
    -- MONEY BUILDER: the count up enables are activared before the issue of the ticket, since I must update what is in th automata using the inputed money
    -- count down enables are used when the rest is issued and the total amount of each type of bill that is inside the automata is kept in MONEY_VECTOR
    MB: MONEY_BUILDER port map(CLK => CLK,
                                EU1 => EU1, EU2 => EU2, EU5 => EU5, EU10 => EU10, EU20 => EU20, EU50 => EU50,
                                ED1 => ED1, ED2 => ED2, ED5 => ED5, ED10 => ED10, ED20 => ED20, ED50 => ED50,
                                MONEY_VECTOR => MONEY_VECTOR);
    -- MONEY UPDATE:                           
    MU: MONEY_UPDATE port map(CLK => CLK, EQ => EQUAL,
                                CASH_VECTOR => CASH_VECTOR, REST_VECTOR => REST_VECTOR,
                                EU1 => EU1, EU2 => EU2, EU5 => EU5, EU10 => EU10, EU20 => EU20, EU50 => EU50,
                                ED1 => ED1, ED2 => ED2, ED5 => ED5, ED10 => ED10, ED20 => ED20, ED50 => ED50,
                                UPDATE_DONE => UPD);

end BEHAVIORAL;
