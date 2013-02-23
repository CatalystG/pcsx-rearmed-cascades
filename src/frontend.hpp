/* Copyright (c) 2012 Research In Motion Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef FRONTEND_H
#define FRONTEND_H

#include <bb/cascades/Application>
#include <bb/cascades/Container>
#include <QThread>
#include <bb/cascades/Image>
#include "imageloader.hpp"
#include "NetRequest.hpp"
#include "../../libpcsx-rearmed-bb10/bb10/pcsx-rearmed-bb10.h"

using namespace bb::cascades;

class Frontend: public QThread
{
    Q_OBJECT
    Q_PROPERTY(QString rom READ getRom WRITE setRom NOTIFY romChanged)
    Q_PROPERTY(ImageLoader* boxart READ getBoxArt NOTIFY boxArtChanged)
    Q_PROPERTY(bool boxartLoaded READ boxartLoaded NOTIFY boxartLoadedChanged)

public:
    // This is our constructor that sets up the recipe.
    Frontend();
    ~Frontend();

    /* Invokable functions that we can call from QML*/

    /**
     * This Invokable function gets a value from the QSettings,
     * if that value does not exist in the QSettings database, the default value is returned.
     *
     * @param objectName Index path to the item
     * @param defaultValue Used to create the data in the database when adding
     * @return If the objectName exists, the value of the QSettings object is returned.
     *         If the objectName doesn't exist, the default value is returned.
     */
    Q_INVOKABLE
    QString getValueFor(const QString &objectName, const QString &defaultValue);

    /**
     * This function sets a value in the QSettings database. This function should to be called
     * when a data value has been updated from QML
     *
     * @param objectName Index path to the item
     * @param inputValue new value to the QSettings database
     */
    Q_INVOKABLE
    void saveValueFor(const QString &objectName, const QString &inputValue);
    Q_INVOKABLE
    void startEmulator(int start);
    //Q_INVOKABLE
    //void createCheatsPage();
    //Q_INVOKABLE
    //void LoadRom();
    Q_INVOKABLE
    void SaveState();
    Q_INVOKABLE
    void LoadState();
    Q_INVOKABLE
    int mapButton();
    Q_INVOKABLE
    void EnterMenu(int code);
    Q_INVOKABLE
    void setSettings();
    Q_INVOKABLE
    void loadBoxArt(const QString &url);
    Q_INVOKABLE
    int getControllerValue(int player, int button_id);
    Q_INVOKABLE
    void setControllerValue(int player, int button_id, int map);

signals:
	void romChanged(QString);
	void boxArtChanged(ImageLoader*);
	void boxartLoadedChanged(bool);

public slots:
	//void addCheatToggle(int);
	//void addCheatDropDown(int);
	void onManualExit();
	void onBoxArtRecieved(const QString &info, bool success);
	//void emitSendCheat();
	//void handleSendCheat();

private:
	QString getRom();
	bool boxartLoaded();
	void setRom(QString i);
	ImageLoader* getBoxArt();


    void run();
    //Container *createCheatToggle(sCheatInfo *pCur);
    //Container *createCheatDropDown(sCheatInfo *pCur);
    void create_button_mapper();
    int loadConfigFromJson(QString file);
    void saveConfigToJson(QString file);
    bool mStartEmu;
    int mVideoPlugin;
    QString mRom;
    int mAudio;
    Container *mCheatsContainer;
    ImageLoader* m_boxart;
    bool m_boxartLoaded;
    Controller m_controllers[2];
};

#endif // ifndef STARSHIPSETTINGSAPP_H
