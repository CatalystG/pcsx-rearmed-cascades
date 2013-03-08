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
import bb.cascades 1.0
import bb.cascades.pickers 1.0 

TabbedPane {
    property bool emulatorVisable: false
    property alias picker: picker
    property bool useNetImage
    property int resume
    
    Menu.definition: MenuDefinition {
	    actions: [
	      ActionItem {
	          title: "Save State"
	          imageSource: "asset:///images/save_load.png"
	          enabled: emulatorVisable
	          onTriggered: {
	              _frontend.SaveState();
	          }
	      },
	      ActionItem {
	          title: "Load State"
	          imageSource: "asset:///images/save_load.png"
	          enabled: emulatorVisable
	          onTriggered: {
  	              _frontend.LoadState();
  	          }
	      },
  	      ActionItem {
	          title: "Menu"
	          imageSource: "asset:///images/home.png"
	          enabled: emulatorVisable
	          onTriggered: {
	              resume = 1
  	              _frontend.EnterMenu(resume);
  	              emulatorVisable = false;
  	              OrientationSupport.supportedDisplayOrientation = 
  	                                          SupportedDisplayOrientation.DisplayPortrait;
  	          } 
	      },
	      ActionItem {
  	          title: "Disc Swap"
  	          imageSource: "asset:///images/eject.png"
  	          enabled: emulatorVisable
  	          /*
  	          onTriggered: {
    	              _frontend.EnterMenu(2);
    	              emulatorVisable = false;
    	              OrientationSupport.supportedDisplayOrientation = 
    	                                          SupportedDisplayOrientation.DisplayPortrait;
    	          } */
	          onTriggered: {
	              resume = 2;
	              _frontend.EnterMenu(resume);
  	              //emulatorVisable = false;
    	          picker.open();
    	      }
  	      },
	      ActionItem {
  	          title: "Close"
  	          imageSource: "asset:///images/ic_cancel.png"
  	      }
	    ]
    }
    //showTabsOnActionBar: true
    Tab {
        title: "Home" 
        imageSource: "asset:///images/home.png"
        MainMenu {
            boxartEnabled: general.boxartEnabled
        }
    }
    Tab {
	    title: "General"
	    id: generalTest
	    General {
	        id: general
	    }
    }
    Tab {
        title: "Video"
        imageSource: "asset:///images/video.png"
        Video {}
    }
    Tab {
        title: "Audio"
        imageSource: "asset:///images/sound.png"
        Audio {}
    }
    Tab {
        title: "Input"
        imageSource: "asset:///images/input.png"
        Input {}
    }
    //This tab is dynamically generated in C++
    Tab {
        title: "Cheats"
        imageSource: "asset:///images/ic_lock.png"
        //Cheats {}
        Page{
            titleBar: TitleBar {
                id: titleBar
                title: "Cheat Codes"
                visibility:  ChromeVisibility.Visible
            }
            ScrollView{
                preferredHeight: 1280
                preferredWidth: 768
                
		        Container {
		            objectName: "cheats"
		            
		            Container {
		                preferredWidth: 768
		                preferredHeight: 1000
		            
			            layout: DockLayout {}
	            
			            Label {
			                verticalAlignment: VerticalAlignment.Center
			                horizontalAlignment: HorizontalAlignment.Center
			                text: "Select a ROM" 
			                textStyle {
					            base: SystemDefaults.TextStyles.BigText
					        }  
			            }
		            }
		        }
	        }
	    }
    }
    attachedObjects: [
	    FilePicker {
	        id: picker
	
	        property string selectedFile
	        
	        title: "Rom Selector"
	        filter: ["*.bin", "*.cue", "*.iso", "*.toc", "*.img", "*.ccd", "*.sub", "*.mdf", "*.mds", "*.Z", "*.bz", "*.cbn"]
	        type: FileType.Other
	        directories: {
	            if(general.sdcard == false){
                    ["/accounts/1000/shared/misc/pcsx-rearmed-bb/iso"]
                } else {
                    ["/accounts/100/removable/sdcard"]
                }
	        }
	
	        onFileSelected: {
	            _frontend.rom = selectedFiles[0];
	            selectedFile = _frontend.rom.substr(_frontend.rom.lastIndexOf('/')+1);
	            picker.directories = [_frontend.rom.substr(0, _frontend.rom.lastIndexOf('/'))];
	            
	            if(general.boxartEnabled){
	                var tmp = picker.selectedFile.indexOf("(")
	                if(tmp == -1){
	                    _tracker.imageSource = "file:///accounts/1000/shared/misc/pcsx-rearmed-bb/.boxart/" + picker.selectedFile.substr(0, picker.selectedFile.lastIndexOf(".")).trim() + ".jpg";
	                } else {
	                    _tracker.imageSource = "file:///accounts/1000/shared/misc/pcsx-rearmed-bb/.boxart/" + picker.selectedFile.substr(0, tmp).trim() + ".jpg";
	                }
	            }
	            
	            if(_frontend.running && (resume == 2)) {
	                emulatorVisable = true;
                    _frontend.startEmulator(3);
	            }
	        }
	    },
        ImageTracker {
            id: _tracker
        
            onStateChanged: {
                if (state == 0x2) {//Loaded
                    useNetImage = false;
                } else if (state == 0x3) {//Not found
                    _frontend.loadBoxArt(picker.selectedFile);
                    useNetImage = true;
                } else if (state > 0x3 ) { //Error states

                }
            }
        }
	]
}
