----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2025 08:27:50 PM
-- Design Name: 
-- Module Name: INPUT_BILL_LOCK - BEHAVIORAL
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

entity INPUT_BILL_LOCK is
    Port ( CASH: in integer;
           COST: in integer;
           LOCK: out std_logic;
           EQUAL: out std_logic        
           );
end INPUT_BILL_LOCK;

architecture BEHAVIORAL of INPUT_BILL_LOCK is

begin
    LOCK <= '1' when CASH >= COST else '0';
    EQUAL <= '1' when CASH = COST else '0';   
end BEHAVIORAL;
