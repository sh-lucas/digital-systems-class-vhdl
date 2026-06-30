library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_TopLevel is
end tb_TopLevel;

architecture Behavioral of tb_TopLevel is
    signal clk : std_logic := '0';
    signal start : std_logic := '0';
    signal a : integer := 0;
    signal b : integer := 0;
    signal c : integer := 0;
    signal result : integer;
    signal ready : std_logic;

    constant clk_period : time := 10 ns;

begin

    uut: entity work.TopLevel
        port map (
            clk => clk,
            start => start,
            a => a,
            b => b,
            c => c,
            result => result,
            ready => ready
        );

    -- clk
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- estimulos
    stim_proc: process
    begin
        -- tempo de estabilizacao inicial
        wait for clk_period * 2;

        -- caso 1: a > b
        a <= 4;
        b <= 2;
        c <= 3;
        start <= '1';
        wait for clk_period;
        start <= '0';

        wait until ready = '1';
        report "Caso 1 finalizado em " & time'image(now) severity note;
        wait for clk_period;
        
        assert (result = 203)
            report "Erro no caso 1: esperado 203, obteve " & integer'image(result)
            severity error;

        wait for clk_period * 2;

        -- caso 2: a <= b
        a <= 2;
        b <= 3;
        c <= 4;
        start <= '1';
        wait for clk_period;
        start <= '0';

        wait until ready = '1';
        report "Caso 2 finalizado em " & time'image(now) severity note;
        wait for clk_period;
        
        assert (result = 4)
            report "Erro no caso 2: esperado 4, obteve " & integer'image(result)
            severity error;

        wait for clk_period * 2;

        -- caso 3: a > b (outro conjunto de valores)
        -- Formula simplificada: 3a^3 - b + 6c^2/a
        -- Para a=5, b=1, c=2:
        -- 3*(125) - 1 + (6*4)/5 = 375 - 1 + 24/5 = 374 + 4 = 378
        a <= 5;
        b <= 1;
        c <= 2;
        start <= '1';
        wait for clk_period;
        start <= '0';

        wait until ready = '1';
        report "Caso 3 finalizado em " & time'image(now) severity note;
        wait for clk_period;

        assert (result = 378)
            report "Erro no caso 3: esperado 378, obteve " & integer'image(result)
            severity error;

        wait for clk_period * 2;

        -- caso 4: a <= b (limite de igualdade a=b)
        -- Formula: (b^3 + a^2)/(c + b)
        -- Para a=3, b=3, c=2:
        -- (27 + 9)/(2 + 3) = 36/5 = 7
        a <= 3;
        b <= 3;
        c <= 2;
        start <= '1';
        wait for clk_period;
        start <= '0';

        wait until ready = '1';
        report "Caso 4 finalizado em " & time'image(now) severity note;
        wait for clk_period;

        assert (result = 7)
            report "Erro no caso 4: esperado 7, obteve " & integer'image(result)
            severity error;

        report "Todos os testes foram executados com sucesso!" severity note;
        wait;
    end process;

end Behavioral;
