----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2025 11:42:53 PM
-- Design Name: 
-- Module Name: INT_TO_CAT_CONVERTER - BEHAVIORAL
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

entity INT_TO_CAT_CONVERTER is
    Port ( INT : in integer;
           CAT : out STD_LOGIC_VECTOR (6 downto 0));
end INT_TO_CAT_CONVERTER;

architecture BEHAVIORAL of INT_TO_CAT_CONVERTER is

begin
    CAT <= "1000000" when INT = 0 else
           "1111001" when INT = 1 else
           "0100100" when INT = 2 else
           "0110000" when INT = 3 else
           "0011001" when INT = 4 else
           "0010010" when INT = 5 else
           "0000010" when INT = 6 else
           "1111000" when INT = 7 else
           "0000000" when INT = 8 else
           "0010000" when INT = 9;
end BEHAVIORAL;
