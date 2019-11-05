// 控制脚本：如果程序已安装，则会调用 maintenance 工具，自动进行卸载。

function Controller()
{
    gui.clickButton(buttons.NextButton);
    gui.clickButton(buttons.NextButton);

    // 连接信号槽
    installer.uninstallationFinished.connect(this, this.uninstallationFinished);
}

// 当卸载完成时，触发
Controller.prototype.uninstallationFinished = function()
{
    gui.clickButton(buttons.NextButton);
}

// 与完成页面上的部件交互
Controller.prototype.FinishedPageCallback = function()
{
    gui.clickButton(buttons.FinishButton);
}
