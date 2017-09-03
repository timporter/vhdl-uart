----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.08.2017 22:41:46
-- Design Name: 
-- Module Name: UART - Behavioral
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

entity UART is
    Port(
        clk              : in  STD_LOGIC;
        RsRx             : in  STD_LOGIC; -- External UART serial line
        RsTx             : out STD_LOGIC; -- External UART serial line
        read_ready       : out STD_LOGIC;
        read_dout        : out STD_LOGIC_VECTOR(7 downto 0);
        read_ack         : in  STD_LOGIC;
        send_din         : in  STD_LOGIC_VECTOR(7 downto 0);
        send_ready       : in  STD_LOGIC;
        send_delay       : in  STD_LOGIC
    );
        
end UART;

architecture Behavioral of UART is

  component uart_fifo is
  port (
    clk                : in  STD_LOGIC;
    rst                : in  STD_LOGIC;
    FIFO_READ_empty    : out STD_LOGIC;
    FIFO_READ_rd_data  : out STD_LOGIC_VECTOR(7 downto 0);
    FIFO_READ_rd_en    : in  STD_LOGIC;
    FIFO_WRITE_full    : out STD_LOGIC;
    FIFO_WRITE_wr_data : in  STD_LOGIC_VECTOR(7 downto 0);
    FIFO_WRITE_wr_en   : in  STD_LOGIC
  );
  end component uart_fifo;
  
  COMPONENT transmit
  Port ( clk   : in  STD_LOGIC;
         data  : in  STD_LOGIC_VECTOR (7 downto 0);
         ready : out STD_LOGIC;
         send  : in  STD_LOGIC;
         RsTx  : out STD_LOGIC);
  END COMPONENT;
  
  COMPONENT receive
  Port ( RsRx    : in STD_LOGIC;
         clk     : in STD_LOGIC;
         updated : out STD_LOGIC;
         reset   : in  STD_LOGIC;
         dout    : out STD_LOGIC_VECTOR (7 downto 0));
  END COMPONENT;
  
  signal s_transmit_dequeue_data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  signal s_receive_enqueue_data  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

  type t_rx_state is (idle, reset_reset);
  signal s_rx_state              : t_rx_state                   := idle;
  type t_read_state is (idle, await_ack);
  signal s_read_state            : t_read_state                 := idle;
  signal s_rx_updated            : STD_LOGIC                    := '0';  
  signal s_rx_reset              : STD_LOGIC                    := '0';
  signal s_in_fifo_wr_en         : STD_LOGIC                    := '0';
  signal s_in_fifo_rd_en         : STD_LOGIC                    := '0';
  signal s_in_fifo_empty         : STD_LOGIC                    := '1';
  
  signal s_read_ready            : STD_LOGIC                    := '0';
  
  type t_tx_state is (idle, await_complete);
  signal s_tx_state              : t_tx_state                   := idle;
  type t_send_state is (idle, await_complete);
  signal s_send_state            : t_send_state                 := idle;
  signal s_tx_send               : STD_LOGIC                    := '0';
  signal s_tx_ready              : STD_LOGIC                    := '1';
  signal s_out_fifo_wr_en        : STD_LOGIC                    := '0';
  signal s_out_fifo_rd_en        : STD_LOGIC                    := '0';
  signal s_out_fifo_empty        : STD_LOGIC                    := '1';
  
begin

    TX: transmit PORT MAP(
        clk      => clk,
        data     => s_transmit_dequeue_data,
        ready    => s_tx_ready,
        send     => s_tx_send,
        RsTx     => RsTx 
    );
    
    RX: receive PORT MAP(
        RsRx     => RsRx,
        clk      => clk,
        updated  => s_rx_updated,
        reset    => s_rx_reset,
        dout     => s_receive_enqueue_data
    );

    fifo_rx_queue: uart_fifo
     port map (
      FIFO_READ_empty    => s_in_fifo_empty,
      FIFO_READ_rd_data  => read_dout,
      FIFO_READ_rd_en    => s_in_fifo_rd_en,
      -- FIFO_WRITE_full    => FIFO_WRITE_full,
      FIFO_WRITE_wr_data => s_receive_enqueue_data,
      FIFO_WRITE_wr_en   => s_in_fifo_wr_en,
      clk                => clk,
      rst                => '0'
    );

    fifo_tx_queue: uart_fifo
     port map (
      FIFO_READ_empty    => s_out_fifo_empty,
      FIFO_READ_rd_data  => s_transmit_dequeue_data,
      FIFO_READ_rd_en    => s_out_fifo_rd_en,
      -- FIFO_WRITE_full    => FIFO_WRITE_full,
      FIFO_WRITE_wr_data => send_din,
      FIFO_WRITE_wr_en   => s_out_fifo_wr_en,
      clk                => clk,
      rst                => '0'
    );

    process(clk)
    begin
        if (rising_edge(clk)) then
        
            -- deal with new data coming from the UART and needing to be added to the RX queue
            -- The dataline itself is set directly in the port map, we don't need to do anything with the data         
            if (s_rx_state = idle and s_rx_updated = '1') then
                s_in_fifo_wr_en <= '1';
                s_rx_reset      <= '1';
                s_rx_state      <= reset_reset;
            elsif (s_rx_state = reset_reset) then
                s_in_fifo_wr_en <= '0';
                s_rx_reset      <= '0';
                s_rx_state      <= idle;
            end if;
            
            if (s_in_fifo_empty = '0' and s_read_state = idle and read_ack = '0') then
                -- There is data on the queue, we aren't in the middle of something else, the external circuit is not in ACK mode
                -- first of all we need to be signalling that there is data in the first place
                s_read_ready      <= '1';
                s_read_state      <= await_ack;
                s_in_fifo_rd_en   <= '1';
            elsif (s_read_state = await_ack) then
                -- we need to tell the fifo to stop sending us data
                s_in_fifo_rd_en   <= '0';
                s_read_ready      <= '0';
                if (read_ack = '1') then
                    -- We're outputting some data, and the external circuit just ACKed it.
                    s_read_state <= idle;
                end if;
            end if;
            read_ready <= s_read_ready;
            
            -- deal with data being in the TX queue and needing to be send to the transmitter.
            if (s_out_fifo_empty = '0' and s_tx_state = idle and s_tx_ready = '1' and send_delay = '0') then
                -- There is data on the queue, we aren't in the middle of doing something else, the transmitter is ready
                -- The data itself is already hard wired from the fifo to the transmitter logic
                s_tx_send        <= '1';
                s_out_fifo_rd_en <= '1';
                s_tx_state       <= await_complete;
            elsif (s_tx_state = await_complete) then
                -- don't want to keep pulling from the fifo
                s_tx_send        <= '0';
                s_out_fifo_rd_en <= '0';
                -- once the send finished, we can move on
                if (s_tx_ready = '1') then
                    s_tx_state <= idle;
                end if;
            end if;
            
            -- deal with the external circuit wanting to add something to the TX queue
            -- data is already wired in            
            if (send_ready = '1' and s_send_state = idle) then
                s_out_fifo_wr_en <= '1';
                s_send_state     <= await_complete;
            elsif (s_send_state = await_complete) then
                s_out_fifo_wr_en <= '0';
                s_send_state     <= idle;
            end if;
            
        end if;
        
    end process;    

end Behavioral;
