--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
--Date        : Fri Aug 11 22:51:16 2017
--Host        : timbox running 64-bit major release  (build 9200)
--Command     : generate_target uart_buffer_mem.bd
--Design      : uart_buffer_mem
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity uart_buffer_mem is
  port (
    BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    BRAM_PORTA_clk : in STD_LOGIC;
    BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    BRAM_PORTA_en : in STD_LOGIC;
    BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 0 to 0 );
    BRAM_PORTB_addr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    BRAM_PORTB_clk : in STD_LOGIC;
    BRAM_PORTB_dout : out STD_LOGIC_VECTOR ( 7 downto 0 );
    BRAM_PORTB_en : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of uart_buffer_mem : entity is "uart_buffer_mem,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=uart_buffer_mem,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of uart_buffer_mem : entity is "uart_buffer_mem.hwdef";
end uart_buffer_mem;

architecture STRUCTURE of uart_buffer_mem is
  component uart_buffer_mem_blk_mem_gen_0_0 is
  port (
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 11 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 7 downto 0 );
    clkb : in STD_LOGIC;
    enb : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR ( 11 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component uart_buffer_mem_blk_mem_gen_0_0;
  signal BRAM_PORTA_1_ADDR : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal BRAM_PORTA_1_CLK : STD_LOGIC;
  signal BRAM_PORTA_1_DIN : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal BRAM_PORTA_1_EN : STD_LOGIC;
  signal BRAM_PORTA_1_WE : STD_LOGIC_VECTOR ( 0 to 0 );
  signal BRAM_PORTB_1_ADDR : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal BRAM_PORTB_1_CLK : STD_LOGIC;
  signal BRAM_PORTB_1_DOUT : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal BRAM_PORTB_1_EN : STD_LOGIC;
begin
  BRAM_PORTA_1_ADDR(11 downto 0) <= BRAM_PORTA_addr(11 downto 0);
  BRAM_PORTA_1_CLK <= BRAM_PORTA_clk;
  BRAM_PORTA_1_DIN(7 downto 0) <= BRAM_PORTA_din(7 downto 0);
  BRAM_PORTA_1_EN <= BRAM_PORTA_en;
  BRAM_PORTA_1_WE(0) <= BRAM_PORTA_we(0);
  BRAM_PORTB_1_ADDR(11 downto 0) <= BRAM_PORTB_addr(11 downto 0);
  BRAM_PORTB_1_CLK <= BRAM_PORTB_clk;
  BRAM_PORTB_1_EN <= BRAM_PORTB_en;
  BRAM_PORTB_dout(7 downto 0) <= BRAM_PORTB_1_DOUT(7 downto 0);
blk_mem_gen_0: component uart_buffer_mem_blk_mem_gen_0_0
     port map (
      addra(11 downto 0) => BRAM_PORTA_1_ADDR(11 downto 0),
      addrb(11 downto 0) => BRAM_PORTB_1_ADDR(11 downto 0),
      clka => BRAM_PORTA_1_CLK,
      clkb => BRAM_PORTB_1_CLK,
      dina(7 downto 0) => BRAM_PORTA_1_DIN(7 downto 0),
      doutb(7 downto 0) => BRAM_PORTB_1_DOUT(7 downto 0),
      ena => BRAM_PORTA_1_EN,
      enb => BRAM_PORTB_1_EN,
      wea(0) => BRAM_PORTA_1_WE(0)
    );
end STRUCTURE;
