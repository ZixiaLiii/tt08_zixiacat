# Makefile for cocotb testbench

# 所有源文件，默认全部加入
VERILOG_SOURCES = \
    ../src/simple_audio_tt.v \
    ../src/hvsync_generator.v \
    ../src/fade_level_generator_tt.v \
    ../src/background_twilight_tt.v \
    ../src/stars_tt.v \
    ../src/sunrise_tt.v \
    ../src/sprite_cat_tt.v

TOPLEVEL_LANG = verilog
MODULE        = test_$(TEST)  # 对应 test_模块名.py

# 每个模块的 Verilog 顶层名字（用于仿真）
ifeq ($(TEST),simple_audio)
    TOPLEVEL = simple_audio_tt
endif
ifeq ($(TEST),hvsync)
    TOPLEVEL = hvsync_generator
endif
ifeq ($(TEST),fade)
    TOPLEVEL = fade_level_generator_tt
endif
ifeq ($(TEST),bg)
    TOPLEVEL = background_twilight_tt
endif
ifeq ($(TEST),stars)
    TOPLEVEL = stars_tt
endif
ifeq ($(TEST),sunrise)
    TOPLEVEL = sunrise_tt
endif
ifeq ($(TEST),sprite)
    TOPLEVEL = sprite_cat_tt
endif

# 设置仿真器
SIM = icarus
COCOTB_SIM = 1
COCOTB_REDUCED_LOG_FMT = 1

# 加载 cocotb 默认 Makefile
include $(shell cocotb-config --makefiles)/Makefile.sim





