----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2025 03:33:18 PM
-- Design Name: 
-- Module Name: TICKET_MANAGER - Behavioral
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

entity TICKET_MANAGER is
    Port ( CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           NT : out STD_LOGIC
           );
end TICKET_MANAGER;

architecture BEHAVIORAL of TICKET_MANAGER is

signal tickets: std_logic_vector(7 downto  0) := "00000011";
signal prev_en: std_logic := '0';
begin
       
    -- if enabled then the counter counts down (meaning a ticket has been issued)
    process(CLK)
    begin
        if rising_edge (CLK) then
            if EN = '1' and prev_en = '0' then
                if tickets > "00000000" then
                    tickets <= tickets - 1;
                end if; 
            end if;
            prev_en <= EN;
        end if;
    end process;
    
    -- if there are no tickets then signal it with the using the NT output
    NT <= '1' when tickets = "00000000" else '0';
    
end BEHAVIORAL;
