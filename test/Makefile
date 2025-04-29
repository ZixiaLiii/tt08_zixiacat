TOPLEVEL_LANG = verilog
SIM = icarus

MODULE := test_simple_audio
TOPLEVEL := simple_audio_tt
include $(shell cocotb-config --makefiles)/Makefile.sim

# Extra target for hvsync_generator
test_hvsync:
	$(MAKE) MODULE=test_hvsync \
	         TOPLEVEL=hvsync_generator \
	         -f $(shell cocotb-config --makefiles)/Makefile.sim

