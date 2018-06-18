create_clock -name "CLK_50M" -period 20.000ns [get_ports {CLK_50M}]
derive_pll_clocks
derive_clock_uncertainty