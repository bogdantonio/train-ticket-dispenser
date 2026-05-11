----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2025 02:21:40 PM
-- Design Name: 
-- Module Name: INTERN_BILL_COUNTER - BEHAVIORAL
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

entity INTERN_BILL_COUNTER is
    Port ( CLK : in STD_LOGIC;
    
           EUX : in STD_LOGIC; -- enable for count up
           EDX : in STD_LOGIC; -- enable for count down
           
           NR_X_BILLS : out std_logic_vector(7 downto 0));
end INTERN_BILL_COUNTER;

architecture BEHAVIORAL of INTERN_BILL_COUNTER is
signal count_x: std_logic_vector  (7 downto 0) := "01010101";
signal prev_en_up: std_logic := '0';
signal prev_en_down: std_logic := '0';
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if EUX = '1' and prev_en_up = '0' then
                if count_x < "11111111" then
                    count_x <= count_x + 1;
                end if;
            end if;
            prev_en_up <= EUX;
            if EDX = '1' and prev_en_down = '0' then
                if count_x > "00000000" then
                    count_x <= count_x - 1;
                end if;
            end if;
            prev_en_down <= EDX;
        end if;

    end process;    
    NR_X_BILLS <= count_x;
end BEHAVIORAL;
