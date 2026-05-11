----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2025 07:05:20 PM
-- Design Name: 
-- Module Name: NR_TO_CAT_CONVERTER - BEHAVIORAL
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NR_TO_CAT_CONVERTER is
    Port ( NR : in STD_LOGIC_VECTOR (3 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0));
end NR_TO_CAT_CONVERTER;

architecture BEHAVIORAL of NR_TO_CAT_CONVERTER is

begin
    CAT <= "1000000" when NR = "0000" else
           "1111001" when NR = "0001" else
           "0100100" when NR = "0010" else
           "0110000" when NR = "0011" else
           "0011001" when NR = "0100" else
           "0010010" when NR = "0101" else
           "0000010" when NR = "0110" else
           "1111000" when NR = "0111" else
           "0000000" when NR = "1000" else
           "0010000" when NR = "1001";
end BEHAVIORAL;
