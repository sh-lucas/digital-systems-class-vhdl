library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
    Port (
        clk : in std_logic;
        a, b, c : in integer;
        in_sel1 : in std_logic_vector(2 downto 0);
        in_sel2 : in std_logic_vector(2 downto 0);
        op : in std_logic_vector(1 downto 0);
        out_sel : in std_logic;
        result : out integer
    );
end Datapath;

architecture Behavioral of Datapath is
    -- registradores
    signal reg1, reg2 : integer := 0;
    
    -- muxes
    signal mux1_out, mux2_out : integer;
    
    -- ula
    signal ula_out : integer;

begin

    -- mux 1
    process (in_sel1, a, b, c, reg1, reg2)
    begin
        case in_sel1 is
            when "000" => mux1_out <= a;
            when "001" => mux1_out <= b;
            when "010" => mux1_out <= c;
            when "011" => mux1_out <= reg1;
            when "100" => mux1_out <= reg2;
            when "101" => mux1_out <= 0;
            when "110" => mux1_out <= 3;
            when "111" => mux1_out <= 6;
            when others => mux1_out <= 0;
        end case;
    end process;

    -- mux 2
    process (in_sel2, a, b, c, reg1, reg2)
    begin
        case in_sel2 is
            when "000" => mux2_out <= a;
            when "001" => mux2_out <= b;
            when "010" => mux2_out <= c;
            when "011" => mux2_out <= reg1;
            when "100" => mux2_out <= reg2;
            when "101" => mux2_out <= 0;
            when "110" => mux2_out <= 3;
            when "111" => mux2_out <= 6;
            when others => mux2_out <= 0;
        end case;
    end process;

    -- ula única
    process (mux1_out, mux2_out, op)
    begin
        case op is
            when "00" => ula_out <= mux1_out + mux2_out; -- ADD
            when "01" => ula_out <= mux1_out - mux2_out; -- SUB
            when "10" => ula_out <= mux1_out * mux2_out; -- MUL
            when "11" => 
                if mux2_out = 0 then
                    ula_out <= 0; -- divisão por zero protection
                else
                    ula_out <= mux1_out / mux2_out; -- DIV
                end if;
            when others => ula_out <= 0;
        end case;
    end process;

    -- registradores (reg1 é o próprio result)
    process (clk)
    begin
        if rising_edge(clk) then
            if out_sel = '0' then
                reg1 <= ula_out;
            else
                reg2 <= ula_out;
            end if;
        end if;
    end process;

    result <= reg1;

end Behavioral;
