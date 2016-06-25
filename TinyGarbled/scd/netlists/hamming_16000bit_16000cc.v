
module hamming_N16000_CC16000 ( clk, rst, g_input, e_input, o );
  input [0:0] g_input;
  input [0:0] e_input;
  output [13:0] o;
  input clk, rst;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29;
  wire   [13:0] oglobal;

  DFF \oglobal_reg[0]  ( .D(o[0]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[0]) );
  DFF \oglobal_reg[1]  ( .D(o[1]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[1]) );
  DFF \oglobal_reg[2]  ( .D(o[2]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[2]) );
  DFF \oglobal_reg[3]  ( .D(o[3]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[3]) );
  DFF \oglobal_reg[4]  ( .D(o[4]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[4]) );
  DFF \oglobal_reg[5]  ( .D(o[5]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[5]) );
  DFF \oglobal_reg[6]  ( .D(o[6]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[6]) );
  DFF \oglobal_reg[7]  ( .D(o[7]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[7]) );
  DFF \oglobal_reg[8]  ( .D(o[8]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[8]) );
  DFF \oglobal_reg[9]  ( .D(o[9]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[9]) );
  DFF \oglobal_reg[10]  ( .D(o[10]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[10]) );
  DFF \oglobal_reg[11]  ( .D(o[11]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[11]) );
  DFF \oglobal_reg[12]  ( .D(o[12]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[12]) );
  DFF \oglobal_reg[13]  ( .D(o[13]), .CLK(clk), .RST(rst), .I(1'b0), .Q(
        oglobal[13]) );
  XOR U18 ( .A(n15), .B(n16), .Z(o[13]) );
  XOR U19 ( .A(oglobal[13]), .B(n17), .Z(n16) );
  AND U20 ( .A(n15), .B(o[12]), .Z(n17) );
  XOR U21 ( .A(n15), .B(oglobal[12]), .Z(o[12]) );
  ANDN U22 ( .A(n18), .B(o[11]), .Z(n15) );
  XOR U23 ( .A(n18), .B(oglobal[11]), .Z(o[11]) );
  ANDN U24 ( .A(n19), .B(o[10]), .Z(n18) );
  XOR U25 ( .A(n19), .B(oglobal[10]), .Z(o[10]) );
  ANDN U26 ( .A(n20), .B(o[9]), .Z(n19) );
  XOR U27 ( .A(n20), .B(oglobal[9]), .Z(o[9]) );
  ANDN U28 ( .A(n21), .B(o[8]), .Z(n20) );
  XOR U29 ( .A(n21), .B(oglobal[8]), .Z(o[8]) );
  ANDN U30 ( .A(n22), .B(o[7]), .Z(n21) );
  XOR U31 ( .A(n22), .B(oglobal[7]), .Z(o[7]) );
  ANDN U32 ( .A(n23), .B(o[6]), .Z(n22) );
  XOR U33 ( .A(n23), .B(oglobal[6]), .Z(o[6]) );
  ANDN U34 ( .A(n24), .B(o[5]), .Z(n23) );
  XOR U35 ( .A(n24), .B(oglobal[5]), .Z(o[5]) );
  ANDN U36 ( .A(n25), .B(o[4]), .Z(n24) );
  XOR U37 ( .A(n25), .B(oglobal[4]), .Z(o[4]) );
  ANDN U38 ( .A(n26), .B(o[3]), .Z(n25) );
  XOR U39 ( .A(n26), .B(oglobal[3]), .Z(o[3]) );
  ANDN U40 ( .A(n27), .B(o[2]), .Z(n26) );
  XOR U41 ( .A(n27), .B(oglobal[2]), .Z(o[2]) );
  ANDN U42 ( .A(n28), .B(o[1]), .Z(n27) );
  XOR U43 ( .A(n28), .B(oglobal[1]), .Z(o[1]) );
  ANDN U44 ( .A(oglobal[0]), .B(n29), .Z(n28) );
  XNOR U45 ( .A(oglobal[0]), .B(n29), .Z(o[0]) );
  XNOR U46 ( .A(g_input[0]), .B(e_input[0]), .Z(n29) );
endmodule

