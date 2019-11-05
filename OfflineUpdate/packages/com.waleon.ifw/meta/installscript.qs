var targetDirectoryPage = null;

// 构造函数
function Component() 
{
    installer.gainAdminRights();
    component.loaded.connect(this, this.installerLoaded);
}

// 实用函数，类似于 QString QDir::toNativeSeparators()
var Dir = new function () {
    this.toNativeSparator = function (path) {
        if (installer.value("os") == "win")
            return path.replace(/\//g, '\\');
        return path;
    }
};

// 添加桌面和开始菜单快捷方式
Component.prototype.createOperations = function() 
{
    component.createOperations();
    component.addOperation("CreateShortcut",
                           "@TargetDir@/bin/MyApp.exe",
                           "@DesktopDir@/MyApp.lnk",
                           "workingDirectory=@TargetDir@");

    component.addOperation("CreateShortcut",
                           "@TargetDir@/bin/MyApp.exe",
                           "@StartMenuDir@/MyApp.lnk",
                           "workingDirectory=@TargetDir@");
}

// 加载组件后立即调用
Component.prototype.installerLoaded = function()
{
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
    installer.addWizardPage(component, "TargetWidget", QInstaller.TargetDirectory);

    targetDirectoryPage = gui.pageWidgetByObjectName("DynamicTargetWidget");
    targetDirectoryPage.windowTitle = "选择安装目录";
    targetDirectoryPage.description.setText("请选择程序的安装位置：");
    targetDirectoryPage.targetDirectory.textChanged.connect(this, this.targetDirectoryChanged);
    targetDirectoryPage.targetDirectory.setText(Dir.toNativeSparator(installer.value("TargetDir")));
    targetDirectoryPage.targetChooser.released.connect(this, this.targetChooserClicked);

    gui.pageById(QInstaller.ComponentSelection).entered.connect(this, this.componentSelectionPageEntered);
}

// 当点击选择安装位置按钮时调用
Component.prototype.targetChooserClicked = function()
{
    var dir = QFileDialog.getExistingDirectory("", targetDirectoryPage.targetDirectory.text);
    if (dir != "") {
        targetDirectoryPage.targetDirectory.setText(Dir.toNativeSparator(dir));
    }
}

// 当安装位置发生改变时调用
Component.prototype.targetDirectoryChanged = function()
{
    var dir = targetDirectoryPage.targetDirectory.text;
    if (installer.fileExists(dir) && installer.fileExists(dir + "/bin/MyApp.exe")) {
        targetDirectoryPage.warning.setText("<p style=\"color: red\">检测到程序已安装，继续将会被覆盖。</p>");
    } else {
        targetDirectoryPage.warning.setText("");
    }
    installer.setValue("TargetDir", dir);
}

// 当进入【选择组件】页面时调用
Component.prototype.componentSelectionPageEntered = function()
{
    var dir = installer.value("TargetDir");
    if (installer.fileExists(dir) && installer.fileExists(dir + "/maintenancetool.exe")) {
        installer.execute(dir + "/maintenancetool.exe", "--script=" + dir + "/script/uninstallscript.qs");
    }
}