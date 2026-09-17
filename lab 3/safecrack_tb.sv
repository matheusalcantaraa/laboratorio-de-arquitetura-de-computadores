`timescale 1ns/1ps

module safecrack_tb;

    // Sinais do testbench
    logic       clk;
    logic       rst_n;
    logic [3:0] btn;       // [Vermelho, Verde, Amarelo, Azul]
    logic       unlocked;

    // Instanciação do DUT (Device Under Test) - O seu SafeCrack
    safecrack dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .btn     (btn),
        .unlocked(unlocked)
    );

    // Geração de clock: período de 20ns -> 50 MHz
    initial clk = 0;
    always #10 clk = ~clk;

    // Task para apertar um botão específico
    task press_button(input logic [3:0] btn_press);
        @(negedge clk);
        btn = btn_press;               // Aperta o botão
        repeat (2) @(posedge clk);     // Segura por 2 ciclos
        @(negedge clk);
        btn = 4'b0000;                 // Solta os botões
        repeat (3) @(posedge clk);     // Aguarda antes do próximo
    endtask

    // Início da simulação
    initial begin
        // Configuração para o GTKWave/ModelSim
        $dumpfile("safecrack.vcd");
        $dumpvars(0, safecrack_tb);

        // Condição Inicial
        btn = 4'b0000;
        
        $display("\n=== Aplicando Reset ===");
        rst_n = 1'b0;
        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        $display("\n=== Teste 1: Sequencia Incorreta (Azul -> Verde) ===");
        press_button(4'b0001); // Azul
        press_button(4'b0100); // Verde (Errou, deve resetar)
        
        if (unlocked == 1'b0) $display("[PASS] Cofre continuou trancado.");
        else $display("[FAIL] Cofre abriu indevidamente.");

        $display("\n=== Teste 2: Sequencia Correta (Azul -> Amarelo -> Amarelo -> Vermelho) ===");
        press_button(4'b0001); // Azul
        press_button(4'b0010); // Amarelo
        press_button(4'b0010); // Amarelo
        press_button(4'b1000); // Vermelho
        
        repeat (2) @(posedge clk);
        if (unlocked == 1'b1) $display("[PASS] Cofre abriu com sucesso!");
        else $display("[FAIL] Cofre nao abriu.");

        $display("\n=== Teste 3: Reset para trancar novamente ===");
        rst_n = 1'b0;
        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        
        if (unlocked == 1'b0) $display("[PASS] Cofre trancou apos reset.");
        else $display("[FAIL] Cofre continuou aberto.");

        $display("\n=== Simulacao Concluida ===");
        $finish;
    end

endmodule