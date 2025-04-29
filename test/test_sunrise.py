import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_sunrise_tt(dut):
    dut._log.info("Start sunrise_tt test")

    dut.rst_n.value = 0
    await Timer(100, units='ns')
    dut.rst_n.value = 1

    for _ in range(100):
        await RisingEdge(dut.clk)
