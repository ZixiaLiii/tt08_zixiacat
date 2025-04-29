import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_simple_audio(dut):
    dut._log.info("Start simple_audio_tt test")

    # 初始化复位
    dut.rst_n.value = 0
    await Timer(100, units='ns')
    dut.rst_n.value = 1

    # 运行一定时间
    for _ in range(100):
        await RisingEdge(dut.clk)
