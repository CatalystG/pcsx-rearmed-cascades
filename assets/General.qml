import bb.cascades 1.0
import bb.cascades.pickers 1.0 

Page { 
    property alias sdcard: sdcard.checked
    property alias boxartEnabled: boxart.checked
    property bool helpEnabled: false
    
    titleBar: TitleBar {
        id: titleBar3
        title: "General Settings"
        visibility:  ChromeVisibility.Visible
    }
    
    actions: [
        ActionItem {
            
            id: help
            title: {
                if(helpEnabled){
                    "Hide Help"
                } else {
                    "Show Help"
                }
            }
            imageSource: "asset:///images/ic_help.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                if(!helpEnabled)
                    helpEnabled = true;
                else
                    helpEnabled = false;
            }
        }
    ]
    
    Container{
        topPadding: 20
        leftPadding: 20
        rightPadding: 20
        
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            preferredWidth: 768
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
        
            Label {
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Center
                preferredWidth: 768
                text: "Default to SD Card"
            }
            
            ToggleButton {
                id: sdcard
                checked: _frontend.getValueFor(objectName, "false")
                objectName: "sdcard"
                horizontalAlignment: HorizontalAlignment.Right
                onCheckedChanged: {
                    _frontend.saveValueFor(sdcard.objectName, checked)
                }
            }
            
        }
        
        Label {
            id: _help
            text: "When choosing a ROM, the SD Card will be the default location to search"
            multiline: true
            visible: helpEnabled
            textStyle {
                base: SystemDefaults.TextStyles.BodyText
                fontStyle: FontStyle.Italic
            } 
        }
        
        Divider {}
        
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
        
            Label {
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Center
                preferredWidth: 768
                text: "Per Rom Video Settings"
            }
            
            ToggleButton {
                id: perRom
                checked: _frontend.getValueFor(objectName, "true")
                objectName: "perRom"
                horizontalAlignment: HorizontalAlignment.Right
                onCheckedChanged: {
                    _frontend.saveValueFor(perRom.objectName, checked)
                }
            }
        }
        
        Label {
            id: _help2
            text: "When a ROM is selected, remember the values previously set for it."
            multiline: true
            visible: helpEnabled
            textStyle {
                base: SystemDefaults.TextStyles.BodyText
                fontStyle: FontStyle.Italic
            } 
        }
        
        Divider {}
        
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
        
            Label {
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Center
                preferredWidth: 768
                text: "Boxart Scraping"
            }
            
            ToggleButton {
                id: boxart
                checked: _frontend.getValueFor(objectName, "true")
                objectName: "boxart"
                horizontalAlignment: HorizontalAlignment.Right
                onCheckedChanged: {
                    _frontend.saveValueFor(boxart.objectName, checked)
                }
            }
        }
        
        Label {
            id: _help3
            text: "Boxart for roms will be automatically downloaded and displayed."
            multiline: true
            visible: helpEnabled
            textStyle {
                base: SystemDefaults.TextStyles.BodyText
                fontStyle: FontStyle.Italic
            } 
        }
        
        Divider {}
        
        Label {
			horizontalAlignment: HorizontalAlignment.Left
			verticalAlignment: VerticalAlignment.Center
			preferredWidth: 768
			text: "Bios Selection"
        }
        
        Container {
            preferredWidth: 650
            horizontalAlignment: HorizontalAlignment.Center
            
            Container {
                preferredWidth: 650
                horizontalAlignment: HorizontalAlignment.Center
                
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                TextField {
                    id: biosName
                    verticalAlignment: VerticalAlignment.Center
                    enabled: false
                    hintText: "Select the BIOS"
                    text: _frontend.getValueFor("bios", "/accounts/1000/shared/misc/pcsx-rearmed-bb/bios/SCPH1001.BIN")
                }
                
                Button {
                    text: "..."
                    horizontalAlignment: HorizontalAlignment.Right
                    preferredWidth: 1
                    onClicked: {
                        biosPicker.open();
                    }
                }
            }
            
        } // Top Container
        
        Divider {}
        
        attachedObjects: [
	         FilePicker {
     	        id: biosPicker
     	
     	        property string selectedBios
     	        
     	        title: "Bios Selector"
     	        filter: ["*.bin", "*.BIN"]
     	        type: FileType.Other
     	        directories: ["/accounts/1000/shared/misc/pcsx-rearmed-bb/bios"]
     	
     	        onFileSelected: {
     	            selectedBios = selectedFiles[0].substr(selectedFiles[0].lastIndexOf('/')+1);
     	            _frontend.saveValueFor("bios", selectedBios);
     	            _frontend.saveValueFor("biosDir", selectedFiles[0].substr(0, selectedFiles[0].lastIndexOf('/')+1));
     	        }
     	    }   
 	    ]
    }
}