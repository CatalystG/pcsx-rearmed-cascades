import bb.cascades 1.0

Page {
    id: video

    titleBar: TitleBar {
        id: titleBar2
        title: "Video Plugin Settings"
        visibility:  ChromeVisibility.Visible
    }
    
    actions: [
        ActionItem {
            property bool helpEnabled: false
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
        },
        ActionItem {
            title: "Set Defaults"
            imageSource: "asset:///images/default_icon.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                enhance.setDefault();
                enhance_hack.setDefault();
            }
        }
    ]
    
    Container {	    
	    Container {
	        topPadding: 10
	        leftPadding: 20
	        rightPadding: 20
	        
	        ScrollView {
	            preferredHeight: 1280
		        Container{
		            horizontalAlignment: HorizontalAlignment.Center
		            
		            Divider {}
		            
		            VideoSettingToggle {
		                id: enhance
		                settingName: "gpu_neon_enhancement"
		                title: "Enhanced Textures"
		                help: "Render at 2x resolution, at the cost of framerate"
		                showHelp: help.helpEnabled
		                defaultValue: "False"
		            }
		            
		            VideoSettingToggle {
		                id: enhance_hack
		                enabled: enhance.checked
		                settingName: "gpu_neon_enhancement_no_main"
		                title: "Enhanced Texture Hack"
		                help: "Increased framerate, at a cost of image quality"
		                showHelp: help.helpEnabled
		                defaultValue: "False"
		                checked: if(enhance.checked == false) false
		            }
		        
			        DropDown {
			            id: soft_filter
			            title : "Software Filter"
			            enabled : true
			            
			            selectedOption: {
			                var val = _frontend.getValueFor("soft_filter", "0");
			                if(val == 0 || enhance.checked == true) {
			                    noE;
			                } else if (val == 1){
			                    scale;
			                } else if (val == 2){
			                    eagle;
		                    } 
			            }
			            
			            onSelectedValueChanged: {
			                _frontend.saveValueFor("soft_filter", selectedValue);
			                if(selectedValue != 0){
			                    enhance.checked = false;
			                }
			            }
			         
			            // image + text + description
			            Option {
			                id: noE
			                text : "No Enhancement"
			                value : "0"
			            }
			         
			            // text + description
			            Option {
			                id: scale
			                text : "2x Scale Filter"
			                value : "1"
			            }
			            Option {
			                id: eagle
			                text : "2x Eagle Filter"
			                value : "2"
			            }
			        }
			        
			        Divider {}
			        
			        DropDown {
			            id: frameskip
			            title : "Frameskip"
			            enabled : true
			            topMargin: 40
			            
			            selectedOption: {
			                var val = _frontend.getValueFor("frameskip", "0");
			                if(val == -1) {
			                    autoF;
			                } else if (val == 0){
			                    noF;
			                } else if (val == 1){
			                    onF;
		                    } 
			            }
			            
			            onSelectedValueChanged: {
			                _frontend.saveValueFor("frameskip", selectedValue);
			            }
			         
			            // image + text + description
			            Option {
			                id: noF
			                text : "No Frameskip"
			                value : "0"
			            }
			         
			            // text + description
			            Option {
			                id: autoF
			                text : "Auto Frameskip"
			                value : "-1"
			            }
			            Option {
			                id: onF
			                text : "Frameskip Always On"
			                value : "1"
			            }
			        }
			        
			        Divider{}
		        }
			}
	    }
	}
}