    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 05/11/2025 10:57:35 PM
    -- Design Name: 
    -- Module Name: COST_COMPUTATION - BEHAVIORAL
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
    
    entity COST_COMPUTATION is
        Port ( CLK: in std_logic;
               DIST : in integer;
               
               COST: out integer;
               
               LAN: out std_logic_vector(3 downto 0);
               LSEG: out std_logic_vector (6 downto 0)
             );
    end COST_COMPUTATION;
    
    architecture BEHAVIORAL of COST_COMPUTATION is
    signal UNI, TEN, HUN: integer := 0;
    
    component INT_TO_CAT_CONVERTER is
        Port ( INT : in integer;
               CAT : out STD_LOGIC_VECTOR (6 downto 0));
    end component ;
    signal UD, TD, HD: std_logic_vector (6 downto 0);
    
    component THREE_DIGIT_SSD is
        Port ( CLK : in STD_LOGIC;
        
               DIGI1: in std_logic_vector (6 downto 0);
               DIGI2: in std_logic_vector (6 downto 0);
               DIGI3: in std_logic_vector (6 downto 0);
               
               AN: out std_logic_vector (3 downto 0);
               SEG: out std_logic_vector (6 downto 0)
               );
    end component;
    
    begin
        process(CLK, DIST)
        variable temp_cost: integer;
        begin
            if rising_edge (CLK) then
                temp_cost := (DIST * 4) / 10;
                COST <= temp_cost;     
                
                -- break the number in parts
                HUN <= temp_cost/100;
                TEN <= temp_cost/10 mod 10;
                UNI <= temp_cost mod 10;
            end if;
        end process;
        
        -- convert the digits of the number in their SSD equivalent
        ITCC1: INT_TO_CAT_CONVERTER port map(INT => UNI, CAT => UD);  
        ITCC2: INT_TO_CAT_CONVERTER port map(INT => TEN, CAT => TD);  
        ITCC3: INT_TO_CAT_CONVERTER port map(INT => HUN, CAT => HD);  
    
        -- display the number
         TDSSD: THREE_DIGIT_SSD port map (CLK => CLK, DIGI1 => UD, DIGI2 => TD, DIGI3 => HD, AN => LAN, SEG => LSEG);
        
    end BEHAVIORAL;
