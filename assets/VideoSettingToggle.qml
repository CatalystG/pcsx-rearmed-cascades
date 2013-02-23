import bb.cascades 1.0

Container {
    id: root
    property alias help: help.text
    property string settingName
    property alias title: title.text
    property alias settingEnabled: toggle.checked
    property alias showHelp: help.visible 
    property string defaultValue
    property alias checked: toggle.checked
    
    bottomPadding: 20
    
    function setDefault(){
        toggle.checked = defaultValue == "true";
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        Label {
            id: title
            preferredWidth: 768
            verticalAlignment: VerticalAlignment.Center
        }
        
        ToggleButton {
            id: toggle
            checked: _frontend.getValueFor(settingName, defaultValue) == "true";
            
            onCheckedChanged: {
                if(checked)
                    _frontend.saveValueFor(settingName, "true");
                else
                    _frontend.saveValueFor(settingName, "false");
            }
        }
    }
    
    Label {
        id: help
        textStyle {
            base: SystemDefaults.TextStyles.BodyText
            fontStyle: FontStyle.Italic
        } 
    }
    
    Divider{}
}