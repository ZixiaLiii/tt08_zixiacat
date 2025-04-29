import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_sprite_cat_tt(dut):
    dut._log.info("Start sprite_cat_tt test")

    dut.rst_n.value = 0
    await Timer(100, units='ns')
    dut.rst_n.value = 1

    for _ in range(100):
        await RisingEdge(dut.clk_pix)
