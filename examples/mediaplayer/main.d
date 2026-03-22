module mediaplayer.main;

import qt.config;
import qt.helpers;

int main(string[] args)
{
    import core.runtime;
    import mediaplayer.mainwindow;
    import qt.core.string;
    import qt.widgets.application;

    int argc = Runtime.cArgs.argc; // Reference needs to be valid for lifetime of application object.
    char** argv = Runtime.cArgs.argv;
    scope a = new QApplication(argc, argv);
    string filename;
    if (args.length >= 2)
        filename = args[1];
    scope w = new MainWindow(filename);
    w.show();
    return a.exec();
}

