    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 03/22/2025 08:32:58 PM
    -- Design Name: 
    -- Module Name: BTN_DEBOUNCER - DEBOUNCER
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
    
    entity BTN_DEBOUNCER is
      Port ( BTN: in std_logic;
             CLK_100: in std_logic;
             BTN_DB: out std_logic);
    end BTN_DEBOUNCER;
    
    architecture DEBOUNCER of BTN_DEBOUNCER is

    signal slow_clk_enable: std_logic;
    signal Q1,Q2,Q2_bar,Q0: std_logic;
   
    component DB_COUNTER is
    Port ( CLK : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC);
    end component;
    
    component DFF_DB is
    Port ( CLK : in STD_LOGIC;
           CLK_EN : in STD_LOGIC;
           D : in STD_LOGIC;
           Q : out STD_LOGIC := '0');
    end component;
   
    begin
          DBC: DB_COUNTER port map (CLK => CLK_100, CLK_OUT => slow_clk_enable);
          DB0: DFF_DB port map (CLK => CLK_100, CLK_EN => slow_clk_enable, D => BTN, Q => Q0);
          DB1: DFF_DB port map (CLK => CLK_100, CLK_EN => slow_clk_enable, D => Q0, Q => Q1);
          DB2: DFF_DB port map (CLK => CLK_100, CLK_EN => slow_clk_enable, D => Q1, Q => Q2);
          
          Q2_bar <= not Q2;
          BTN_DB <= Q1 and Q2_bar;
    end DEBOUNCER;
