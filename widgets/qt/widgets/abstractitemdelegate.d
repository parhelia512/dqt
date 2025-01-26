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
module qt.widgets.abstractitemdelegate;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.list;
import qt.core.object;
import qt.core.objectdefs_impl;
import qt.core.size;
import qt.gui.event;
import qt.gui.painter;
import qt.helpers;
import qt.widgets.abstractitemview;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(itemviews); +/


extern(C++, class) struct QAbstractItemDelegatePrivate;

/// Binding for C++ class [QAbstractItemDelegate](https://doc.qt.io/qt-6/qabstractitemdelegate.html).
abstract class /+ Q_WIDGETS_EXPORT +/ QAbstractItemDelegate : QObject
{
    mixin(Q_OBJECT);

public:

    enum EndEditHint {
        NoHint,
        EditNextItem,
        EditPreviousItem,
        SubmitModelCache,
        RevertModelCache
    }

    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject parent = null);
    }));
    /+ virtual +/~this();

    // painting
    /+ virtual +/ abstract void paint(QPainter* painter,
                           ref const(QStyleOptionViewItem) option,
                           ref const(QModelIndex) index) const;

    /+ virtual +/ abstract QSize sizeHint(ref const(QStyleOptionViewItem) option,
                               ref const(QModelIndex) index) const;

    // editing
    /+ virtual +/ QWidget createEditor(QWidget parent,
                                      ref const(QStyleOptionViewItem) option,
                                      ref const(QModelIndex) index) const;

    /+ virtual +/ void destroyEditor(QWidget editor, ref const(QModelIndex) index) const;

    /+ virtual +/ void setEditorData(QWidget editor, ref const(QModelIndex) index) const;

    /+ virtual +/ void setModelData(QWidget editor,
                                  QAbstractItemModel model,
                                  ref const(QModelIndex) index) const;

    /+ virtual +/ void updateEditorGeometry(QWidget editor,
                                          ref const(QStyleOptionViewItem) option,
                                          ref const(QModelIndex) index) const;

    // for non-widget editors
    /+ virtual +/ bool editorEvent(QEvent event,
                                 QAbstractItemModel model,
                                 ref const(QStyleOptionViewItem) option,
                                 ref const(QModelIndex) index);

    /+ virtual +/ bool helpEvent(QHelpEvent event,
                               QAbstractItemView view,
                               ref const(QStyleOptionViewItem) option,
                               ref const(QModelIndex) index);

    /+ virtual +/ QList!(int) paintingRoles() const;

/+ Q_SIGNALS +/public:
    @QSignal final void commitData(QWidget editor);
    @QSignal final void closeEditor(QWidget editor, EndEditHint hint = EndEditHint.NoHint);
    @QSignal final void sizeHintChanged(ref const(QModelIndex) );

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QObjectPrivate , QObject parent = null);
    }));
private:
    /+ Q_DECLARE_PRIVATE(QAbstractItemDelegate) +/
    /+ Q_DISABLE_COPY(QAbstractItemDelegate) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_commitDataAndCloseEditor(QWidget*)) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

