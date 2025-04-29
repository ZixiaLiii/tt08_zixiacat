import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_fade_level_generator(dut):
    dut._log.info("Start fade_level_generator_tt test")

    # 复位
    dut.rst_n.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # 模拟一段时间，观察 fade_level 是否正常变动
    prev_value = int(dut.fade_level.value)
    changes = 0

    for _ in range(1000):
        await RisingEdge(dut.clk)
        current = int(dut.fade_level.value)
        if current != prev_value:
            dut._log.info(f"fade_level changed: {prev_value} -> {current}")
            prev_value = current
            changes += 1

    assert changes > 0, "fade_level did not change during simulation"
