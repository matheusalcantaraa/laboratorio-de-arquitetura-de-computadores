module safecrack (
    input  logic       clk,      // Clock do sistema
    input  logic       rst_n,    // Reset assíncrono (ativo baixo)
    input  logic [3:0] btn,      // Entrada dos botões [Vermelho, Verde, Amarelo, Azul]
    output logic       unlocked  // LED de cofre aberto
);

    // Definição dos estados em One-Hot (5 estados = 5 bits)
    typedef enum logic [4:0] {
        S_INIT     = 5'b00001,
        S_B        = 5'b00010,
        S_BY       = 5'b00100,
        S_BYY      = 5'b01000,
        S_UNLOCKED = 5'b10000
    } state_t;

    state_t state, next_state;

    // Sinais para detecção de borda
    logic [3:0] btn_prev;
    logic [3:0] btn_rise;
    logic       any_btn_pressed;

    // Registrador de histórico dos botões para edge detection
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            btn_prev <= 4'b0000;
        else        
            btn_prev <= btn;
    end

    // btn_rise só terá nível alto por 1 ciclo de clock na transição 0 -> 1
    assign btn_rise = btn & ~btn_prev;
    
    // Flag auxiliar para saber se ALGO foi pressionado neste ciclo
    assign any_btn_pressed = (btn_rise != 4'b0000);

    // Lógica sequencial: Atualização do estado atual
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            state <= S_INIT;
        else        
            state <= next_state;
    end

    // Lógica combinacional: Definição do próximo estado
    always_comb begin
        next_state = state; // Default: mantém o estado

        unique case (state)
            S_INIT: 
                if (any_btn_pressed) 
                    next_state = (btn_rise == 4'b0001) ? S_B : S_INIT;
            
            S_B:    
                if (any_btn_pressed) 
                    next_state = (btn_rise == 4'b0010) ? S_BY : S_INIT;
            
            S_BY:   
                if (any_btn_pressed) 
                    next_state = (btn_rise == 4'b0010) ? S_BYY : S_INIT;
            
            S_BYY:  
                if (any_btn_pressed) 
                    next_state = (btn_rise == 4'b1000) ? S_UNLOCKED : S_INIT;
            
            S_UNLOCKED: 
                next_state = S_UNLOCKED; // Cofre aberto, só sai com reset
                
            default: 
                next_state = S_INIT;
        endcase
    end

    // Lógica de saída (Moore): Ativa apenas no estado final
    assign unlocked = (state == S_UNLOCKED);

endmodule