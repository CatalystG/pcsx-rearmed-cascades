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
#include "frontend.hpp"
#include <sys/stat.h>
#include <unistd.h>
#include <string>

#include <bb/cascades/QmlDocument>
#include <bb/cascades/TabbedPane>
#include <bb/cascades/DropDown>
#include <bb/cascades/Divider>
#include <bb/cascades/ToggleButton>
#include <bb/cascades/Label>
#include <bb/cascades/FontStyle>
#include <bb/cascades/TextStyle>
#include <bb/cascades/StackLayout>
#include <bb/cascades/SystemDefaults>
#include <QSettings>
#include <bb/cascades/Window>
#include <bb/cascades/pickers/FilePicker>
#include <bb/cascades/pickers/FilePickerMode>
#include <bb/cascades/pickers/FilePickerSortFlag>
#include <bb/cascades/pickers/FilePickerSortOrder>
#include <bb/cascades/pickers/FileType>
#include <bb/cascades/pickers/ViewMode>
#include <QSignalMapper>
#include <bb/data/XmlDataAccess>
#include <bb/data/JsonDataAccess>

#include <bb/system/SystemToast>
#include <bps/bps.h>
#include <bps/screen.h>

#include "main.h"

#include <sys/neutrino.h>

using namespace bb::cascades;
using namespace bb::system;
using namespace bb::data;

screen_context_t screen_cxt;
screen_window_t screen_win_map;
screen_buffer_t screen_buf[2];
int rect[4];
SystemToast *toast;
SystemToast *toastButton;

typedef union {
	_pulse pulse;
	int msg;
}recv_msg;

QString CheatList = "";
enum {
	DKEY_SELECT = 0,
	DKEY_L3,
	DKEY_R3,
	DKEY_START,
	DKEY_UP,
	DKEY_RIGHT,
	DKEY_DOWN,
	DKEY_LEFT,
	DKEY_L2,
	DKEY_R2,
	DKEY_L1,
	DKEY_R1,
	DKEY_TRIANGLE,
	DKEY_CIRCLE,
	DKEY_CROSS,
	DKEY_SQUARE,
};

SettingsBB10 cfg_bb10;

int chid = -1, coid = -1;

void Frontend::create_button_mapper() {
	const int usage2 = SCREEN_USAGE_NATIVE | SCREEN_USAGE_WRITE | SCREEN_USAGE_READ;
	int rc;

	screen_create_context(&screen_cxt, SCREEN_APPLICATION_CONTEXT);
	screen_create_window_type(&screen_win_map, screen_cxt, SCREEN_CHILD_WINDOW);

	screen_join_window_group(screen_win_map, Application::instance()->mainWindow()->groupId().toAscii().constData());
	int format = SCREEN_FORMAT_RGBA8888;
	screen_set_window_property_iv(screen_win_map, SCREEN_PROPERTY_FORMAT, &format);

	screen_set_window_property_iv(screen_win_map, SCREEN_PROPERTY_USAGE, &usage2);

	const char *env = getenv("WIDTH");

	if (0 == env) {
		perror("failed getenv for WIDTH");
	}

	int width2 = atoi(env);

	env = getenv("HEIGHT");

	if (0 == env) {
		perror("failed getenv for HEIGHT");
	}

	int height2 = atoi(env);
	rect[0] = 0;
	rect[1] = 0;
	rect[2] = width2;
	rect[3] = height2;

	rc = screen_set_window_property_iv(screen_win_map, SCREEN_PROPERTY_BUFFER_SIZE, rect+2);
	if (rc) {
		perror("screen_set_window_property_iv");
	}

	int z2 = -10;
	if (screen_set_window_property_iv(screen_win_map, SCREEN_PROPERTY_ZORDER, &z2) != 0) {
		return;
	}

	rc = screen_create_window_buffers(screen_win_map, 2);
	if (rc) {
		perror("screen_create_window_buffers");
	}

	screen_get_window_property_pv(screen_win_map, SCREEN_PROPERTY_RENDER_BUFFERS, (void **)screen_buf);

	int bg[] = { SCREEN_BLIT_COLOR, 0x00000000,
				 SCREEN_BLIT_GLOBAL_ALPHA, 0x80,
				 SCREEN_BLIT_END };
	screen_fill(screen_cxt, screen_buf[0], bg);
	screen_fill(screen_cxt, screen_buf[1], bg);

	screen_pixmap_t screen_pix2;
	screen_create_pixmap( &screen_pix2, screen_cxt );

	int format2 = SCREEN_FORMAT_RGBA8888;
	screen_set_pixmap_property_iv(screen_pix2, SCREEN_PROPERTY_FORMAT, &format2);

	int pix_usage = SCREEN_USAGE_WRITE | SCREEN_USAGE_NATIVE;
	screen_set_pixmap_property_iv(screen_pix2, SCREEN_PROPERTY_USAGE, &pix_usage);

	screen_post_window(screen_win_map, screen_buf[0], 1, rect, 0);

	bps_initialize();
	screen_request_events(screen_cxt);
}

Frontend::Frontend()
{
	qmlRegisterType<bb::cascades::pickers::FilePicker>("bb.cascades.pickers", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("bb.cascades.pickers", 1, 0, "FileType", "");
	qmlRegisterType<ImageLoader>();
	mStartEmu = false;
	m_boxart = 0;

	check_profile();

	toast = new SystemToast(this);
	toastButton = new SystemToast(this);

	memset(&m_controllers[0], 0, sizeof(Controller));
	memset(&m_controllers[1], 0, sizeof(Controller));

	//Set touchscreen as default
	m_controllers[0].device = 1;

	chid = ChannelCreate(0);
	coid = ConnectAttach(0, 0, chid, _NTO_SIDE_CHANNEL, 0);

    // Set the application organization and name, which is used by QSettings
    // when saving values to the persistent store.
    QCoreApplication::setOrganizationName("Example");
    QCoreApplication::setApplicationName("PCSX-reARMed-BB");

    //Load config from json file
    if(loadConfigFromJson(QString("shared/misc/pcsx-rearmed-bb/cfg/data.json")) == -1) {
    	//QFile(QString("assets/data.json")).copy(QString("shared/misc/pcsx-rearmed-pb/cfg/data.json"));
    }

    // Then we load the application.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml");
    qml->setContextProperty("_frontend", this);

    if (!qml->hasErrors()) {
        TabbedPane *tab = qml->createRootObject<TabbedPane>();
        if (tab) {
        	mCheatsContainer = tab->findChild<Container*>("cheats");

            Application::instance()->setScene(tab);

            start();
        }
    }
}

Frontend::~Frontend()
{

}

//load data from json into controllers
//{ "device" : int,
//	"buttons": [ int, int, int, ..., 16]
//}
int Frontend::loadConfigFromJson(QString file) {
	JsonDataAccess jda;
	int i;

	QVariantMap data = jda.load(file).toMap();

	if(data.isEmpty()){
		return -1;
	}

	m_controllers[0].device = data["device"].toInt();

	for(i=0;i<16;++i) {
		m_controllers[0].buttons[i] = data["buttons"].toList()[i].toInt();
	}

	return 0;
}

//write out
void Frontend::saveConfigToJson(QString file) {
	QVariantMap data;
	int i;

	data["device"] = m_controllers[0].device;

	QVariantList buttons;

	for(i=0;i<16;++i) {
		buttons.append(QVariant(m_controllers[0].buttons[i]));
	}

	data["buttons"] = QVariant(buttons);

	// Create a JsonDataAccess object and save the data to the file
	JsonDataAccess jda;
	jda.save(QVariant(data), file);
}

void Frontend::onManualExit() {
	printf("OnManualExit!\n");fflush(stdout);

	saveConfigToJson(QString("shared/misc/pcsx-rearmed-bb/cfg/data.json"));

	printf("Saved Config!\n");fflush(stdout);

	bb10_pcsx_stop_emulator();

	int msg = 2;
	//MsgSend(coid, &msg, sizeof(msg), NULL, 0);
	//wait();
	printf("FInished waiting!\n");fflush(stdout);
	quit();

	printf("OnManualExit end!\n");fflush(stdout);
}

//A separate QThread that runs the emulator.
void Frontend::run()
{
	recv_msg msg;
	int rcvid;
	int z = 5;
	int sym = -1;
	bps_event_t *event = NULL;

	create_button_mapper();

	while(1) {
		while(1){
			rcvid = MsgReceive(chid, &msg, sizeof(msg), 0);

			if(rcvid <= 0){
				continue;
			}

			if(msg.msg == 1){
				MsgReply(rcvid, 0, NULL, 0);
				break;
			} else if (msg.msg == 2){
				MsgReply(rcvid, 0, NULL, 0);
				return;
			}

			z = 5;
			if (screen_set_window_property_iv(screen_win_map, SCREEN_PROPERTY_ZORDER, &z) != 0) {
				return;
			}

			screen_post_window(screen_win_map, screen_buf[0], 1, rect, 0);

			while(1){
				if (BPS_SUCCESS != bps_get_event(&event, -1)) {
					fprintf(stderr, "bps_get_event failed\n");
					break;
				}

				if (event) {
					int domain = bps_event_get_domain(event);

					if (domain == screen_get_domain()) {
						screen_event_t screen_event = screen_event_get_event(event);
						int screen_val;
						screen_get_event_property_iv(screen_event, SCREEN_PROPERTY_TYPE, &screen_val);

						if(screen_val == SCREEN_EVENT_MTOUCH_TOUCH){
							//This is touch screen event
							sym = -1;
							break;
						} else if(screen_val == SCREEN_EVENT_KEYBOARD) {
							screen_get_event_property_iv(screen_event, SCREEN_PROPERTY_KEY_SYM, &sym);
							break;
						}
					}
				}
			}

			z = -10;
			if (screen_set_window_property_iv(screen_win_map, SCREEN_PROPERTY_ZORDER, &z) != 0) {
				return;
			}
			screen_post_window(screen_win_map, screen_buf[0], 1, rect, 0);

			int ret = sym&0xff;
			MsgReply(rcvid, 0, &ret, sizeof(ret));
		}

		//Cheats
		//printf("CheatList: %s\n", CheatList.toAscii().constData());
		//m64p->l_CheatNumList = strdup((char*)CheatList.toAscii().constData());
		//bb10_pcsx_set_rom((char*)mRom.toAscii().constData());
		bb10_main(&screen_cxt, Application::instance()->mainWindow()->groupId().toAscii().constData(), "emulator_pcsx");
		//m64p->Start();
	}
}

QString Frontend::getValueFor(const QString &objectName, const QString &defaultValue)
{
    QSettings settings;

    // If no value has been saved, return the default value.
    if (settings.value(objectName).isNull()) {
        return defaultValue;
    }

    // Otherwise, return the value stored in the settings object.
    return settings.value(objectName).toString();
}

void Frontend::saveValueFor(const QString &objectName, const QString &inputValue)
{
    // A new value is saved to the application settings object.
    QSettings settings;
    settings.setValue(objectName, QVariant(inputValue));
}

void Frontend::setControllerValue(int player, int button_id, int map){
	if(button_id == -1){
		m_controllers[player].device = map;
	}

	m_controllers[player].buttons[button_id] = map;
}

int Frontend::getControllerValue(int player, int button_id){
	if(button_id == -1){
		return m_controllers[player].device;
	}

	return m_controllers[player].buttons[button_id];
}

void Frontend::startEmulator(int msg_code)
{
	bb10_pcsx_set_rom((char*)mRom.toAscii().constData());
	setSettings();

	int msg = msg_code;

	MsgSend(coid, &msg, sizeof(msg), NULL, 0);

	return;
}

//Getters and Setters
QString Frontend::getRom()
{
    return mRom;
}

void Frontend::setRom(QString i)
{
    mRom = i;
    //m64p->SetRom(mRom.toAscii().constData());
    emit romChanged(mRom);
}

//Getters and Setters
ImageLoader* Frontend::getBoxArt()
{
    return m_boxart;
}

bool Frontend::boxartLoaded()
{
	return m_boxartLoaded;
}

void Frontend::loadBoxArt(const QString &url)
{
	m_boxartLoaded = false;
	emit boxartLoadedChanged(m_boxartLoaded);

	TwitterRequest* request = new TwitterRequest(this);
	connect(request, SIGNAL(complete(QString, bool)), this, SLOT(onBoxArtRecieved(QString, bool)));
	request->requestTimeline(url);
}

void Frontend::onBoxArtRecieved(const QString &info, bool success)
{
    TwitterRequest *request = qobject_cast<TwitterRequest*>(sender());

    if (success) {
    	XmlDataAccess dataAccess;
    	QString url = "";

		const QVariant variant = dataAccess.loadFromBuffer(info);

		const QVariantMap games = variant.toMap();

		//qDebug() << "URL: " << games["baseImgUrl"];
		url.append(games["baseImgUrl"].toString());

		//IF there is one game, games["game"] will be a map rather than list
		QVariantList game = games["Game"].toList();

		//TODO: Will crash with one game
		//qDebug() << "GAME: " << game;

		QVariantMap selected;
		if(!game.isEmpty()){
			selected = game[0].toMap();
		} else {
			selected = games["Game"].toMap();
		}
		QVariantMap images = selected["Images"].toMap();
		QVariantList boxart = images["boxart"].toList();

		url.append((boxart[1].toMap())[".data"].toString());

		//qDebug() << "FULL URL: " << url;

		//Could make obj once, and reuse
		if(m_boxart) {
			delete m_boxart;
		}

		m_boxart = new ImageLoader(url, mRom);
		emit boxArtChanged(m_boxart);

		m_boxart->load();

		m_boxartLoaded = true;
		emit boxartLoadedChanged(m_boxartLoaded);
    }

    request->deleteLater();
}

void Frontend::setSettings()
{
	//getValueFor config and set settings
	cfg_bb10.gpu_neon_enhancement = getValueFor(QString("gpu_neon_enhancement"), QString("false"))==QString("true") ? 1: 0;
	cfg_bb10.gpu_neon_enhancement_no_main = getValueFor(QString("gpu_neon_enhancement_no_main"), QString("false"))==QString("true") ? 1: 0;
	cfg_bb10.soft_filter = getValueFor(QString("soft_filter"), QString("0")).toInt();
	cfg_bb10.frameskip = getValueFor(QString("frameskip"), QString("0")).toInt();//= -1, 1, 0
	//BIOS, find bios with picker
	//TODO: free bios_name
	cfg_bb10.bios_name = strdup((char*)getValueFor(QString("bios_name"), QString("SCPH1001.BIN")).toAscii().constData());

	//AUDIO
	cfg_bb10.audio_xa = getValueFor(QString("xa"), QString("false"))==QString("true") ? 1: 0;
	cfg_bb10.audio_cdda = getValueFor(QString("cdda"), QString("false"))==QString("true") ? 1: 0;
	cfg_bb10.analog_enabled = getValueFor(QString("analog_enabled"), QString("false"))==QString("true") ? 1: 0;
	cfg_bb10.controllers = (Controller*)m_controllers;
	cfg_bb10.chid = chid;

	bb10_pcsx_set_settings(&cfg_bb10);
}

QSignalMapper *signalMapperToggle;
QSignalMapper *signalMapperDropDown;

/*
void Frontend::addCheatToggle(int number){
	ToggleButton *senderButton = (ToggleButton*)signalMapperToggle->mapping(number);

	if(senderButton->isChecked()){
		CheatList.append(QString("%1,").arg(number));
	} else {
		CheatList.remove(QString("%1,").arg(number));
	}
}

void Frontend::addCheatDropDown(int number){
	DropDown *senderDropDown = (DropDown*)signalMapperDropDown->mapping(number);

	int foundLoc = -1;
	int removeUntil = 0;

	//to remove, index=cheat number. We need to see if it's already there, and remove it.
	//1,2,3-4, or 3-4,1,2

	foundLoc = CheatList.indexOf(QString("%1-").arg(number));
	if(foundLoc != -1){
		removeUntil = CheatList.indexOf(",", foundLoc);
		CheatList.remove(foundLoc, removeUntil-foundLoc+1);
	}

	if(senderDropDown->selectedIndex() > 0 ){
		CheatList.append(QString("%1-%2,").arg(number).arg(senderDropDown->selectedIndex()-1));
	}

	fflush(stdout);
}

Container * Frontend::createCheatToggle(sCheatInfo *pCur) {
	ToggleButton *toggle;

	Container *returnContainer = Container::create().top(20.0f);
	TextStyle *italicStyle = new TextStyle(SystemDefaults::TextStyles::bodyText());
	italicStyle->setFontStyle(FontStyle::Italic);

	//Container with Label and Toggle
	Container *CheatToggle = Container::create();

	StackLayout *pStackLayout = new StackLayout();
	pStackLayout->setOrientation( LayoutOrientation::LeftToRight );
	CheatToggle->setLayout(pStackLayout);

	CheatToggle->add(Label::create().text(QString(pCur->Name))
									.vertical(VerticalAlignment::Center)
									.preferredWidth(768.0f)
									.multiline(true)
									);
	toggle = ToggleButton::create().vertical(VerticalAlignment::Center);

	signalMapperToggle->setMapping(toggle, pCur->Number);
	connect(toggle, SIGNAL(checkedChanged(bool)), signalMapperToggle, SLOT(map()));

	CheatToggle->add(toggle);

	returnContainer->add(CheatToggle);

	//Container with description label
	if(pCur->Description != NULL){
		Container *CheatDescription = Container::create().bottom(20.0f);
		CheatDescription->add(Label::create().text(QString(pCur->Description))
				.vertical(VerticalAlignment::Center)
				.preferredWidth(768.0f)
				.multiline(true)
				.textStyle(*italicStyle)
				);
		returnContainer->add(CheatDescription);
	}

	returnContainer->add(Divider::create());

	return returnContainer;
}

Container * Frontend::createCheatDropDown(sCheatInfo *pCur){
	DropDown *dropDown;
	Option * tmp;

	Container *returnContainer = Container::create().top(20.0f);
	TextStyle *italicStyle = new TextStyle(SystemDefaults::TextStyles::bodyText());
	italicStyle->setFontStyle(FontStyle::Italic);

	dropDown = DropDown::create().vertical(VerticalAlignment::Center)
			                     .title(QString(pCur->Name));

	tmp = Option::create().text("Disable").value(0);
	dropDown->add(tmp);

	for (int i = 0; i < pCur->Codes[pCur->VariableLine].var_count; i++) {
		//printf("      %i: %s\n", i, pCur->Codes[pCur->VariableLine].variable_names[i]);
		tmp = Option::create().text(QString("%1").arg(pCur->Codes[pCur->VariableLine].variable_names[i]))
				              .value(i+1);
		dropDown->add(tmp);
	}


	signalMapperDropDown->setMapping(dropDown, pCur->Number);
	connect(dropDown, SIGNAL(selectedIndexChanged(int)), signalMapperDropDown, SLOT(map()));

	returnContainer->add(dropDown);

	//Container with description label
	if(pCur->Description != NULL){
		Container *CheatDescription = Container::create().bottom(20.0f);
		CheatDescription->add(Label::create().text(QString(pCur->Description))
				.vertical(VerticalAlignment::Center)
				.preferredWidth(768.0f)
				.multiline(true)
				.textStyle(*italicStyle)
				);
		returnContainer->add(CheatDescription);
	}

	returnContainer->add(Divider::create());

	return returnContainer;
}

void Frontend::createCheatsPage(){
	char numCheats = 0;
	CheatStart(CHEAT_SHOW_LIST, &numCheats);
	fflush(stdout);

	signalMapperToggle = new QSignalMapper(this);
	connect(signalMapperToggle, SIGNAL(mapped(int)), this, SLOT(addCheatToggle(int)));

	signalMapperDropDown = new QSignalMapper(this);
	connect(signalMapperDropDown, SIGNAL(mapped(int)), this, SLOT(addCheatDropDown(int)));

	mCheatsContainer->removeAll();
	mCheatsContainer->setLeftPadding(20.0f);
	mCheatsContainer->setRightPadding(20.0f);
	sCheatInfo *pCur = l_CheatList;
	while (pCur != NULL)
	{
		if (pCur->VariableLine == -1){
			if (pCur->Description == NULL){
				//printf("   %i: %s\n", pCur->Number, pCur->Name);
				mCheatsContainer->add(createCheatToggle(pCur));
			}
			else {
				//printf("   %i: %s (%s)\n", pCur->Number, pCur->Name, pCur->Description);
				mCheatsContainer->add(createCheatToggle(pCur));
			}
		//TODO: Check if this is true and make a dropdown
		} else {
			int i;
			mCheatsContainer->add(createCheatDropDown(pCur));
			//for (i = 0; i < pCur->Codes[pCur->VariableLine].var_count; i++)
				//printf("      %i: %s\n", i, pCur->Codes[pCur->VariableLine].variable_names[i]);
		}
		pCur = pCur->Next;
	}

	CheatFreeAll();
}
*/

void Frontend::SaveState(){
	bb10_pcsx_save_state();
}

void Frontend::LoadState() {
	bb10_pcsx_load_state();
}

void Frontend::EnterMenu(int code) {
	//code 1 is from normal enter, 2 is from disc swap
	bb10_pcsx_enter_menu(code);
}

int Frontend::mapButton(){

	int msg = 0, ret = 0;

	toastButton->cancel();
	toast->setBody("Press a Button to Map");
	toast->show();

	MsgSend(coid, &msg, sizeof(msg), &ret, sizeof(ret));

	toast->cancel();
	if(ret != -1){
		toastButton->setBody("Button Pressed");
	} else {
		toastButton->setBody("Canceling");
	}
	toastButton->show();

	return ret;
}
