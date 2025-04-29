import cocotb
from cocotb.triggers import RisingEdge, Timer
import random

@cocotb.test()
async def test_simple_audio(dut):
    dut._log.info("Start simple_audio_tt test")

    # 初始化复位
    dut.rst_n.value = 0
    await Timer(100, units='ns')
    dut.rst_n.value = 1

    # 运行一定时间并记录 PWM 变化
    high_count = 0
    low_count = 0

    for _ in range(1000):
        await RisingEdge(dut.clk)
        if dut.aud_pwm.value == 1:
            high_count += 1
        else:
            low_count += 1

    dut._log.info(f"aud_pwm high count: {high_count}")
    dut._log.info(f"aud_pwm low  count: {low_count}")

    # 判断 PWM 是否有跳变（高低电平都出现过）
    assert high_count > 0, "aud_pwm 一直为低电平，模块可能未启动"
    assert low_count > 0, "aud_pwm 一直为高电平，模块可能逻辑异常"

