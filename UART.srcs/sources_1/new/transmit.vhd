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

entity transmit is
    Generic (
        baud     : integer := 9600;
        clk_freq : integer := 100000000);
    Port ( clk   : in  STD_LOGIC;
           data  : in  STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           send  : in  STD_LOGIC;
           RsTx  : out STD_LOGIC);
end transmit;

architecture Behavioral of transmit is

    constant max_clk_count  : integer    := clk_freq / baud;
    signal   s_count        : integer    := 0;
    signal   s_bitPlace     : integer    := 0;
    type     state_type is(idle, start_bit, data_bit, stop_bit, stop_bit_double);
    signal   s_state        : state_type := idle;
    signal   s_ready        : STD_LOGIC  := '1';     

begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            if (send = '1' and s_state = idle) then
                s_count      <= 0;
                s_state      <= start_bit;
                s_bitPlace   <= 0;
                s_ready      <= '0';
            end if;
            if (s_state /= idle) then
                s_count <= s_count + 1;
                if (s_state = start_bit) then
                    RsTx <= '0'; -- Hold line LO for start bit
                end if;
                if (s_state = stop_bit or s_state = stop_bit_double) then
                    RsTx <= '1'; -- Hold line HI for stop bit
                end if;
                if (s_state = data_bit) then
                    RsTx <= data(s_bitPlace);
                end if;
                if (s_count = max_clk_count) then
                    case s_state is
                        when start_bit => s_state <= data_bit;
                        when data_bit  =>
                            if (s_bitPlace = 7) then
                                s_state    <= stop_bit;
                            else
                                s_bitPlace <= s_bitPlace + 1;
                            end if;
                        when stop_bit =>
                            s_state <= stop_bit_double;
                        when stop_bit_double =>
                            s_state <= idle;
                            s_ready <= '1';
                        when others =>
                            s_state <= idle;
                            s_ready <= '1';
                    end case;
                    s_count <= 0;
                end if;
            elsif (s_state = idle) then
                RsTx <= '1'; -- Hold line Hi by default
            end if;
        end if;
        ready <= s_ready;
    end process;

end Behavioral;
