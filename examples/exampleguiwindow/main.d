module exampleguiwindow.main;

import qt.config;
import qt.helpers;

int main(string[] args)
{
    import core.runtime;
    import exampleguiwindow.paintwindow;
    import qt.gui.guiapplication;

    int argc = Runtime.cArgs.argc; // Reference needs to be valid for lifetime of application object.
    char** argv = Runtime.cArgs.argv;
    scope a = new QGuiApplication(argc, argv);

    scope window = new PaintWindow;
    window.show();

    return a.exec();
}

