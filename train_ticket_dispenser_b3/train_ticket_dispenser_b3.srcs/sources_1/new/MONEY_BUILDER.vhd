----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2025 02:32:38 PM
-- Design Name: 
-- Module Name: MONEY_BUILDER - BEHAVIORAL
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MONEY_BUILDER is
    Port ( CLK : in STD_LOGIC;          
           -- count up enables
           EU1, EU2, EU5, EU10, EU20, EU50 : in STD_LOGIC;
           -- count down enables
           ED1, ED2, ED5, ED10, ED20, ED50 : in STD_LOGIC;
           
           MONEY_VECTOR: out std_logic_vector(47 downto 0)
           );
end MONEY_BUILDER;

architecture BEHAVIORAL of MONEY_BUILDER is

type money_array is array (0 to 5) of std_logic_vector(7 downto 0);
signal MONEY: money_array;

component INTERN_BILL_COUNTER is
    Port ( CLK : in STD_LOGIC;
    
           EUX : in STD_LOGIC; -- enable for count up
           EDX : in STD_LOGIC; -- enable for count down
           
           NR_X_BILLS : out std_logic_vector(7 downto 0));
end component;

begin
    C1: INTERN_BILL_COUNTER port map (CLK => CLK, EUX => EU1, EDX => ED1, NR_X_BILLS => MONEY(0));
    C2: INTERN_BILL_COUNTER port map (CLK => CLK, EUX => EU2, EDX => ED2, NR_X_BILLS => MONEY(1));
    C5: INTERN_BILL_COUNTER port map (CLK => CLK, EUX => EU5, EDX => ED5, NR_X_BILLS => MONEY(2));
    C10: INTERN_BILL_COUNTER port map (CLK => CLK, EUX => EU10, EDX => ED10, NR_X_BILLS => MONEY(3));
    C20: INTERN_BILL_COUNTER port map (CLK => CLK, EUX => EU20, EDX => ED20, NR_X_BILLS => MONEY(4));
    C50: INTERN_BILL_COUNTER port map (CLK => CLK, EUX => EU50, EDX => ED50, NR_X_BILLS => MONEY(5));

    -- concatenate all sub-counters into a single output vector
    MONEY_VECTOR <= MONEY(5) & MONEY(4) & MONEY(3) & MONEY(2) & MONEY(1) & MONEY(0);
end BEHAVIORAL;
