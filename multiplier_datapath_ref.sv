module multiplier_datapath_ref (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] multiplicand_in,
    input  logic [31:0] multiplier_in,
    input  logic        load,        
    input  logic        product_wr,  
    input  logic        shift_en,    
    output logic        multiplier_lsb, 
    output logic [63:0] product
);

    logic [31:0] multiplicand_reg;
    // Registrador de 65 bits: bit 64 (carry), bits 63:32 (produto parcial), bits 31:0 (multiplicador/produto final)
    logic [64:0] product_reg; 
    
    // ALU de 32 bits com 1 bit extra para o carry-out
    logic [32:0] alu_sum; 

    // A ALU soma a metade superior do produto (bits 63:32) com o multiplicando
    assign alu_sum = {1'b0, product_reg[63:32]} + {1'b0, multiplicand_reg};

    // O bit de teste da FSM passa a ser o LSB do registrador de produto
    assign multiplier_lsb = product_reg[0];
    assign product        = product_reg[63:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand_reg <= '0;
            product_reg      <= '0;
        end else if (load) begin
            multiplicand_reg <= multiplicand_in;
            // Carrega o multiplicador na parte menos significativa (bits 31:0)
            product_reg      <= {33'b0, multiplier_in};
        end else begin
            if (product_wr)
                // Escreve o resultado da ALU (incluindo carry) nos bits mais significativos[cite: 6]
                product_reg[64:32] <= alu_sum;

            if (shift_en)
                // Shift right de todo o conjunto (Carry + Produto Parcial + Multiplicador)[cite: 6]
                product_reg <= {1'b0, product_reg[64:1]}; 
        end
    end
endmodule