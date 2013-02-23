import bb.cascades 1.0

Page { 
    property bool helpEnabled: false
    
    titleBar: TitleBar {
        id: titleBar3
        title: "Audio Settings"
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
                text: "Cdda Audio"
                textStyle.base: textStyleBoldTitle.style
            }
            
            ToggleButton {
                id: cdda
                checked: _frontend.getValueFor(objectName, "false")
                objectName: "cdda"
                horizontalAlignment: HorizontalAlignment.Right
                onCheckedChanged: {
                    _frontend.saveValueFor(cdda.objectName, checked)
                }
            }
            
        }
        
        Label {
            id: _help
            text: "Enable CDDA audio if available."
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
                text: "Xa Audio"
                textStyle.base: textStyleBoldTitle.style
            }
            
            ToggleButton {
                id: xa
                checked: _frontend.getValueFor(objectName, "false")
                objectName: "xa"
                horizontalAlignment: HorizontalAlignment.Right
                onCheckedChanged: {
                    _frontend.saveValueFor(xa.objectName, checked)
                }
            }
        }
        
        Label {
            id: _help2
            text: "Enable Xa audio if available."
            multiline: true
            visible: helpEnabled
            textStyle {
                base: SystemDefaults.TextStyles.BodyText
                fontStyle: FontStyle.Italic
            } 
        }
        
        Divider {}
    }
}