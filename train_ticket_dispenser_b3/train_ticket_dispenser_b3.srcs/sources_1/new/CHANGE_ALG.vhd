library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
            
entity CHANGE_ALG is
    Port ( CLK : in STD_LOGIC;
        --  CASH: in integer;
        --  COST: in integer;
        --  MONEY_VECTOR : in STD_LOGIC_VECTOR (47 downto 0);
        --  REST_VECTOR: out STD_LOGIC_VECTOR (23 downto 0);
          NR, CB : out STD_LOGIC;
                       
          LAN: out std_logic_vector(3 downto 0);
          LSEG: out std_logic_vector(6 downto 0)
           );
end CHANGE_ALG;
            
architecture BEHAVIORAL of CHANGE_ALG is
 
-- SIGNALS USED FOR DEBUGGING --   
signal CASH: integer := 100;
signal COST: integer := 88;
signal MONEY_VECTOR : STD_LOGIC_VECTOR (47 downto 0) := "111111111111111111111111111111111111111111111111";
signal REST_VECTOR : std_logic_vector (23 downto 0);    
    
signal COSTX: integer := 0;
signal DONE: std_logic := '0'; -- this will signal when the algorithm is done
signal CASH_BACK: std_logic := '0'; -- this will signal that the rest can't be given and the cash must be given back
            
-- store the amount of each type of bull in another auxiliary signal
signal bill_1, bill_2, bill_5, bill_10, bill_20, bill_50: std_logic_vector (7 downto 0); 
            
signal REST: integer := 0;
type integer_vector is array (0 to 5) of integer;
constant BILL_VALUES : integer_vector := (1, 2, 5, 10, 20, 50); 
-- store the amount of each type of bill that is given as rest
signal rest_1, rest_2, rest_5, rest_10, rest_20, rest_50: std_logic_vector (3 downto 0) := "0000";
            
signal HUN, TEN, UNIT: integer := 0;
component INT_TO_CAT_CONVERTER is
        Port ( INT : in integer;
            CAT : out STD_LOGIC_VECTOR (6 downto 0));
end component;
signal HC, TC, UC: std_logic_vector(6 downto 0);
            
component THREE_DIGIT_SSD is
        Port ( CLK : in STD_LOGIC;
                
            DIGI1: in std_logic_vector (6 downto 0);
            DIGI2: in std_logic_vector (6 downto 0);
            DIGI3: in std_logic_vector (6 downto 0);
                       
            AN: out std_logic_vector (3 downto 0);
            SEG: out std_logic_vector (6 downto 0)
            );
end component;
signal STATE, NEXT_STATE: std_logic_vector (2 downto 0);

component FREQUENCY_DIVIDER is
    Port (CLK_FAST: in std_logic;
          CLK_SLOW: out std_logic);
end component;
signal CLK_OUT: std_logic;
signal show, next_show: std_logic_vector(2 downto 0);
begin



process (CLK)
begin
    if DONE = '0' then
        if rising_edge (CLK) then
            STATE <= NEXT_STATE;
        end if;
    end if;
end process;
       
process (STATE)
begin
    case STATE is
        when "000" => -- Init
            CB <= '0';
            NEXT_STATE <= "001";
        when "001" => -- Try 50
            if COSTX + 50 <= CASH and bill_50 > 0 then
                NEXT_STATE <= "001";
            else
                NEXT_STATE <= "010";
            end if;
        when "010" => -- Try 20
            if (COSTX + 20 <= CASH) and (bill_20 > "0000") then
                NEXT_STATE <= "010";
            else
                NEXT_STATE <= "011";
            end if;
        when "011" => -- Try 10
            if (COSTX + 10 <= CASH) and (bill_10 > "0000") then
                NEXT_STATE <= "011";
            else
                NEXT_STATE <= "100";        
            end if;
        when "100" => -- Try 5
            if (COSTX + 5 <= CASH) and (bill_5 > "0000") then
                NEXT_STATE <= "100";
            else
                NEXT_STATE <= "101";
            end if;
        when "101" => -- Try 2
            if (COSTX + 2 <= CASH) and (bill_2 > "0000") then
                NEXT_STATE <= "101";
            else
                NEXT_STATE <= "110";
            end if;
        when "110" => -- Try 1
            if (COSTX + 1 <= CASH) and (bill_1 > "0000") then
                NEXT_STATE <= "110";
            else
                NEXT_STATE <= "111";
            end if;
        when "111" => -- Done
            DONE <= '1';
            if COSTX /= CASH then
                CASH_BACK <= '1';
                CB <= '1';
                NR <= '1';
            end if;
            NEXT_STATE <= "111";
    end case;
end process;

process (CLK)
begin
    if rising_edge (CLK) and DONE = '0' then
        case STATE is
            when "000" =>

                COSTX <= COST;    
                rest_1 <= "0000"; rest_2 <= "0000"; rest_5 <= "0000";
                rest_10 <= "0000"; rest_20 <= "0000"; rest_50 <= "0000";
                bill_1 <= MONEY_VECTOR(7 downto 0);
                bill_2 <= MONEY_VECTOR(15 downto 8);
                bill_5 <= MONEY_VECTOR(23 downto 16);
                bill_10 <= MONEY_VECTOR(31 downto 24);
                bill_20 <= MONEY_VECTOR(39 downto 32);
                bill_50 <= MONEY_VECTOR(47 downto 40);
            when "001" =>
                if(COSTX + 50 <= CASH) and (bill_50 > "00000000") then
                    COSTX <= COSTX + 50;
                    bill_50 <= bill_50 - 1;
                    rest_50 <= rest_50 + 1;
                end if;
            when "010" =>
                if(COSTX + 20 <= CASH) and (bill_20 > "00000000") then
                    COSTX <= COSTX + 20;
                    bill_20 <= bill_20 - 1;
                    rest_20 <= rest_20 + 1;
                end if;
           when "011" =>
                if(COSTX + 10 <= CASH) and (bill_10 > "00000000") then
                    COSTX <= COSTX + 10;
                    bill_10 <= bill_10 - 1;
                    rest_10 <= rest_10 + 1;
                end if;
           when "100" =>
                if(COSTX + 5 <= CASH) and (bill_50 > "00000000") then
                    COSTX <= COSTX + 5;
                    bill_5 <= bill_5 - 1;
                    rest_5 <= rest_5 + 1;
                end if;
           when "101" =>
                if(COSTX + 2 <= CASH) and (bill_2 > "00000000") then
                    COSTX <= COSTX + 2;
                    bill_2 <= bill_2 - 1;
                    rest_2 <= rest_2 + 1;
                end if;
           when "110" =>
                if(COSTX + 1 <= CASH) and (bill_1 > "00000000") then
                    COSTX <= COSTX + 1;
                    bill_1 <= bill_1 - 1;
                    rest_1 <= rest_1 + 1;
                end if;
           when others =>
                NULL;
           end case;
      end if;                      
end process;
 
-- compose the rest vector by concatenating the rest subvectors
REST_VECTOR <= rest_50 & rest_20 & rest_10 & rest_5 & rest_2 & rest_1;
       
-- initial way to display as a whole
             
--process(CLK)
--begin
--    if rising_edge (CLK) then
--        if DONE = '1' then
--            if CASH_BACK = '1' then
--                REST <= CASH; -- must give the cash back 
--            else
--                -- compose the rest out of the vectors
--                REST <= conv_integer(rest_1) * BILL_VALUES(0) + 
--                conv_integer(rest_2) * BILL_VALUES(1) + 
--                conv_integer(rest_5) * BILL_VALUES(2) + 
--                conv_integer(rest_10) * BILL_VALUES(3) + 
--                conv_integer(rest_20) * BILL_VALUES(4) + 
--                conv_integer(rest_50) * BILL_VALUES(5);
--            end if;
                        
--            -- break the number in parts
--            HUN <= REST/100;
--            TEN <= REST/10 mod 10;
--            UNIT <= REST mod 10;
    
--        end if;
--    end if;  
--end process;

-- component specific way to show every type of bill
FD: FREQUENCY_DIVIDER port map (CLK_FAST => CLK, CLK_SLOW => CLK_OUT);
             
process(DONE, CLK_OUT)
begin
      if DONE = '1' then
            if rising_edge (CLK_OUT) then
                show <= next_show;  
            end if;
      end if;
end process;

process(show)
begin
    case show is
        when "000" => -- display rest_1
                HUN <= conv_integer (rest_1);
                UNIT <= 1;
            next_show <= "001";
        when "001" => -- display rest_2
                HUN <= conv_integer (rest_2);
                UNIT <= 2;
            next_show <= "010";      
        when "010" => -- display rest_5
                HUN <= conv_integer (rest_5);
                UNIT <= 5;
            next_show <= "011";
        when "011" => -- display rest_10
                HUN <= conv_integer (rest_10);
                TEN <= 1;
                UNIT <= 0;      
           next_show <= "100";
        when "100" => -- display rest_20
                HUN <= conv_integer (rest_20);
                TEN <= 2;
                UNIT <= 0;
            next_show <= "101";            
        when "101" => -- display rest_50
                HUN <= conv_integer (rest_50);
                TEN <= 5;
                UNIT <= 0;
            next_show <= "110";
        when others =>
            null; 
    end case;
end process; 
     
-- convert the digits of the number in their SSD equivalent
ITCC1: INT_TO_CAT_CONVERTER port map (INT => HUN, CAT => HC);
ITCC2: INT_TO_CAT_CONVERTER port map (INT => TEN, CAT => TC);
ITCC3: INT_TO_CAT_CONVERTER port map (INT => UNIT, CAT => UC);
                
-- display the number
TDSSD: THREE_DIGIT_SSD port map (CLK => CLK, DIGI1 => UC, DIGI2 => TC, DIGI3 => HC, AN => LAN, SEG => LSEG);

end BEHAVIORAL;
