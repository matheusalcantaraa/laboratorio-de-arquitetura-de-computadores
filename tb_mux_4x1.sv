`timescale 1ns/1ps

module tb_mux_4x1;
   logic [2:0] cont;
   logic [31:0] saida;
   logic [31:0] e0, e1, e2, e3;

   // DUT
   mux_4x1 dut(
     .s(saida), 
     .a(e0), 
     .b(e1), 
     .c(e2), 
     .d(e3), 
     .sel(cont[1:0])
   );

   initial begin
     // Valores diferentes de 32 bits aplicados às entradas
     e0 = 32'hAAAAAAAA; 
     e1 = 32'h55555555; 
     e2 = 32'hDEADBEEF; 
     e3 = 32'hCAFEF00D;
     
     // ve se ta funcionando
     $monitor("Tempo: %0t ns | sel = %b | saida = %h", $time, cont[1:0], saida);
     
     // Loop testando todos os casos de seleção
     for(cont = 0; cont < 4; cont++) begin
       #10;
     end
     
     #10 $stop;
   end
endmodule