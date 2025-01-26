/*
 * DQt - D bindings for the Qt Toolkit
 *
 * GNU Lesser General Public License Usage
 * This file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPL3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
 */
module qt.widgets.toolbar;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.gui.action;
import qt.gui.event;
import qt.helpers;
import qt.widgets.styleoption;
import qt.widgets.widget;
static if (defined!"QT_WIDGETS_BUILD_REMOVED_API")
{
    import qt.core.object;
    import qt.gui.icon;
}

/+ QT_REQUIRE_CONFIG(toolbar); +/


extern(C++, class) struct QToolBarPrivate;


/// Binding for C++ class [QToolBar](https://doc.qt.io/qt-6/qtoolbar.html).
class /+ Q_WIDGETS_EXPORT +/ QToolBar : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool movable READ isMovable WRITE setMovable NOTIFY movableChanged)
    Q_PROPERTY(Qt::ToolBarAreas allowedAreas READ allowedAreas WRITE setAllowedAreas
               NOTIFY allowedAreasChanged)
    Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation
               NOTIFY orientationChanged)
    Q_PROPERTY(QSize iconSize READ iconSize WRITE setIconSize NOTIFY iconSizeChanged)
    Q_PROPERTY(Qt::ToolButtonStyle toolButtonStyle READ toolButtonStyle WRITE setToolButtonStyle
               NOTIFY toolButtonStyleChanged)
    Q_PROPERTY(bool floating READ isFloating)
    Q_PROPERTY(bool floatable READ isFloatable WRITE setFloatable) +/

public:
    /+ explicit +/this(ref const(QString) title, QWidget parent = null);
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final void setMovable(bool movable);
    final bool isMovable() const;

    final void setAllowedAreas(/+ Qt:: +/qt.core.namespace.ToolBarAreas areas);
    final /+ Qt:: +/qt.core.namespace.ToolBarAreas allowedAreas() const;

    pragma(inline, true) final bool isAreaAllowed(/+ Qt:: +/qt.core.namespace.ToolBarArea area) const
    { return (allowedAreas() & area) == area; }

    final void setOrientation(/+ Qt:: +/qt.core.namespace.Orientation orientation);
    final /+ Qt:: +/qt.core.namespace.Orientation orientation() const;

    final void clear();

    /+ using QWidget::addAction; +/
    static if (defined!"QT_WIDGETS_BUILD_REMOVED_API")
    {
        final QAction addAction(ref const(QString) text);
        final QAction addAction(ref const(QIcon) icon, ref const(QString) text);
        mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
        final QAction addAction(ref const(QString) text, const(QObject) receiver, const(char)* member);
        }));
        mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
        final QAction addAction(ref const(QIcon) icon, ref const(QString) text,
                               const(QObject) receiver, const(char)* member);
        }));
    }

    final QAction addSeparator();
    final QAction insertSeparator(QAction before);

    final QAction addWidget(QWidget widget);
    final QAction insertWidget(QAction before, QWidget widget);

    final QRect actionGeometry(QAction action) const;
    final QAction actionAt(ref const(QPoint) p) const;
    pragma(inline, true) final QAction actionAt(int ax, int ay) const
    { auto tmp = QPoint(ax, ay); return actionAt(tmp); }

    final QAction toggleViewAction() const;

    final QSize iconSize() const;
    final /+ Qt:: +/qt.core.namespace.ToolButtonStyle toolButtonStyle() const;

    final QWidget widgetForAction(QAction action) const;

    final bool isFloatable() const;
    final void setFloatable(bool floatable);
    final bool isFloating() const;

public /+ Q_SLOTS +/:
    @QSlot final void setIconSize(ref const(QSize) iconSize);
    @QSlot final void setToolButtonStyle(/+ Qt:: +/qt.core.namespace.ToolButtonStyle toolButtonStyle);

/+ Q_SIGNALS +/public:
    @QSignal final void actionTriggered(QAction action);
    @QSignal final void movableChanged(bool movable);
    @QSignal final void allowedAreasChanged(/+ Qt:: +/qt.core.namespace.ToolBarAreas allowedAreas);
    @QSignal final void orientationChanged(/+ Qt:: +/qt.core.namespace.Orientation orientation);
    @QSignal final void iconSizeChanged(ref const(QSize) iconSize);
    @QSignal final void toolButtonStyleChanged(/+ Qt:: +/qt.core.namespace.ToolButtonStyle toolButtonStyle);
    @QSignal final void topLevelChanged(bool topLevel);
    @QSignal final void visibilityChanged(bool visible);

protected:
    override void actionEvent(QActionEvent event);
    override void changeEvent(QEvent event);
    override void paintEvent(QPaintEvent event);
    override bool event(QEvent event);
    /+ virtual +/ void initStyleOption(QStyleOptionToolBar* option) const;


private:
    /+ Q_DECLARE_PRIVATE(QToolBar) +/
    /+ Q_DISABLE_COPY(QToolBar) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_toggleView(bool))
    Q_PRIVATE_SLOT(d_func(), void _q_updateIconSize(const QSize &))
    Q_PRIVATE_SLOT(d_func(), void _q_updateToolButtonStyle(Qt::ToolButtonStyle)) +/

    /+ friend class QMainWindow; +/
    /+ friend class QMainWindowLayout; +/
    /+ friend class QToolBarLayout; +/
    /+ friend class QToolBarAreaLayout; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

