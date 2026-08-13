module mux_4x1 (
  output logic [31:0] s,
  input  logic [31:0] a, b, c, d,
  input  logic [1:0] sel
);
  logic [31:0] f0, f1, f2, f3;
  logic n_sel1, n_sel0;

  // inversores
  assign n_sel1 = ~sel[1];
  assign n_sel0 = ~sel[0];

  // AND cobre os 32 bits
  assign f0 = a & {32{n_sel1 & n_sel0}};
  assign f1 = b & {32{n_sel1 & sel[0]}};
  assign f2 = c & {32{sel[1] & n_sel0}};
  assign f3 = d & {32{sel[1] & sel[0]}};
  
  // OR final
  assign s = f0 | f1 | f2 | f3;

endmodule