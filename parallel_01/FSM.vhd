library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    Port (
        clk : in std_logic;
        start : in std_logic;
        a_gt_b : in std_logic;
        s11, s12 : out std_logic_vector(2 downto 0);
        s21, s22 : out std_logic_vector(2 downto 0);
        op1, op2 : out std_logic_vector(1 downto 0);
        reg1_en : out std_logic;
        reg2_en : out std_logic;
        load_result : out std_logic;
        ready : out std_logic
    );
end FSM;

architecture Behavioral of FSM is
    type state_type is (
        Idle, Clear,
        A1, A2, A3, A4, A5, A6,
        B1, B2, B3,
        Division
    );
    signal state, next_state : state_type := Idle;

    -- selects do mux, dizem oq entra em s11, s12, s21, s22...
    -- o chatgpt que recomendou usar constant; faz sentido?
    constant sel_a : std_logic_vector(2 downto 0) := "000";
    constant sel_b : std_logic_vector(2 downto 0) := "001";
    constant sel_c : std_logic_vector(2 downto 0) := "010";
    constant sel_reg1 : std_logic_vector(2 downto 0) := "011";
    constant sel_reg2 : std_logic_vector(2 downto 0) := "100";
    constant sel_zero : std_logic_vector(2 downto 0) := "101";
    constant sel_three : std_logic_vector(2 downto 0) := "110";
    constant sel_six : std_logic_vector(2 downto 0) := "111";

    -- opcodes da ula
    constant op_add : std_logic_vector(1 downto 0) := "00";
    constant op_sub : std_logic_vector(1 downto 0) := "01";
    constant op_mul : std_logic_vector(1 downto 0) := "10";
    constant op_byp : std_logic_vector(1 downto 0) := "11"; -- "bypass", tipo, não faz nada
    -- OBS.: chatgpt disse que é bom ter esse bypass... Cheguei a usar nos caminhos ali, mas queria
    -- saber se não faz mais sentido usar enables??? Sei lá, meio confuso ainda kkkk

begin

    -- atualiza estado
    process (clk)
    begin
        if rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- proximo estado
    process (state, start, a_gt_b)
    begin
        case state is
            when Idle =>
                if start = '1' then
                    next_state <= Clear;
                else
                    next_state <= Idle;
                end if;
                
            when Clear =>
                if a_gt_b = '1' then
                    next_state <= A1;
                else
                    next_state <= B1;
                end if;
                
            -- yes: a > b
            when A1 => next_state <= A2;
            when A2 => next_state <= A3;
            when A3 => next_state <= A4;
            when A4 => next_state <= A5;
            when A5 => next_state <= A6;
            when A6 => next_state <= Division;
                
            -- no: a <= b
            when B1 => next_state <= B2;
            when B2 => next_state <= B3;
            when B3 => next_state <= Division;
                
            when Division => next_state <= Idle;
            when others => next_state <= Idle;
        end case;
    end process;

    -- decodifica saidas
    process (state)
    begin
        -- defaults, não sei se precisa:
        s11 <= sel_zero;
        s12 <= sel_zero;
        s21 <= sel_zero;
        s22 <= sel_zero;
        op1 <= op_byp;
        op2 <= op_byp;
        reg1_en <= '0';
        reg2_en <= '0';
        load_result <= '0';
        ready <= '0';

        case state is
            when Idle =>
                ready <= '1';
                
            when Clear =>
                s11 <= sel_zero;
                s12 <= sel_zero;
                op1 <= op_byp;
                reg1_en <= '1';
                
                s21 <= sel_zero;
                s22 <= sel_zero;
                op2 <= op_byp;
                reg2_en <= '1';
                
            -- yes (a > b) path
            when A1 =>
                s11 <= sel_c; s12 <= sel_c; op1 <= op_mul; reg1_en <= '1';
                s21 <= sel_a; s22 <= sel_a; op2 <= op_mul; reg2_en <= '1';
                
            when A2 =>
                s11 <= sel_six; s12 <= sel_reg1; op1 <= op_mul; reg1_en <= '1';
                s21 <= sel_reg2; s22 <= sel_reg2; op2 <= op_mul; reg2_en <= '1';
                
            when A3 =>
                s21 <= sel_three; s22 <= sel_reg2; op2 <= op_mul; reg2_en <= '1';
                
            when A4 =>
                s11 <= sel_reg1; s12 <= sel_reg2; op1 <= op_add; reg1_en <= '1';
                s21 <= sel_a; s22 <= sel_zero; op2 <= op_byp; reg2_en <= '1';
                
            when A5 =>
                s21 <= sel_a; s22 <= sel_b; op2 <= op_mul; reg2_en <= '1';
                
            when A6 =>
                s11 <= sel_reg1; s12 <= sel_reg2; op1 <= op_sub; reg1_en <= '1';
                s21 <= sel_a; s22 <= sel_zero; op2 <= op_byp; reg2_en <= '1';
                
            -- no path (fica bem menor)
            when B1 =>
                s11 <= sel_b; s12 <= sel_b; op1 <= op_mul; reg1_en <= '1';
                s21 <= sel_a; s22 <= sel_a; op2 <= op_mul; reg2_en <= '1';
                
            when B2 =>
                s11 <= sel_reg1; s12 <= sel_b; op1 <= op_mul; reg1_en <= '1';
                
            when B3 =>
                s11 <= sel_reg1; s12 <= sel_reg2; op1 <= op_add; reg1_en <= '1';
                s21 <= sel_c; s22 <= sel_b; op2 <= op_add; reg2_en <= '1';
                
            when Division =>
                load_result <= '1';
                
            when others =>
                null;
        end case;
    end process;

end Behavioral;
