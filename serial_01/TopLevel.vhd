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
    signal sig_in_sel1, sig_in_sel2 : std_logic_vector(2 downto 0);
    signal sig_op : std_logic_vector(1 downto 0);
    signal sig_out_sel : std_logic;
    
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
            in_sel1 => sig_in_sel1,
            in_sel2 => sig_in_sel2,
            op => sig_op,
            out_sel => sig_out_sel,
            ready => ready
        );

    -- datapath
    Datapath_inst : entity work.Datapath
        port map (
            clk => clk,
            a => a,
            b => b,
            c => c,
            in_sel1 => sig_in_sel1,
            in_sel2 => sig_in_sel2,
            op => sig_op,
            out_sel => sig_out_sel,
            result => result
        );

end Structural;
