----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2025 08:59:47 PM
-- Design Name: 
-- Module Name: MONEY_UPDATE - BEHAVIORAL
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

entity MONEY_UPDATE is
    Port ( CLK : in STD_LOGIC;
           EQ : in STD_LOGIC;
           CASH_VECTOR : in STD_LOGIC_VECTOR (23 downto 0);
           REST_VECTOR : in STD_LOGIC_VECTOR (23 downto 0);
           EU1, EU2, EU5, EU10, EU20, EU50 : out STD_LOGIC;   
           ED1, ED2, ED5, ED10, ED20, ED50 : out STD_LOGIC;
           UPDATE_DONE: out std_logic
           );
end MONEY_UPDATE;

architecture BEHAVIORAL of MONEY_UPDATE is

signal cash_1, cash_2, cash_5, cash_10, cash_20, cash_50: std_logic_vector(3 downto 0);
signal rest_1, rest_2, rest_5, rest_10, rest_20, rest_50: std_logic_vector(3 downto 0);
signal UPD: std_logic := '0';
signal STATE, NEXT_STATE: std_logic_vector (3 downto 0);

begin

    process (CLK)
    begin
        if UPD = '0' then
            if rising_edge (CLK) then
                STATE <= NEXT_STATE;
            end if;
        end if;
    end process;
    
    process(STATE)
    begin
            
        case STATE is
            when "0000" => -- init
                EU1 <= '0'; EU2 <= '0'; EU5 <= '0'; EU10 <= '0'; EU20 <= '0'; EU50 <= '0';
                ED1 <= '0'; ED2 <= '0'; ED5 <= '0'; ED10 <= '0'; ED20 <= '0'; ED50 <= '0';
                UPDATE_DONE <= '0';
                
                cash_1 <= CASH_VECTOR(3 downto 0);
                cash_2 <= CASH_VECTOR(7 downto 4);
                cash_5 <= CASH_VECTOR(11 downto 8);
                cash_10 <= CASH_VECTOR(15 downto 12);
                cash_20 <= CASH_VECTOR(19 downto 16);
                cash_50 <= CASH_VECTOR(23 downto 20);
            
                rest_1 <= REST_VECTOR(3 downto 0);
                rest_2 <= REST_VECTOR(7 downto 4);
                rest_5 <= REST_VECTOR(11 downto 8);
                rest_10 <= REST_VECTOR(15 downto 12);
                rest_20 <= REST_VECTOR(19 downto 16);
                rest_50 <= REST_VECTOR(23 downto 20);
                
                NEXT_STATE <= "0001"; 
                -- begin subtracting from the cash and rest vector while modifying the internal bill values accordingly using the enables
            when "0001" =>
                if cash_1 > 0 then
                    EU1 <= '1';
                    cash_1 <= cash_1 - 1;
                end if;
                NEXT_STATE <= "0010";
            when "0010" =>
                if cash_2 > 0 then
                    EU2 <= '1';
                    cash_2 <= cash_2 - 1;
                end if;
                NEXT_STATE <= "0011";
            when "0011" =>
                if cash_5 > 0 then
                    EU5 <= '1';
                    cash_5 <= cash_5 - 1;
                end if;
                NEXT_STATE <= "0100";                
            when "0100" =>
                if cash_10 > 0 then
                    EU10 <= '1';
                    cash_10 <= cash_10 - 1;
                end if;
                NEXT_STATE <= "0101";
            when "0101" =>
                if cash_20 > 0 then
                    EU20 <= '1';
                    cash_20 <= cash_20 - 1;
                end if;
                NEXT_STATE <= "0110";
            when "0110" =>
                if cash_50 > 0 then
                    EU50 <= '1';
                    cash_50 <= cash_50 - 1;
                end if;
                if EQ = '1' then -- if there it is not required to give rest then jump directly to the end
                    NEXT_STATE <= "1101";
                else
                    NEXT_STATE <= "0111";
                end if;
            when "0111" =>
                if rest_1 > 0 then
                    ED1 <= '1';
                    rest_1 <= rest_1 - 1;
                end if;
                NEXT_STATE <= "1000";
            when "1000" =>
                if rest_2 > 0 then
                    ED2 <= '1';
                    rest_2 <= rest_2 - 1;
                end if;
                NEXT_STATE <= "1001";
            when "1001" =>
                if rest_5 > 0 then
                    ED5 <= '1';
                    rest_5 <= rest_5 - 1;
                end if;
                NEXT_STATE <= "1010";
            when "1010" =>
                if rest_10 > 0 then
                    ED10 <= '1';
                    rest_10 <= rest_10 - 1;
                end if;
                NEXT_STATE <= "1011";
            when "1011" =>
                if rest_20 > 0 then
                    ED20 <= '1';
                    rest_20 <= rest_20 - 1;
                end if;
                NEXT_STATE <= "1100";
            when "1100" =>
                if rest_1 > 0 then
                    ED20 <= '1';
                    rest_20 <= rest_20 - 1;
                end if;
                NEXT_STATE <= "1101";
            when "1101" =>
                if cash_1 = 0 and cash_2 = 0 and cash_5 = 0 and cash_10 = 0 and cash_20 = 0 and cash_50 = 0 and
                    rest_1 = 0 and rest_2 = 0 and rest_5 = 0 and rest_10 = 0 and rest_20 = 0 and rest_50 = 0  then
                    UPD <= '1';
                end if;
            when others =>
                null;
        end case;
        UPDATE_DONE <= UPD;
    end process;
    
end BEHAVIORAL;
