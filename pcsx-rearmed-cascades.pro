TEMPLATE = app
TARGET = pcsx-rearmed-cascades

CONFIG += qt warn_on debug_and_release cascades

INCLUDEPATH += 
SOURCES += ../src/*.cpp
#SOURCES += ../src/*.c
HEADERS += ../src/*.hpp

LIBS += -L../lib -lscreen -lasound -lTouchControlOverlay -lpng -lz -lbps -Bstatic -L ../../libpcsx-rearmed-bb10 -lpcsx -Bdynamic#-L ../../libpcsx-rearmed-bb10 -lpcsx 

LIBS += -lbbcascadespickers -lbbsystem -lbbdata
INCLUDEPATH += ${QNX_TARGET}/usr/include/bb/cascades/pickers

device {
	CONFIG(release, debug|release) {		
		DESTDIR = o.le-v7		
		TEMPLATE=lib
	} 
	CONFIG(debug, debug|release) {
		DESTDIR = o.le-v7-g
	}
}

simulator {
	CONFIG(release, debug|release) {
		DESTDIR = o
	} 
	CONFIG(debug, debug|release) {
		DESTDIR = o-g
	}
}

OBJECTS_DIR = $${DESTDIR}/.obj
MOC_DIR = $${DESTDIR}/.moc
RCC_DIR = $${DESTDIR}/.rcc
UI_DIR = $${DESTDIR}/.ui
