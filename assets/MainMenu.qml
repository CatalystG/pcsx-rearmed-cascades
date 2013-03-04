import bb.cascades 1.0
import bb.cascades.pickers 1.0

Page {
    id: menu
    actionBarVisibility: {
        if(emulatorVisable){
            ChromeVisibility.Hidden
        } else {
            ChromeVisibility.Visible
        }
    }
    actions: [
        ActionItem {
            title: "Play"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/ic_open.png"
            onTriggered: {
                if(_frontend.rom == ""){
                    //Do something to focus on select rom box
                } else {
                    OrientationSupport.supportedDisplayOrientation = 
                            SupportedDisplayOrientation.DisplayLandscape;
                    emulatorVisable = true;
                }
            }
        }
    ]
    
    property alias romDirectory: picker.directories
    property bool boxartEnabled
    property bool useNetImage: false    
    
    titleBar: TitleBar {
        id: titleBar
        title: "PCSX-reARMed-BB"
        visibility:  {
            if(emulatorVisable) {
                ChromeVisibility.Hidden
            } else {
                ChromeVisibility.Visible
            }
        }
    }
    
    // Content Container
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        
        Container {
            layout: AbsoluteLayout {}
            
            ForeignWindowControl {
	            id: _myForeignWindow
	            objectName: "myForeignWindow"
	            keyInputForwardingEnabled: true
	            windowId: "emulator_pcsx"
	
	            visible: emulatorVisable
	            layoutProperties: AbsoluteLayoutProperties {
	                positionX: 0
	                positionY: 0
	            }
	            preferredWidth: 1280
	            preferredHeight: 768
	            
	            updatedProperties: WindowProperty.Size | WindowProperty.Position | WindowProperty.Visible
	            
	            onBoundToWindowChanged: {
	                if(boundToWindow){
	                    emulatorVisable = true;
	                } else {
	                    emulatorVisable = false;
	                }
	            }
	        }
        }
        
	    Container {
	        topPadding: 10
	        visible: !emulatorVisable

	        Container {
	            minHeight: 250
	            horizontalAlignment: HorizontalAlignment.Center
	            
	            ImageView {
				    id: myImageView
				    imageSource: "asset:///images/ps1_icon.png"
				}
	        }  
	
	        // Top Container with a RadioButtonGroup and title
	        Container {
	            preferredWidth: 650
	            horizontalAlignment: HorizontalAlignment.Center
	            Container {
	                preferredWidth: 650
	                bottomPadding: 50
	                horizontalAlignment: HorizontalAlignment.Center
	                
	                layout: StackLayout {
	                    orientation: LayoutOrientation.LeftToRight
	                }
	                
	                TextField {
	                    id: romName
	                    objectName: "romName"
	                    verticalAlignment: VerticalAlignment.Center
	                    enabled: false
	                    hintText: "Select a ROM"
	                    text: picker.selectedFile
	                }
	                
	                Button {
	                    text: "..."
	                    horizontalAlignment: HorizontalAlignment.Right
	                    preferredWidth: 1
	                    onClicked: {
	                        picker.open();
	                    }
	                }
	            }
	            
	        } // Top Container        
	        
	        Divider {}
	        
	        //Recently played on launch, replaced with boxart
	        /*
	        Container {
	            //preferredHeight: 500
                preferredWidth: 768
                visible: !requestStarted
                
                Label {
                    horizontalAlignment: HorizontalAlignment.Center
                    text: "Recently Played"
                    textStyle { 
					     base: textStyleBoldTitle.style
					 }
                }
                
                Container {
                    layout: StackLayout {}
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        
                        ImageView {
                            preferredWidth: 384
                            scalingMethod: ScalingMethod.AspectFit
                            //imageSource: "file:///accounts/1000/shared/misc/pcsx-rearmed-pb/boxart/196-2.jpg"
                        }
                        
                        ImageView {
                            preferredWidth: 384
                            scalingMethod: ScalingMethod.AspectFit
                            //imageSource: "file:///accounts/1000/shared/misc/pcsx-rearmed-pb/boxart/196-2.jpg"
                        }
                        ImageView {
                            preferredWidth: 384
                            scalingMethod: ScalingMethod.AspectFit
                            //imageSource: "file:///accounts/1000/shared/misc/pcsx-rearmed-pb/boxart/196-2.jpg"
                        }
                    }
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        
                        ImageView {
                            preferredWidth: 384
                            scalingMethod: ScalingMethod.AspectFit
                            //imageSource: "file:///accounts/1000/shared/misc/pcsx-rearmed-pb/boxart/196-2.jpg"
                        }
                        
                        ImageView {
                            preferredWidth: 384
                            scalingMethod: ScalingMethod.AspectFit
                            //imageSource: "file:///accounts/1000/shared/misc/pcsx-rearmed-pb/boxart/196-2.jpg"
                        }
                        ImageView {
                            preferredWidth: 384
                            scalingMethod: ScalingMethod.AspectFit
                            //imageSource: "file:///accounts/1000/shared/misc/pcsx-rearmed-pb/boxart/196-2.jpg"
                        }
                    }
                }
	        }*/
	        
	        //Boxart
	        Container {
                preferredHeight: 500
                preferredWidth: 768
                topPadding: 50
                visible: boxartEnabled

                layout: DockLayout {}

                // The ActivityIndicator that is only active and visible while the image is loading
                ActivityIndicator {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    preferredHeight: 300

                    visible: if(_frontend.boxart) _frontend.boxart.loading
                    running: if(_frontend.boxart) _frontend.boxart.loading
                }

                // The ImageView that shows the loaded image after loading has finished without error
                ImageView {
                    id: boxart
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    scalingMethod: ScalingMethod.AspectFit
                    image: {
                        if(_frontend.boxart && useNetImage && _frontend.boxartLoaded) 
                            _frontend.boxart.image
                        else 
                            _tracker.image;
                    }
                    visible: true
                }

                // The Label that shows a possible error message after loading has finished
                Label {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    preferredWidth: 500

                    visible: if(_frontend.boxart) !_frontend.boxart.loading && !_frontend.boxart.label == ""
                    text: if(_frontend.boxart) _frontend.boxart.label
                    multiline: true
                }
            }
	        
	        onCreationCompleted: {
	            OrientationSupport.supportedDisplayOrientation = 
	                SupportedDisplayOrientation.CurrentLocked;
	        }
	        
	        attachedObjects: [
	            TextStyleDefinition {
	                id: textStyleBoldTitle
	                base: SystemDefaults.TextStyles.TitleText
	                //fontWeight: FontWeight.Bold
	            }
	        ]
	    } // Content Container
	    
	    attachedObjects: [
	        FilePicker {
	            id: picker
	
	            property string selectedFile
	            
	            title: "Rom Selector"
	            filter: ["*.bin", "*.cue", "*.iso", "*.toc", "*.img", "*.ccd", "*.sub", "*.mdf", "*.mds", "*.Z", "*.bz", "*.cbn"]
	            type: FileType.Other
	
	            onFileSelected: {
	                _frontend.rom = selectedFiles[0];
	                selectedFile = _frontend.rom.substr(_frontend.rom.lastIndexOf('/')+1);
	                picker.directories = [_frontend.rom.substr(0, _frontend.rom.lastIndexOf('/'))];
	                
	                if(boxartEnabled){
	                    var tmp = picker.selectedFile.indexOf("(")
		                if(tmp == -1){
		                    _tracker.imageSource = "file:///accounts/1000/shared/misc/pcsx-rearmed-bb/.boxart/" + picker.selectedFile.substr(0, picker.selectedFile.lastIndexOf(".")).trim() + ".jpg";
		                } else {
		                    _tracker.imageSource = "file:///accounts/1000/shared/misc/pcsx-rearmed-bb/.boxart/" + picker.selectedFile.substr(0, tmp).trim() + ".jpg";
		                }
	                }
	            }
	        },
	        OrientationHandler {
	              onOrientationChanged: {
	                  if(OrientationSupport.supportedDisplayOrientation == SupportedDisplayOrientation.DisplayLandscape){
	                      _frontend.startEmulator(1);
	                  }
	              }
	        }, 
	        ImageTracker {
	            id: _tracker
	            //imageSource: "file://shared/misc/pcsx-rearmed-pb/boxart/" + picker.selectedFile.substr(0,picker.selectedFile.lastIndexOf(".")) + ".jpg"
	        
	            onStateChanged: {
	                if (state == 0x2) {//Loaded
	                    //_frontend.boxart.image = _tracker.image;
	                    useNetImage = false;
	                } else if (state == 0x3) {//Not found
	                    //console.log("Image Not Found: " + _tracker.imageSource);
	                    _frontend.loadBoxArt(picker.selectedFile);
	                    useNetImage = true;
	                } else if (state > 0x3 ) { //Error states
	                    //myImageView.imageSource = "asset:///images/ps1_icon.png";
	                    //console.log("Image Failed: " + _tracker.imageSource);
	                }
	            }
	        }
	    ]           
	} 
} // Page