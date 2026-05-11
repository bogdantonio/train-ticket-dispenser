----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2025 08:23:10 PM
-- Design Name: 
-- Module Name: INPUT_BILL_COUNTER - BEHAVIORAL
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

entity INPUT_BILL_COUNTER is
    Port ( CLK : in STD_LOGIC;
           ENX : in STD_LOGIC;
           RST: in STD_LOGIC;
           ERST: in std_logic;
           X_BILL_COUNT : out std_logic_vector(3 downto 0));
end INPUT_BILL_COUNTER;

architecture BEHAVIORAL of INPUT_BILL_COUNTER is
signal countx : std_logic_vector(3 downto 0) := "0000";
begin  
   
    process(CLK)
    begin
        if RST = '1' or ERST = '1' then
            countx <= "0000";
        else
            if rising_edge (CLK) then
                if ENX = '1' then    
                    if countx < "1111" then   -- each counter is capped at 15 banknotes of one type
                        countx <= countx + 1;
                    end if;
                end if;
            end if;
        end if;
     end process;
     X_BILL_COUNT <= countx;
         
end BEHAVIORAL;
