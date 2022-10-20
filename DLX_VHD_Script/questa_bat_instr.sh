#vlib work

vcom -quiet 000-globals.vhd
vcom -quiet a.d-Datapath/a.d.b-ID/a.d.b.a-REG.vhd
##############  IF stage ################
vcom -quiet a.d-Datapath/a.d.a-IF/a.d.a.a-SU_PC.vhd
vcom -quiet a.d-Datapath/a.d.a-fetch_stage.vhd
##############  ID stage ################


vcom -quiet a.d-Datapath/a.d.b-ID/a.d.b.a-log_function.vhd
vcom -quiet a.d-Datapath/a.d.b-ID/a.d.b.a-MUX21.vhd
vcom -quiet a.d-Datapath/a.d.b-ID/a.d.b.a-register_file.vhd
vcom -quiet a.d-Datapath/a.d.b-ID/a.d.b.a-sign_extender.vhd
vcom -quiet a.d-Datapath/a.d.b-ID/a.d.b.a-sign_extender_26.vhd
vcom -quiet a.d-Datapath/a.d.b-decode_stages.vhd
##############  EXE stage ###############
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.a-adder/a.d.c.a-BC_adder.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.a-adder/a.d.c.a-adder.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.e-muxONE.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.d-demux_exe.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.d-demuxbuffer.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.f-flag.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.c-cmp.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.i-shifter.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.g-Nand3.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.g-Nand3_2.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.g-Logic.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.b-buffer_br.vhd
vcom -quiet a.d-Datapath/a.d.c-EXE/a.d.c.b-zero_detector.vhd
vcom -quiet a.d-Datapath/a.d.c-Exe_stage.vhd
##############  MEM stage ################
vcom -quiet a.d-Datapath/a.d.d-Mem_stage.vhd
##############  WB ################
vcom -quiet a.d-Datapath/a.d.e-WB_stage.vhd
vcom -quiet a.d-Datapath/a.d.f-HZ.vhd
vcom -quiet a.d-DataPath.vhd

#___________________________________________CU DIR

vcom -quiet a.c-CU/a.c.a-REG_cu.vhd
vcom -quiet a.c-cu_stage.vhd
#___________________________________________OUT FROM

vcom -quiet  a.b-IRAM.vhd
vcom -quiet  a.a-Ram.vhd
vcom -quiet  a-DLX.vhd
vcom -quiet  testbench/a-testbench.vhd
