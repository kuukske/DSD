transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Bram Kuijk/Documents/DSD/WK1_PWM/load_1.vhd}
vcom -93 -work work {C:/Users/Bram Kuijk/Documents/DSD/WK1_PWM/counter.vhd}
vcom -93 -work work {C:/Users/Bram Kuijk/Documents/DSD/WK1_PWM/compare_PWM.vhd}
vcom -93 -work work {C:/Users/Bram Kuijk/Documents/DSD/WK1_PWM/compare_period.vhd}
vcom -93 -work work {C:/Users/Bram Kuijk/Documents/DSD/WK1_PWM/PWM_Controller.vhd}

