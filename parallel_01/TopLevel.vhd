library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
    Port (
        clk : in std_logic;
        start : in std_logic;
        a : in integer;
        b : in integer;
        c : in integer;
        result : out integer;
        ready : out std_logic
    );
end TopLevel;

architecture Structural of TopLevel is
    -- fios de controle
    signal sig_s11, sig_s12 : std_logic_vector(2 downto 0);
    signal sig_s21, sig_s22 : std_logic_vector(2 downto 0);
    signal sig_op1, sig_op2 : std_logic_vector(1 downto 0);
    signal sig_reg1_en : std_logic;
    signal sig_reg2_en : std_logic;
    signal sig_load_result : std_logic;
    
    -- fios de status
    signal sig_a_gt_b : std_logic;

begin

    -- comparador
    sig_a_gt_b <= '1' when a > b else '0';

    -- fsm
    FSM_inst : entity work.FSM
        port map (
            clk => clk,
            start => start,
            a_gt_b => sig_a_gt_b,
            s11 => sig_s11,
            s12 => sig_s12,
            s21 => sig_s21,
            s22 => sig_s22,
            op1 => sig_op1,
            op2 => sig_op2,
            reg1_en => sig_reg1_en,
            reg2_en => sig_reg2_en,
            load_result => sig_load_result,
            ready => ready
        );

    -- datapath
    Datapath_inst : entity work.Datapath
        port map (
            clk => clk,
            a => a,
            b => b,
            c => c,
            s11 => sig_s11,
            s12 => sig_s12,
            s21 => sig_s21,
            s22 => sig_s22,
            op1 => sig_op1,
            op2 => sig_op2,
            reg1_en => sig_reg1_en,
            reg2_en => sig_reg2_en,
            load_result => sig_load_result,
            result => result
        );

end Structural;
