----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2025 02:30:18 PM
-- Design Name: 
-- Module Name: FREQUENCY_DIVIDIER - BEHAVIORAL
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FREQUENCY_DIVIDER is
    Port (CLK_FAST: in std_logic;
          CLK_SLOW: out std_logic);
end FREQUENCY_DIVIDER;

architecture BEHAVIORAL of FREQUENCY_DIVIDER is
signal n: std_logic_vector(25 downto 0) := (others => '0');
begin
    process(CLK_FAST)
    begin
        if rising_edge (CLK_FAST) then
            n <= n + 1;
        end if;
        CLK_SLOW <= n(25);
    end process;
end BEHAVIORAL;
