# Makefile for cocotb testbench

VERILOG_SOURCES = \
    ../src/simple_audio_tt.v \
    ../src/hvsync_generator.v \
    ../src/fade_level_generator_tt.v

TOPLEVEL_LANG = verilog
MODULE = test_$(TEST)  # 自动匹配 test_开头的 Python 测试文件名

TOPLEVEL = $(TEST)_tt  # 顶层 Verilog 模块名称，比如 hvsync_generator.v -> hvsync_generator

SIM = icarus
COCOTB_REDUCED_LOG_FMT = 1
COCOTB_SIM = 1

include $(shell cocotb-config --makefiles)/Makefile.sim


