----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2025 11:11:40 PM
-- Design Name: 
-- Module Name: CASH_BUILDER - BEHAVIORAL
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CASH_BUILDER is
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
end CASH_BUILDER;

architecture BEHAVIORAL of CASH_BUILDER is
signal LEN1, LEN2, LEN5, LEN10, LEN20, LEN50: std_logic;

component FREQUENCY_DIVIDER is
    Port (CLK_FAST: in std_logic;
          CLK_SLOW: out std_logic);
end component;  
signal CLK_OUT: std_logic;

type cash_array is array (0 to 5) of std_logic_vector  (3 downto 0);
signal CASH: cash_array;

component INPUT_BILL_COUNTER is
    Port ( CLK : in STD_LOGIC;
           ENX : in STD_LOGIC;
           RST: in STD_LOGIC;
           ERST: in std_logic;
           X_BILL_COUNT : out std_logic_vector(3 downto 0));
end component;

signal TOTAL: integer := 0;
type integer_vector is array (0 to 5) of integer;
constant BILL_VALUES : integer_vector := (1, 2, 5, 10, 20, 50);

signal HUN, TEN, UNIT: integer;
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
begin
    FD: FREQUENCY_DIVIDER port map (CLK_FAST => CLK, CLK_SLOW => CLK_OUT);
    --the divided frequency is in CLK_OUT

    LEN1 <= '0' when MEN = '1' else
            EN1; 
    LEN2 <= '0' when MEN = '1' else
            EN2; 
    LEN5 <= '0' when MEN = '1' else
            EN5; 
    LEN10 <= '0' when MEN = '1' else
            EN10; 
    LEN20 <= '0' when MEN = '1' else
            EN20; 
    LEN50 <= '0' when MEN = '1' else
            EN50; 

    NC <= not MEN;
    
    C1: INPUT_BILL_COUNTER port map (CLK => CLK_OUT, ENX => LEN1, RST => RST, ERST => ERST, X_BILL_COUNT => CASH(0));
    C2: INPUT_BILL_COUNTER port map (CLK => CLK_OUT, ENX => LEN2, RST => RST, ERST => ERST, X_BILL_COUNT => CASH(1));
    C5: INPUT_BILL_COUNTER port map (CLK => CLK_OUT, ENX => LEN5, RST => RST, ERST => ERST, X_BILL_COUNT => CASH(2));
    C10: INPUT_BILL_COUNTER port map (CLK => CLK_OUT, ENX => LEN10, RST => RST, ERST => ERST, X_BILL_COUNT => CASH(3));
    C20: INPUT_BILL_COUNTER port map (CLK => CLK_OUT, ENX => LEN20, RST => RST, ERST => ERST, X_BILL_COUNT => CASH(4));
    C50: INPUT_BILL_COUNTER port map (CLK => CLK_OUT, ENX => LEN50, RST => RST, ERST => ERST, X_BILL_COUNT => CASH(5)); 
    
    -- concatenate all sub-counters into a single output vector
    CASH_VECTOR <= CASH(5) & CASH(4) & CASH(3) & CASH(2) & CASH(1) & CASH(0);
   
    process(CASH)
    begin
        TOTAL <= conv_integer(CASH(0)) * BILL_VALUES(0) + 
                 conv_integer(CASH(1)) * BILL_VALUES(1) + 
                 conv_integer(CASH(2)) * BILL_VALUES(2) + 
                 conv_integer(CASH(3)) * BILL_VALUES(3) + 
                 conv_integer(CASH(4)) * BILL_VALUES(4) + 
                 conv_integer(CASH(5)) * BILL_VALUES(5);
                 
        -- break the number in parts
        HUN <= TOTAL/100;
        TEN <= TOTAL/10 mod 10;
        UNIT <= TOTAL mod 10;
    end process;
    TOTAL_CASH <= TOTAL;
    
    -- convert the digits of the number in their SSD equivalent
    ITCC1: INT_TO_CAT_CONVERTER port map (INT => HUN, CAT => HC);
    ITCC2: INT_TO_CAT_CONVERTER port map (INT => TEN, CAT => TC);
    ITCC3: INT_TO_CAT_CONVERTER port map (INT => UNIT, CAT => UC);
    
    -- display the number
     TDSSD: THREE_DIGIT_SSD port map (CLK => CLK, DIGI1 => UC, DIGI2 => TC, DIGI3 => HC, AN => LAN, SEG => LSEG);
end BEHAVIORAL;
