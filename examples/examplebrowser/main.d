module examplebrowser.main;

import qt.config;
import qt.helpers;

int main()
{
    import core.runtime;
    import examplebrowser.mainwindow;
    import qt.widgets.application;

    int argc = Runtime.cArgs.argc; // Reference needs to be valid for lifetime of application object.
    char** argv = Runtime.cArgs.argv;
    scope a = new QApplication(argc, argv);
    scope w = new MainWindow;
    w.show();
    return a.exec();
}

