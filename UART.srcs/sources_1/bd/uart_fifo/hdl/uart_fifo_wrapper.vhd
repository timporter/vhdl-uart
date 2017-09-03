--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
--Date        : Sat Aug 12 12:34:13 2017
--Host        : timbox running 64-bit major release  (build 9200)
--Command     : generate_target uart_fifo_wrapper.bd
--Design      : uart_fifo_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity uart_fifo_wrapper is
  port (
    FIFO_READ_empty : out STD_LOGIC;
    FIFO_READ_rd_data : out STD_LOGIC_VECTOR ( 7 downto 0 );
    FIFO_READ_rd_en : in STD_LOGIC;
    FIFO_WRITE_full : out STD_LOGIC;
    FIFO_WRITE_wr_data : in STD_LOGIC_VECTOR ( 7 downto 0 );
    FIFO_WRITE_wr_en : in STD_LOGIC;
    clk : in STD_LOGIC;
    rst : in STD_LOGIC
  );
end uart_fifo_wrapper;

architecture STRUCTURE of uart_fifo_wrapper is
  component uart_fifo is
  port (
    FIFO_READ_empty : out STD_LOGIC;
    FIFO_READ_rd_data : out STD_LOGIC_VECTOR ( 7 downto 0 );
    FIFO_READ_rd_en : in STD_LOGIC;
    FIFO_WRITE_full : out STD_LOGIC;
    FIFO_WRITE_wr_data : in STD_LOGIC_VECTOR ( 7 downto 0 );
    FIFO_WRITE_wr_en : in STD_LOGIC;
    clk : in STD_LOGIC;
    rst : in STD_LOGIC
  );
  end component uart_fifo;
begin
uart_fifo_i: component uart_fifo
     port map (
      FIFO_READ_empty => FIFO_READ_empty,
      FIFO_READ_rd_data(7 downto 0) => FIFO_READ_rd_data(7 downto 0),
      FIFO_READ_rd_en => FIFO_READ_rd_en,
      FIFO_WRITE_full => FIFO_WRITE_full,
      FIFO_WRITE_wr_data(7 downto 0) => FIFO_WRITE_wr_data(7 downto 0),
      FIFO_WRITE_wr_en => FIFO_WRITE_wr_en,
      clk => clk,
      rst => rst
    );
end STRUCTURE;
