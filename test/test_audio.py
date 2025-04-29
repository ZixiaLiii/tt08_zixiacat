import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_audio_output(dut):
    dut._log.info("Start test")

    # 初始复位
    dut.rst_n.value = 0
    await Timer(100, units='ns')
    dut.rst_n.value = 1

    # 等待几个时钟周期观察输出
    for _ in range(1000):
        await Timer(40, units='ns')  # 25MHz = 40ns

    dut._log.info(f"PWM out = {dut.aud_pwm.value}")
