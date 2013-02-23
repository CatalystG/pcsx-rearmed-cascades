import bb.cascades 1.0

Container {
    property int player  
    
    DropDown {
        id: _device
        title: "Input Device"
        
        Option {
            id: _disabled
            text: "Disabled"
            selected: _frontend.getControllerValue(player, -1) == 0
        }
        Option {
            text: "Touchscreen"
            selected: _frontend.getControllerValue(player, -1) == 1
        }
        Option {
            text: "Keyboard"
            selected: _frontend.getControllerValue(player, -1) == 2
        }
        Option {
            text: "GamePad (TODO)"
            selected: false
        }
        
        onSelectedIndexChanged: {
            _frontend.setControllerValue(player, -1, selectedIndex);
        }
    }
    
    Divider {}
	
	//Touchscreen
	Container {
	    id:_touch
	    visible: _device.selectedIndex == 1
	    
	    Container {
            horizontalAlignment: HorizontalAlignment.Center
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
        
            Label {
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Center
                preferredWidth: 768
                text: "Analog Pad"
                textStyle.base: textStyleBoldTitle.style
            }
            
            ToggleButton {
                id: analog_enabled
                checked: _frontend.getValueFor(objectName, "false")
                objectName: "analog_enabled"
                horizontalAlignment: HorizontalAlignment.Right
                onCheckedChanged: {
                    _frontend.saveValueFor(analog_enabled.objectName, checked)
                }
            }
        }
	}
	
	//keyboard
	ScrollView {
        visible: _device.selectedIndex == 2
		Container {
		    id:_keyboard
		    
		    leftPadding: 20
		    rightPadding: 20
		    
		    ButtonMap { 
		        button: "Select"
		        button_id: 0
		    }
		    ButtonMap { 
		        button: "L3"
		        button_id: 1
		    }
		    ButtonMap { 
		        button: "R3"
		        button_id: 2
		    }
		    ButtonMap { 
		        button: "Start"
		        button_id: 3
		    }
		    ButtonMap { 
		        button: "Dpad Up"
		        button_id: 4
		    }
		    ButtonMap { 
		        button: "Dpad Right"
		        button_id: 5
		    }
		    ButtonMap { 
		        button: "Dpad Down"
		        button_id: 6
		    }
		    ButtonMap { 
		        button: "Dpad Left"
		        button_id: 7
		    }
		    ButtonMap { 
		        button: "L2"
		        button_id: 8
		    }
		    ButtonMap { 
		        button: "R2"
		        button_id: 9
		    }
		    ButtonMap { 
		        button: "L1"
		        button_id: 10
		    }
		    ButtonMap { 
		        button: "R1"
		        button_id: 11
		    }
		    ButtonMap { 
		        button: "Triangle"
		        button_id: 12
		    }
		    ButtonMap { 
		        button: "Circle"
		        button_id: 13
		    }
		    ButtonMap { 
		        button: "Square"
		        button_id: 14
		    }
		    ButtonMap { 
		        button: "Cross"
		        button_id: 15
		    }
		}
    }
	
	//gamepad
	Container {
	    id:_gamepad
	    
	    visible: _device.selectedIndex == 3
	    Label {
	         text: "GamePad to be added"   
	    }
	}
}