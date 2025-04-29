# Makefile for cocotb testbench

# 源文件（按模块实际路径添加）
VERILOG_SOURCES = \
    ../src/simple_audio_tt.v \
    ../src/hvsync_generator.v \
    ../src/fade_level_generator_tt.v

TOPLEVEL_LANG = verilog
MODULE        = test_$(TEST)  # test_simple_audio.py => TEST=simple_audio

# 指定每个 TEST 对应的 Verilog 顶层模块名
ifeq ($(TEST),simple_audio)
    TOPLEVEL = simple_audio_tt
endif
ifeq ($(TEST),hvsync)
    TOPLEVEL = hvsync_generator
endif
ifeq ($(TEST),fade)
    TOPLEVEL = fade_level_generator_tt
endif

# 设置仿真器
SIM = icarus

# 开启 cocotb 仿真标志
COCOTB_REDUCED_LOG_FMT = 1
COCOTB_SIM = 1

# 加载 cocotb 的 makefile
include $(shell cocotb-config --makefiles)/Makefile.sim



