library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
    Port (
        clk : in std_logic;
        a, b, c : in integer;
        s11, s12 : in std_logic_vector(2 downto 0);
        s21, s22 : in std_logic_vector(2 downto 0);
        op1, op2 : in std_logic_vector(1 downto 0);
        reg1_en : in std_logic;
        reg2_en : in std_logic;
        load_result : in std_logic;
        result : out integer
    );
end Datapath;

architecture Behavioral of Datapath is
    -- registradores
    signal reg1, reg2 : integer := 0;
    signal reg_result : integer := 0;
    
    -- muxes
    signal mux11_out, mux12_out : integer;
    signal mux21_out, mux22_out : integer;
    
    -- ulas
    signal ula1_out, ula2_out : integer;
    
    -- divisor
    signal div_out : integer;

begin

    -- muxes da ula 1
    process (s11, a, b, c, reg1, reg2)
    begin
        case s11 is
            when "000" => mux11_out <= a;
            when "001" => mux11_out <= b;
            when "010" => mux11_out <= c;
            when "011" => mux11_out <= reg1;
            when "100" => mux11_out <= reg2;
            when "101" => mux11_out <= 0;
            when "110" => mux11_out <= 3;
            when "111" => mux11_out <= 6;
            when others => mux11_out <= 0;
        end case;
    end process;

    process (s12, a, b, c, reg1, reg2)
    begin
        case s12 is
            when "000" => mux12_out <= a;
            when "001" => mux12_out <= b;
            when "010" => mux12_out <= c;
            when "011" => mux12_out <= reg1;
            when "100" => mux12_out <= reg2;
            when "101" => mux12_out <= 0;
            when "110" => mux12_out <= 3;
            when "111" => mux12_out <= 6;
            when others => mux12_out <= 0;
        end case;
    end process;

    -- muxes da ula 2
    process (s21, a, b, c, reg1, reg2)
    begin
        case s21 is
            when "000" => mux21_out <= a;
            when "001" => mux21_out <= b;
            when "010" => mux21_out <= c;
            when "011" => mux21_out <= reg1;
            when "100" => mux21_out <= reg2;
            when "101" => mux21_out <= 0;
            when "110" => mux21_out <= 3;
            when "111" => mux21_out <= 6;
            when others => mux21_out <= 0;
        end case;
    end process;

    process (s22, a, b, c, reg1, reg2)
    begin
        case s22 is
            when "000" => mux22_out <= a;
            when "001" => mux22_out <= b;
            when "010" => mux22_out <= c;
            when "011" => mux22_out <= reg1;
            when "100" => mux22_out <= reg2;
            when "101" => mux22_out <= 0;
            when "110" => mux22_out <= 3;
            when "111" => mux22_out <= 6;
            when others => mux22_out <= 0;
        end case;
    end process;

    -- ula 1
    process (mux11_out, mux12_out, op1)
    begin
        case op1 is
            when "00" => ula1_out <= mux11_out + mux12_out;
            when "01" => ula1_out <= mux11_out - mux12_out;
            when "10" => ula1_out <= mux11_out * mux12_out;
            when "11" => ula1_out <= mux11_out;
            when others => ula1_out <= 0;
        end case;
    end process;

    -- ula 2
    process (mux21_out, mux22_out, op2)
    begin
        case op2 is
            when "00" => ula2_out <= mux21_out + mux22_out;
            when "01" => ula2_out <= mux21_out - mux22_out;
            when "10" => ula2_out <= mux21_out * mux22_out;
            when "11" => ula2_out <= mux21_out;
            when others => ula2_out <= 0;
        end case;
    end process;

    -- divisor
    process (reg1, reg2)
    begin
        if reg2 = 0 then
            div_out <= 0;
        else
            div_out <= reg1 / reg2;
        end if;
    end process;

    -- registradores
    process (clk)
    begin
        if rising_edge(clk) then
            if reg1_en = '1' then
                reg1 <= ula1_out;
            end if;
            if reg2_en = '1' then
                reg2 <= ula2_out;
            end if;
            if load_result = '1' then
                reg_result <= div_out;
            end if;
        end if;
    end process;

    result <= reg_result;

end Behavioral;
