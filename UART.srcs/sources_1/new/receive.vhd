----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.08.2017 23:15:57
-- Design Name: 
-- Module Name: receive - Behavioral
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

entity receive is
    Generic (
        baud     : integer := 9600;
        clk_freq : integer := 100000000);
    Port ( RsRx    : in STD_LOGIC;
           clk     : in STD_LOGIC;
           updated : out STD_LOGIC;
           reset   : in  STD_LOGIC;
           dout    : out STD_LOGIC_VECTOR (7 downto 0)
    );
end receive;

architecture Behavioral of receive is

    constant max_clk_count  : integer    := clk_freq / baud;
    signal   s_count        : integer    := 0;
    signal   s_dout         : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal   s_updated      : STD_LOGIC  := '0';
    type     state_type is (idle, offset_wait, start_bit, data_bit, stop_bit);
    signal   s_state        : state_type := idle;

begin

    process (clk)
        variable v_bitPlace     : integer    := 0;
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                s_updated <= '0';
            end if;
            s_count <= s_count + 1; 
            case s_state is
                when idle =>
                    if (RsRx = '0') then    
                        s_count <= 0;
                        s_state <= offset_wait;
                    end if;
                    
                when offset_wait =>
                    if (s_count = (max_clk_count / 3)) then
                        s_count <= 0;
                        s_state <= start_bit;
                    end if;
                    
                when start_bit =>
                    if (s_count = max_clk_count) then
                        s_count    <= 0;
                        s_state    <= data_bit;
                        v_bitPlace := 0;
                    end if;
                    
                when data_bit =>
                    if (s_count = 0) then
                        s_dout(v_bitplace) <= RsRx;
                    end if;
                    if (s_count = max_clk_count) then
                        s_count <= 0;
                        v_bitPlace := v_bitPlace + 1;
                        if (v_bitPlace = 8) then
                            v_bitPlace := 0;
                            s_count    <= 0;
                            s_state    <= stop_bit;
                            s_updated  <= '1';
                        end if;
                    end if;
                    
                when stop_bit =>
                    s_state    <= idle;
                    s_count    <= 0;
                    v_bitPlace := 0;
                    
                when others =>
                    s_count    <= 0;
                    v_bitPlace := 0;
                    s_state    <= idle;
            end case;
        end if;
        dout    <= s_dout;
        updated <= s_updated;
    end process;

end Behavioral;
