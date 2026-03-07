module exampleguiwindow.main;

import qt.config;
import qt.helpers;

int main(string[] args)
{
    import core.runtime;
    import exampleguiwindow.paintwindow;
    import qt.gui.guiapplication;

    scope a = new QGuiApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);

    scope window = new PaintWindow(null);
    window.show();

    return a.exec();
}

