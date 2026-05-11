----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2025 07:05:20 PM
-- Design Name: 
-- Module Name: THREE_DIGIT_SSD - BEHAVIORAL
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

entity THREE_DIGIT_SSD is
    Port ( CLK : in STD_LOGIC;
    
           DIGI1: in std_logic_vector (6 downto 0);
           DIGI2: in std_logic_vector (6 downto 0);
           DIGI3: in std_logic_vector (6 downto 0);
           
           AN: out std_logic_vector (3 downto 0);
           SEG: out std_logic_vector (6 downto 0)
           );
end THREE_DIGIT_SSD;

architecture BEHAVIORAL of THREE_DIGIT_SSD is
signal N: std_logic_vector (27 downto 0) := (others => '0');
signal ANA: std_logic_vector (3 downto 0); --anode active
signal digit_sel: std_logic_vector (1 downto 0);
begin

process(CLK)
begin
    if rising_edge (CLK) then
        N <= N+1;
    end if;
end process;

digit_sel <= N(17)&N(16);

-- anode selection (only the first 3 are used)
ANA <= "1110" when digit_sel = "00" else
       "1101" when digit_sel = "01" else
       "1011" when digit_sel = "10" else
       "1111";
       
AN <= ANA;
     
-- segment selection    
SEG <= DIGI1 when digit_sel = "00" else
       DIGI2 when digit_sel = "01" else
       DIGI3 when digit_sel = "10" else
       "1111111";

end BEHAVIORAL;
