import bb.cascades 1.0
	
Container {
    id: root
    objectName: "cheatToggle"
    topPadding: 20
    
    property alias cheatText: cheat.text
    property alias cheatDescription: description.text
    property int   cheatNumber
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        Label {
            id: cheat
            verticalAlignment: VerticalAlignment.Center
            preferredWidth: 768
            multiline: true
        }
        
        ToggleButton {
            verticalAlignment: VerticalAlignment.Center
        }
    }
    
    Label {
        id: description
        verticalAlignment: VerticalAlignment.Center
        preferredWidth: 768
        multiline: true
        textStyle {
            base: SystemDefaults.TextStyles.BodyText
            fontStyle: FontStyle.Italic
        } 
    }
    
    Divider {}
}