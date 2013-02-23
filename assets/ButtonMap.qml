import bb.cascades 1.0

Container {
    property alias button: _button.text
    property int button_id
    
    bottomPadding: 20
    
    Container {
        
	    layout: StackLayout {
	        orientation: LayoutOrientation.LeftToRight
	    }
	    
	    Label {
	        horizontalAlignment: HorizontalAlignment.Left
	        verticalAlignment: VerticalAlignment.Center
	        preferredWidth: 768
	        id: _button
	    }
	    
	    Button {
	        id: _mapping
	        horizontalAlignment: HorizontalAlignment.Right
	        verticalAlignment: VerticalAlignment.Center
	        minWidth: 200
	        text: _frontend.getControllerValue(player, button_id).toString()
	        
	        onClicked: {
	            var mapButton = _frontend.mapButton();
	            if(mapButton != -1){
	                _frontend.setControllerValue(player, button_id, mapButton);
	                _mapping.text = mapButton.toString();
	            }
	        }
	    }
	}
    
    Divider {}
    
}