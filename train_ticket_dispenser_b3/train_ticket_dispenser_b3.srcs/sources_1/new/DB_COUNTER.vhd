----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/22/2025 08:28:40 PM
-- Design Name: 
-- Module Name: DB_COUNTER - BEHAVIORAL
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DB_COUNTER is
    Port ( CLK : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC);
end DB_COUNTER;

architecture BEHAVIORAL of DB_COUNTER is
signal counter: std_logic_vector(27 downto 0) := (others => '0');
begin

process(CLK)
begin
if rising_edge (CLK) then
    counter <= counter + x"0000001"; 
    if(counter>=x"003D08F") then -- reduce this number for simulation
        counter <=  (others => '0');
    end if;
 end if;
end process;

CLK_OUT <= '1' when counter = x"003D08F" else '0';
end BEHAVIORAL;
