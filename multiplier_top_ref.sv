module multiplier_top_ref (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,           
    input  logic [31:0] multiplicand_in, 
    input  logic [31:0] multiplier_in,   
    output logic [63:0] product,         
    output logic        done             
);
    logic load, product_wr, shift_en, multiplier_lsb;

    multiplier_datapath_ref datapath (
        .clk             (clk),
        .rst_n           (rst_n),
        .multiplicand_in (multiplicand_in),
        .multiplier_in   (multiplier_in),
        .load            (load),
        .product_wr      (product_wr),
        .shift_en        (shift_en),
        .multiplier_lsb  (multiplier_lsb),
        .product         (product)
    );

    multiplier_control_ref control (
        .clk             (clk),
        .rst_n           (rst_n),
        .start           (start),
        .done            (done),
        .multiplier_lsb  (multiplier_lsb),
        .load            (load),
        .product_wr      (product_wr),
        .shift_en        (shift_en)
    );
endmodule