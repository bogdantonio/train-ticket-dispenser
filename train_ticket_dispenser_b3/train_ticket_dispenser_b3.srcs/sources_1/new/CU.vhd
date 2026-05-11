library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU is
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
           GR, EQ: in std_logic;
           EN_TM: out std_logic;
           UPD, CB: in std_logic;
           ERST: out std_logic;
           S0, S1, S2, S3, S4, S5, S6: out std_logic
          );
end CU;

architecture BEHAVIORAL of CU is

signal STATE, NEXT_STATE: std_logic_vector(3 downto 0);
signal display_sel: std_logic_vector(2 downto 0);
signal neutral_an: std_logic_vector(3 downto 0) := "1000";
signal neutral_seg: std_logic_vector(6 downto 0) := "1000000";
signal RE_CONF, SHORT_CONF: std_logic;
begin

process (CLK)
begin
    if rising_edge (CLK) then
        RE_CONF <= CONF;
    end if;
end process;
SHORT_CONF <= CONF and not RE_CONF;

UPDATE_STATE: process(CLK, RST)
begin
    if RST = '1' then 
        STATE <= "0000";   
    elsif rising_edge (CLK) then
        STATE <= NEXT_STATE;
    end if;
end process;

TRANSITIONS: process(STATE)
begin
    -- DEFAULT VALUES
            NT <= '0'; NC <= '0'; NR <= '0'; 
            TCKT <= '0';
            oENH <= '0'; oENT <= '0';
            oEN1 <= '0'; oEN2 <= '0'; oEN5 <= '0';
            oEN10 <= '0'; oEN20 <= '0'; oEN50 <= '0';
            EN_TM <= '0';
            
            S0 <= '0'; S1 <= '0'; S2 <= '0';
            S3 <= '0'; S4 <= '0'; S5 <= '0';
            S6 <= '0';
    case STATE is
        
        when "0000" => -- INIT STATE
            ERST <= '0';
            NEXT_STATE <= "0001";
        when "0001" => -- IDLE
            if START = '1' then 
                NEXT_STATE <= "0010";
            else
                NEXT_STATE <= "0001";
            end if; 
            S0 <= '1'; 
        when "0010" => -- CT: check tickets
            if NO_TICKETS = '0' then 
                NEXT_STATE <= "0011";
            else 
                NT <= '1';
                if SHORT_CONF = '1' then
                    NEXT_STATE <= "0001";
                else
                    NEXT_STATE <= "0010";
                end if;
            end if;
            S1 <= '1';        
        when "0011" => -- IND: input & display distance
            oENH <= iENH; oENT <= iENT;
            if SHORT_CONF = '1' then 
                NEXT_STATE <= "0100";
            else
                NEXT_STATE <= "0011";
            end if;
            S2 <= '1';
        when "0100" => -- CC: compute & display cost
            if SHORT_CONF = '1' then
                NEXT_STATE <= "0101";  -- move to cash input
            else
                NEXT_STATE <= "0100";  -- wait here      
            end if;
            S3 <= '1';
        when "0101" => -- INC: input & display cash
            oEN1 <= iEN1; oEN2 <= iEN2; oEN5 <= iEN5;
            oEN10 <= iEN10; oEN20 <= iEN20; oEN50 <= iEN50;
            if SHORT_CONF = '1' and NO_CASH = '0' then 
                NEXT_STATE <= "0110";
            else
                NEXT_STATE <= "0101";
            end if;
            NC <= NO_CASH;
            S4 <= '1';
        when "0110" => -- CCC: COMPARE CASH - COST
            if EQ = '1' then
                NEXT_STATE <= "1000"; -- issue ticket 
            elsif GR = '1' then
                NEXT_STATE <= "0111"; -- give rest
            else
                NC <= '1';
                NEXT_STATE <= "0110";
            S5 <= '1';
            end if;
        
        when "0111" => -- GR: GIVE REST
            if SHORT_CONF = '1' then
                if CB = '1' then
                    ERST <= '1';
                    NEXT_STATE <= "0000"; -- cash back so go back to start
                else
                    NEXT_STATE <= "1000";  -- issue ticket
                end if;
            else
                NEXT_STATE <= "0111";  -- wait here
            end if;
            S6 <= '1';
            
        when "1000" => -- ticket issue
            TCKT <= '1';
            EN_TM <= '1';
            if SHORT_CONF = '1' then
                NEXT_STATE <= "1001";
            else
                NEXT_STATE <= "1000";
            end if;     
        when "1001" => -- update money counter
            if UPD = '1' then 
                ERST <= '1';
                NEXT_STATE <= "0000";
            else
                NEXT_STATE <= "1001";
            end if;
        when others => 
            null;
    end case;
end process;

-- process to route only one SSD output pair to main
process(display_sel, iAN_DC, iAN_CC, iAN_CB)
begin
    LAN <= (others => '1'); LSEG <= (others => '1');
    case display_sel is
        when "000" => LAN <= iAN_DC; LSEG <= iSEG_DC; -- DISTANCE COUNTERS DISPLAY
        when "001" => LAN <= iAN_CC; LSEG <= iSEG_CC; -- COST COMPUTATION DISPLAY
        when "010" => LAN <= iAN_CB; LSEG <= iSEG_CB; -- CASH BUILDER DISPLAY
        when "011" => LAN <= iAN_CA; LSEG <= iSEG_CA; -- CHANGE ALGORITHM DISPLAY
        when others => LAN <= neutral_an; LSEG <= neutral_seg; -- neutral display: "000"
    end case;
end process;

display_sel <= "000" when STATE = "0011" else
               "001" when STATE = "0100" else
               "010" when STATE = "0101" else
               "011" when STATE = "0111" else
               "111"; -- this to display only 0s

end BEHAVIORAL;
