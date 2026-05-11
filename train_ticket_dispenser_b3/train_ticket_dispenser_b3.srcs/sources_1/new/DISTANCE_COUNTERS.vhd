----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2025 12:51:37 PM
-- Design Name: 
-- Module Name: DISTANCE_COUNTERS - COUNTER_X2
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DISTANCE_COUNTERS is
    Port ( CLK : in STD_LOGIC;
    
           ENH : in STD_LOGIC;
           ENT : in STD_LOGIC;
           RST: in STD_LOGIC;
           ERST: in std_logic;
           
           WHOLE: out integer;
           LAN: out std_logic_vector(3 downto 0);
           LSEG: out std_logic_vector (6 downto 0)
         );
end DISTANCE_COUNTERS;

architecture COUNTER_X2 of DISTANCE_COUNTERS is
component FREQUENCY_DIVIDER is
    Port (CLK_FAST: in std_logic;
          CLK_SLOW: out std_logic);
end component;  
signal CLK_OUT: std_logic;

signal counth: std_logic_vector(3 downto  0) := "0000";
signal countt: std_logic_vector(3 downto  0) := "0000";

signal HOUT, TOUT, UOUT: std_logic_vector(3 downto 0);
component NR_TO_CAT_CONVERTER is
    Port ( NR : in STD_LOGIC_VECTOR (3 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0));
end component;
signal HUNDREDS, TENS, UNIT: std_logic_vector (6 downto 0);

component THREE_DIGIT_SSD is
    Port ( CLK : in STD_LOGIC;
    
           DIGI1: in std_logic_vector (6 downto 0);
           DIGI2: in std_logic_vector (6 downto 0);
           DIGI3: in std_logic_vector (6 downto 0);
           
           AN: out std_logic_vector (3 downto 0);
           SEG: out std_logic_vector (6 downto 0)
           );
end component;
begin
    FD: FREQUENCY_DIVIDER port map (CLK_FAST => CLK, CLK_SLOW => CLK_OUT);
    --the divided frequency is in CLK_OUT

    -- counter for the hundreds up to 9, then reset
    process(CLK_OUT)
    begin
        if RST = '1' or ERST = '1' then
            counth <= "0000";
        else
            if rising_edge (CLK_OUT) then
                if ENH = '1' then    
                   if counth = "1001" then
                        counth <= "0000";
                   else     
                        counth <= counth + 1;
                   end if;
                end if;
            end if;
        end if;
    end process;
    
    HOUT <= counth;
    
    -- counter for the tens up to 9, then reset
    process(CLK_OUT)
    begin
        if RST = '1' or ERST = '1' then
            countt <= "0000";
        else
            if rising_edge (CLK_OUT) then
                if ENT = '1' then    
                    if countt = "1001" then
                        countt <= "0000";
                    else     
                        countt <= countt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    TOUT <= countt;
    
    UOUT <= "0000"; -- units are always 0
    
    -- build the distance as a whole (used for cost computation)
    process(UOUT, TOUT, HOUT)
    variable WX: integer;     
    begin
        WX := conv_integer(HOUT)*100 + conv_integer(TOUT)*10 + conv_integer(UOUT);
        WHOLE <= WX;
    end process;

    -- convert each digit into its equivalent representation on the catodes
    NTCC1: NR_TO_CAT_CONVERTER port map (NR => HOUT, CAT => HUNDREDS);
    NTCC2: NR_TO_CAT_CONVERTER port map (NR => TOUT, CAT => TENS);
    NTCC3: NR_TO_CAT_CONVERTER port map (NR => UOUT, CAT => UNIT);
    
    -- now display each digit on the three digit ssd
    TDSSD: THREE_DIGIT_SSD port map (CLK => CLK, DIGI1 => UNIT, DIGI2 => TENS, DIGI3 => HUNDREDS, AN => LAN, SEG => LSEG);

end COUNTER_X2;
