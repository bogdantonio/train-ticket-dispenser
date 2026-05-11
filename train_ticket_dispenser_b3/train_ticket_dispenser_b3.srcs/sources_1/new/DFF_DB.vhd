----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/22/2025 08:33:06 PM
-- Design Name: 
-- Module Name: DFF_DB - BEHAVIORAL
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

entity DFF_DB is
    Port ( CLK : in STD_LOGIC;
           CLK_EN : in STD_LOGIC;
           D : in STD_LOGIC;
           Q : out STD_LOGIC := '0');
end DFF_DB;

architecture BEHAVIORAL of DFF_DB is

begin

process(CLK)
begin
 if rising_edge(CLK) then
  if(CLK_EN='1') then
   Q <= D;
  end if;
 end if;
end process;

end BEHAVIORAL;
