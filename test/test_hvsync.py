import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_hvsync_generator(dut):
    dut._log.info("Start hvsync_generator test")

    # 初始化复位
    dut.rst_n.value = 0
    await Timer(100, units='ns')
    dut.rst_n.value = 1

    # 等待几个时钟周期
    for _ in range(20):
        await RisingEdge(dut.clk_pix)

    # 检查 hsync, vsync 和 video_active 是否有变化
    hsync_changes = 0
    vsync_changes = 0
    video_active_seen = False
    prev_hsync = dut.hsync.value
    prev_vsync = dut.vsync.value

    for _ in range(1000):
        await RisingEdge(dut.clk_pix)
        if dut.hsync.value != prev_hsync:
            hsync_changes += 1
            prev_hsync = dut.hsync.value
        if dut.vsync.value != prev_vsync:
            vsync_changes += 1
            prev_vsync = dut.vsync.value
        if dut.video_active.value == 1:
            video_active_seen = True

    dut._log.info(f"hsync changes: {hsync_changes}")
    dut._log.info(f"vsync changes: {vsync_changes}")
    assert hsync_changes > 0, "hsync did not toggle!"
    assert vsync_changes > 0, "vsync did not toggle!"
    assert video_active_seen, "video_active never became high!"
