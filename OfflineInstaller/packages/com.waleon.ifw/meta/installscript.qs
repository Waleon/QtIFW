function Component()
{
    // 默认构造
}

Component.prototype.createOperations = function()
{
    // 调用默认实现
    component.createOperations();

    // 添加开始菜单
    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut",
                           "@TargetDir@/bin/MyApp.exe",
                           "@StartMenuDir@/MyApp.lnk",
                           "workingDirectory=@TargetDir@");
    }
}