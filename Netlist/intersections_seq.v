`timescale 1ns / 1ps

module intersections_seq #(parameter N = 8)(
	input									clk,
	input									rst,
	input						[3*N:0]		g_init,
	input						[3*N:0]		e_init,
	output					[14*N+33:0]		o    
    );
	
			wire	signed	[N-1:0]		xB_wire;
			wire	signed	[N-1:0]		yB_wire;
			wire	signed	[N-1:0]		xC_wire;
			wire	signed	[N-1:0]		yC_wire;
			wire	signed	[N:0]		rB_wire;
			wire	signed	[N:0]		rC_wire;
			
			reg		signed	[N-1:0]		xB;
			reg		signed	[N-1:0]		yB;
			reg		signed	[N-1:0]		xC;
			reg		signed	[N-1:0]		yC;
			reg		signed	[N:0]		rB;
			reg		signed	[N:0]		rC;
			
			wire	signed	[4*N+9:0]	x1D;
			wire	signed	[3*N+6:0]	y1D;
			wire	signed	[4*N+9:0]	x2D;
			wire	signed	[3*N+6:0]	y2D;			

			reg		signed	[4*N+9:0]	x1D_reg;
			reg		signed	[3*N+6:0]	y1D_reg;
			reg		signed	[4*N+9:0]	x2D_reg;
			reg		signed	[3*N+6:0]	y2D_reg;
			
	assign	xB_wire	=	g_init[3*N:2*N+1];
	assign	yB_wire	=	g_init[2*N:N+1];
	assign	rB_wire	=	g_init[N:0];			
	assign	xC_wire	=	e_init[3*N:2*N+1];
	assign	yC_wire	=	e_init[2*N:N+1];
	assign	rC_wire	=	e_init[N:0];
	
	assign	o[14*N+33:10*N+24]	=	x1D_reg;
	assign	o[10*N+23:7*N+17]	=	y1D_reg;
	assign	o[7*N+16:3*N+7]  	=	x2D_reg;
	assign	o[3*N+6:0]	   		=	y2D_reg;
	 
			wire	signed	[N:0]		p, q;
			wire	signed	[2*N+3:0]	t;
			wire	signed	[4*N+9:0]	s;
			wire	signed	[3*N+5:0]	u;
			
			wire	signed	[6*N+13:0]	w_sqr;
			wire	signed	[3*N+6:0]	w;
			
			wire	signed	[2*N-1:0]	xB_sqr, yB_sqr, xC_sqr, yC_sqr;
 			wire	signed	[2*N+1:0]	rB_sqr, rC_sqr;
			wire	signed	[2*N+1:0]	p_sqr, q_sqr;
			wire	signed	[4*N+7:0]	t_sqr;
			wire	signed	[6*N+11:0]	u_sqr;	
			
			wire	signed	[4*N+1:0]	pxB_sqr, pyB_sqr;
			wire	signed	[4*N+3:0] 	prB_sqr;
			wire	signed	[4*N+4:0] 	ptxB;
			wire	signed	[3*N+4:0]	qt;
			wire	signed	[3*N+1:0]	yB_p_sqr;
			wire	signed	[2*N:0]		pxB;
			wire	signed	[3*N+1:0]	pqxB;
			
			wire	signed	[2*N+2:0]	rB_min_rC_sqr;
			wire	signed	[2*N:0]		xC_min_xB_sqr;
			wire	signed	[2*N:0]		yC_min_yB_sqr;
			wire	signed	[2*N+1:0]	xC_min_xB_plus_yC_min_yB_sqr;
							
			wire	signed	[4*N+2:0]	pyB_sqr_plus_pxB_sqr;
			wire	signed	[4*N+5:0]	prB_sqr_plus_ptxB;
			wire	signed	[4*N+6:0]	pyB_sqr_plus_pxB_sqr_min_prB_sqr_plus_ptxB;
			wire	signed	[3*N+2:0]	yB_p_sqr_plus_pqxB;
			
			wire	signed	[3*N+5:0]	yB_p_sqr_plus_pqxB_min_qt_by_2;
			wire	signed	[3*N+6:0]	y1D_top, y2D_top;
			
			wire	signed	[2*N+2:0]	p_sqr_plus_q_sqr;
			wire	signed	[6*N+12:0]	s_times_p_sqr_plus_q_sqr;  
			wire	signed	[4*N+7:0]	y1Dq, y2Dq;
			wire	signed	[4*N+9:0]	x1D_top, x2D_top;
			
			reg		signed	[3*N+6:0]	w_reg;
			reg		signed	[6*N+13:0]	w_sqr_reg;	 
			reg		signed	[N:0]		p_reg, q_reg;
			reg		signed	[2*N+3:0]	t_reg;	
			reg		signed	[3*N+5:0]	yB_p_sqr_plus_pqxB_min_qt_by_2_reg;
			reg		signed	[2*N+2:0]	p_sqr_plus_q_sqr_reg;

	MULT_ #(.N(N), .M(N)) MUL1 (.A(xB), .B(xB), .O(xB_sqr)); //xB_sqr : 2N
	MULT_ #(.N(N), .M(N)) MUL2 (.A(yB), .B(yB), .O(yB_sqr)); //yB_sqr : 2N
	MULT_ #(.N(N), .M(N)) MUL3 (.A(xC), .B(xC), .O(xC_sqr)); //xC_sqr : 2N
	MULT_ #(.N(N), .M(N)) MUL4 (.A(yC), .B(yC), .O(yC_sqr)); // yC_sqr :2N
	MULT_ #(.N(N+1), .M(N+1)) MUL5 (.A(rB), .B(rB), .O(rB_sqr)); //rB_sqr : 2N+2
	MULT_ #(.N(N+1), .M(N+1)) MUL6 (.A(rC), .B(rC), .O(rC_sqr)); //rC_sqr : 2N+2
			
	SUB_ #(.N(N), .M(N)) SUB1 (.A(xC), .B(xB), .O(p)); //P : N+1
	SUB_ #(.N(N), .M(N)) SUB2 (.A(yB), .B(yC), .O(q));	//q: N+1
	MULT_ #(.N(N+1), .M(N+1)) MUL7 (.A(p), .B(p), .O(p_sqr)); //p_sqr : 2N+2
	MULT_ #(.N(N+1), .M(N+1)) MUL8 (.A(q), .B(q), .O(q_sqr)); //q_sqr : 2N+2
	MULT_ #(.N(2*N+2), .M(2*N)) MUL9 (.A(p_sqr), .B(yB_sqr), .O(pyB_sqr)); //pyB_sqr : 4N+2
	MULT_ #(.N(2*N+2), .M(2*N)) MUL10 (.A(p_sqr), .B(xB_sqr), .O(pxB_sqr)); //pxB_sqr : 4N+2
	MULT_ #(.N(2*N+2), .M(2*N+2)) MUL11 (.A(p_sqr), .B(rB_sqr), .O(prB_sqr)); // prB_sqr : 4N+4
	MULT_ #(.N(N), .M(2*N+2)) MUL12 (.A(yB), .B(p_sqr), .O(yB_p_sqr)); //yB_p_sqr : 3N+2
	MULT_ #(.N(N+1), .M(N)) MUL13 (.A(p), .B(xB), .O(pxB)); //pxB : 2N+1
	MULT_ #(.N(2*N+1), .M(N+1)) MUL14 (.A(pxB), .B(q), .O(pqxB)); //pqxB : 3N+2

	SUB_ #(.N(2*N+2), .M(2*N+2)) SUB3 (.A(rB_sqr), .B(rC_sqr), .O(rB_min_rC_sqr)); //rB_min_rC_sqr : 2N+3
	SUB_ #(.N(2*N), .M(2*N)) SUB4 (.A(xC_sqr), .B(xB_sqr), .O(xC_min_xB_sqr)); //xC_min_xB_sqr : 2N+1
	SUB_ #(.N(2*N), .M(2*N)) SUB5 (.A(yC_sqr), .B(yB_sqr), .O(yC_min_yB_sqr)); //yC_min_yB_sqr : 2N+1
	ADD_ #(.N(2*N+1), .M(2*N+1)) ADD1 (.A(xC_min_xB_sqr), .B(yC_min_yB_sqr), .O(xC_min_xB_plus_yC_min_yB_sqr)); // xC_min_xB_plus_yC_min_yB_sqr : 2N+2
	ADD_ #(.N(2*N+3), .M(2*N+2)) ADD2 (.A(rB_min_rC_sqr), .B(xC_min_xB_plus_yC_min_yB_sqr), .O(t)); //t : 2N+4
	MULT_ #(.N(2*N+4), .M(2*N+4)) MUL15 (.A(t), .B(t), .O(t_sqr)); //t_sqr : 4N+8
	MULT_ #(.N(2*N+1), .M(2*N+4)) MUL16 (.A(pxB), .B(t), .O(ptxB));	//ptxB : 4N+5
	MULT_ #(.N(N+1), .M(2*N+4)) MUL17 (.A(q), .B(t), .O(qt)); //qt : 3N+5

	ADD_ #(.N(4*N+2), .M(4*N+2)) ADD3 (.A(pyB_sqr), .B(pxB_sqr), .O(pyB_sqr_plus_pxB_sqr)); //pyB_sqr_plus_pxB_sqr : 4N+3
	ADD_ #(.N(4*N+5), .M(4*N+4)) ADD4 (.A(ptxB), .B(prB_sqr), .O(prB_sqr_plus_ptxB)); //prB_sqr_plus_ptxB : 4N+6 
	SUB_ #(.N(4*N+6), .M(4*N+6)) SUB6 (.A({3'b0,pyB_sqr_plus_pxB_sqr}), .B(prB_sqr_plus_ptxB), .O(pyB_sqr_plus_pxB_sqr_min_prB_sqr_plus_ptxB));
	ADD_ #(.N(4*N+9), .M(4*N+8)) ADD5 (.A({pyB_sqr_plus_pxB_sqr_min_prB_sqr_plus_ptxB, 2'b0}), .B(t_sqr), .O(s)); //s : 4N+10
	ADD_ #(.N(2*N+2), .M(2*N+2)) ADD6 (.A(p_sqr), .B(q_sqr), .O(p_sqr_plus_q_sqr)); //p_sqr_plus_q_sqr : 2N+3
	MULT_ #(.N(4*N+10), .M(2*N+3)) MUL18 (.A(s), .B(p_sqr_plus_q_sqr), .O(s_times_p_sqr_plus_q_sqr)); //s_times_p_sqr_plus_q_sqr : 6N+13

	ADD_ #(.N(3*N+2), .M(3*N+2)) ADD7 (.A(yB_p_sqr ), .B(pqxB), .O(yB_p_sqr_plus_pqxB)); //yB_p_sqr_plus_pqxB : 3N+3
	SUB_ #(.N(3*N+5), .M(3*N+4)) SUB7 (.A(qt), .B({yB_p_sqr_plus_pqxB, 1'b0}), .O(u));	//u : 3N+6
	MULT_ #(.N(3*N+6), .M(3*N+6)) MUL19 (.A(u), .B(u), .O(u_sqr)); //u_sqr : 6N+12
	
	SUB_ #(.N(3*N+5), .M(3*N+4)) SUB9 (.A({{2{yB_p_sqr_plus_pqxB[3*N+2]}}, yB_p_sqr_plus_pqxB}), .B(qt[3*N+4:1]), .O(yB_p_sqr_plus_pqxB_min_qt_by_2));	//yB_p_sqr_plus_pqxB_min_qt_by_2 : 3N+6
	SUB_ #(.N(6*N+13), .M(6*N+13)) SUB8 (.A({1'b0,u_sqr}), .B(s_times_p_sqr_plus_q_sqr), .O(w_sqr)); //w_sqr : 6N+14
		
			reg							start;
			wire						ready;	
	square_root_seq #(.N(6*N+14), .M(3*N+7)) square_root_seq(
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.A(w_sqr_reg),
		.O(w), 
		.ready(ready)
	); //w : 3N+7

	ADD_ #(.N(3*N+6), .M(3*N+6)) ADD8 (.A(yB_p_sqr_plus_pqxB_min_qt_by_2_reg), .B(w_reg[3*N+6:1]), .O(y1D_top)); //y1D_top : 3N+7
	SUB_ #(.N(3*N+6), .M(3*N+6)) SUB10 (.A(yB_p_sqr_plus_pqxB_min_qt_by_2_reg), .B(w_reg[3*N+6:1]), .O(y2D_top));	//y2D_top : 3N+7
	
	DIV_ #(.N(3*N+7), .M(2*N+3)) DIV1 (.A(y1D_top), .B(p_sqr_plus_q_sqr_reg), .O(y1D));
	DIV_ #(.N(3*N+7), .M(2*N+3)) DIV2 (.A(y2D_top), .B(p_sqr_plus_q_sqr_reg), .O(y2D));
	
	MULT_ #(.N(3*N+7), .M(N+1)) MUL20 (.A(y1D), .B(q_reg), .O(y1Dq)); //y1Dq : 4N+8
	MULT_ #(.N(3*N+7), .M(N+1)) MUL21 (.A(y2D), .B(q_reg), .O(y2Dq)); //y2Dq : 4N+8

	ADD_ #(.N(4*N+9), .M(2*N+4)) ADD9 (.A({y1Dq, 1'b0}), .B(t_reg), .O(x1D_top)); //x1D_top : 4N+10
	ADD_ #(.N(4*N+9), .M(2*N+4)) ADD10 (.A({y2Dq, 1'b0}), .B(t_reg), .O(x2D_top)); //x2D_top : 4N+10

	DIV_ #(.N(4*N+10), .M(N+2)) DIV3 (.A(x1D_top), .B({p_reg, 1'b0}), .O(x1D));
	DIV_ #(.N(4*N+10), .M(N+2)) DIV4 (.A(x2D_top), .B({p_reg, 1'b0}), .O(x2D));
	
	
	reg [1:0] state;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			start	<= 1'b0;
			state	<= 2'b00;
			xB		<=	xB_wire;
			yB		<=	yB_wire;
			xC		<=	xC_wire;
			yC		<=	yC_wire;
			rB		<=	rB_wire;
			rC		<=	rC_wire;
			x1D_reg	<=	0;
			y1D_reg	<=	0;
			x2D_reg	<=	0;
			y2D_reg	<=	0;	
			w_sqr_reg <= 0;
			w_reg	<= 0;
			p_reg	<=	0;
			q_reg	<=	0;
			t_reg	<=	0;	
			yB_p_sqr_plus_pqxB_min_qt_by_2_reg	<= 0;
			p_sqr_plus_q_sqr_reg	<= 0;
		end
		else begin
			case(state)
				2'b00:begin
					xB		<=	0;
					yB		<=	0;
					xC		<=	0;
					yC		<=	0;
					rB		<=	0;
					rC		<=	0;
					w_sqr_reg <= w_sqr;
					p_reg	<=	p;
					q_reg	<=	q;
					t_reg	<=	t;	
					yB_p_sqr_plus_pqxB_min_qt_by_2_reg <= yB_p_sqr_plus_pqxB_min_qt_by_2;
					p_sqr_plus_q_sqr_reg <= p_sqr_plus_q_sqr;
					start 	<= 1'b1;
					state 	<= 2'b01;
				end
				2'b01:begin
					start <= 1'b0;
					if (ready) begin	
						w_reg	<= w;
						state	<= 2'b10;
					end
				end
				2'b10:begin
					p_reg	<=	0;
					q_reg	<=	0;
					t_reg	<=	0;	
					yB_p_sqr_plus_pqxB_min_qt_by_2_reg <= 0;
					p_sqr_plus_q_sqr_reg <= 0;
					w_sqr_reg <= 0;
					w_reg <= 0;
					x1D_reg	<=	x1D;
					y1D_reg	<=	y1D;		
					x2D_reg	<=	x2D;
					y2D_reg	<=	y2D;					
				end
			endcase
		end
	end


endmodule
