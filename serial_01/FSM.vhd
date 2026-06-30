library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    Port (
        clk : in std_logic;
        start : in std_logic;
        a_gt_b : in std_logic;
        in_sel1 : out std_logic_vector(2 downto 0);
        in_sel2 : out std_logic_vector(2 downto 0);
        op : out std_logic_vector(1 downto 0);
        out_sel : out std_logic;
        ready : out std_logic
    );
end FSM;

architecture Behavioral of FSM is
    type state_type is (
        Idle,
        A1, A2, A3, A4, A5, A6, A7, A8,
        B1, B2, B3, B4, B5, B6
    );
    signal state, next_state : state_type := Idle;

    -- Mux selection constants
    constant sel_a : std_logic_vector(2 downto 0) := "000";
    constant sel_b : std_logic_vector(2 downto 0) := "001";
    constant sel_c : std_logic_vector(2 downto 0) := "010";
    constant sel_reg1 : std_logic_vector(2 downto 0) := "011";
    constant sel_reg2 : std_logic_vector(2 downto 0) := "100";
    constant sel_zero : std_logic_vector(2 downto 0) := "101";
    constant sel_three : std_logic_vector(2 downto 0) := "110";
    constant sel_six : std_logic_vector(2 downto 0) := "111";

    -- ULA opcodes
    constant op_add : std_logic_vector(1 downto 0) := "00";
    constant op_sub : std_logic_vector(1 downto 0) := "01";
    constant op_mul : std_logic_vector(1 downto 0) := "10";
    constant op_div : std_logic_vector(1 downto 0) := "11";

    -- Output selection constants (reg destination)
    constant out_reg1 : std_logic := '0';
    constant out_reg2 : std_logic := '1';

begin

    -- Atualiza estado
    process (clk)
    begin
        if rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Próximo estado
    process (state, start, a_gt_b)
    begin
        case state is
            when Idle =>
                if start = '1' then
                    if a_gt_b = '1' then
                        next_state <= A1;
                    else
                        next_state <= B1;
                    end if;
                else
                    next_state <= Idle;
                end if;
                
            -- Ramo Yes: a > b
            when A1 => next_state <= A2;
            when A2 => next_state <= A3;
            when A3 => next_state <= A4;
            when A4 => next_state <= A5;
            when A5 => next_state <= A6;
            when A6 => next_state <= A7;
            when A7 => next_state <= A8;
            when A8 => next_state <= Idle;
                
            -- Ramo No: a <= b
            when B1 => next_state <= B2;
            when B2 => next_state <= B3;
            when B3 => next_state <= B4;
            when B4 => next_state <= B5;
            when B5 => next_state <= B6;
            when B6 => next_state <= Idle;
                
            when others => next_state <= Idle;
        end case;
    end process;

    -- Decodifica saídas
    process (state)
    begin
        -- Defaults: in_sel1/2 para zero, op para add,
        -- out_sel para reg2 (para não sobrescrever reg1/result em Idle)
        in_sel1 <= sel_zero;
        in_sel2 <= sel_zero;
        op <= op_add;
        out_sel <= out_reg2;
        ready <= '0';

        case state is
            when Idle =>
                ready <= '1';
                
            -- Ramo Yes (a > b)
            when A1 =>
                in_sel1 <= sel_c; in_sel2 <= sel_c; op <= op_mul; out_sel <= out_reg1; -- reg1 = c*c
                
            when A2 =>
                in_sel1 <= sel_six; in_sel2 <= sel_reg1; op <= op_mul; out_sel <= out_reg1; -- reg1 = 6*reg1
                
            when A3 =>
                in_sel1 <= sel_reg1; in_sel2 <= sel_a; op <= op_div; out_sel <= out_reg1; -- reg1 = reg1/a
                
            when A4 =>
                in_sel1 <= sel_a; in_sel2 <= sel_a; op <= op_mul; out_sel <= out_reg2; -- reg2 = a*a
                
            when A5 =>
                in_sel1 <= sel_reg2; in_sel2 <= sel_a; op <= op_mul; out_sel <= out_reg2; -- reg2 = reg2*a
                
            when A6 =>
                in_sel1 <= sel_three; in_sel2 <= sel_reg2; op <= op_mul; out_sel <= out_reg2; -- reg2 = 3*reg2
                
            when A7 =>
                in_sel1 <= sel_reg2; in_sel2 <= sel_b; op <= op_sub; out_sel <= out_reg2; -- reg2 = reg2-b
                
            when A8 =>
                in_sel1 <= sel_reg2; in_sel2 <= sel_reg1; op <= op_add; out_sel <= out_reg1; -- reg1 = reg2+reg1 (result)
                
            -- Ramo No (a <= b)
            when B1 =>
                in_sel1 <= sel_b; in_sel2 <= sel_b; op <= op_mul; out_sel <= out_reg1; -- reg1 = b*b
                
            when B2 =>
                in_sel1 <= sel_reg1; in_sel2 <= sel_b; op <= op_mul; out_sel <= out_reg1; -- reg1 = reg1*b
                
            when B3 =>
                in_sel1 <= sel_a; in_sel2 <= sel_a; op <= op_mul; out_sel <= out_reg2; -- reg2 = a*a
                
            when B4 =>
                in_sel1 <= sel_reg1; in_sel2 <= sel_reg2; op <= op_add; out_sel <= out_reg1; -- reg1 = reg1+reg2
                
            when B5 =>
                in_sel1 <= sel_c; in_sel2 <= sel_b; op <= op_add; out_sel <= out_reg2; -- reg2 = c+b
                
            when B6 =>
                in_sel1 <= sel_reg1; in_sel2 <= sel_reg2; op <= op_div; out_sel <= out_reg1; -- reg1 = reg1/reg2 (result)

            when others =>
                null;
        end case;
    end process;

end Behavioral;
