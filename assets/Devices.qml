import bb.cascades 1.0

Container {
    property int player  
    
    DropDown {
        id: _device
        title: "Input Device"
        
        Option {
            id: _disabled
            text: "Disabled"
            selected: _frontend.getControllerValue(player, -1, 0) == 0
        }
        Option {
            text: "Touchscreen"
            selected: _frontend.getControllerValue(player, -1, 0) == 1
        }
        Option {
            text: "Keyboard"
            selected: _frontend.getControllerValue(player, -1, 0) == 2
        }
        Option {
            text: "GamePad"
            selected: _frontend.getControllerValue(player, -1, 0) == 3
        }
        
        onSelectedIndexChanged: {
            _frontend.setControllerValue(player, -1, selectedIndex, selectedIndex);
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
	
	//keyboard + gamepad
	ScrollView {
        visible: _device.selectedIndex == 2
		Container {
		    id:_keyboard
		    
		    leftPadding: 20
		    rightPadding: 20
		    
		    ButtonMap { 
		        button: "Select"
		        button_id: 0
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "L3"
		        button_id: 1
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "R3"
		        button_id: 2
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Start"
		        button_id: 3
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Dpad Up"
		        button_id: 4
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Dpad Right"
		        button_id: 5
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Dpad Down"
		        button_id: 6
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Dpad Left"
		        button_id: 7
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "L2"
		        button_id: 8
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "R2"
		        button_id: 9
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "L1"
		        button_id: 10
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "R1"
		        button_id: 11
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Triangle"
		        button_id: 12
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Circle"
		        button_id: 13
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Cross"
		        button_id: 14
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Square"
		        button_id: 15
		        device: _device.selectedIndex
		        player: player
		    }
		}
    }
    
    ScrollView {
        visible: _device.selectedIndex == 3
		Container {
		    id:_gamepad
		    
		    leftPadding: 20
		    rightPadding: 20
		    
		    ButtonMap { 
		        button: "Select"
		        button_id: 0
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "L3"
		        button_id: 1
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "R3"
		        button_id: 2
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Start"
		        button_id: 3
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Dpad Up"
		        button_id: 4
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Dpad Right"
		        button_id: 5
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Dpad Down"
		        button_id: 6
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Dpad Left"
		        button_id: 7
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "L2"
		        button_id: 8
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "R2"
		        button_id: 9
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "L1"
		        button_id: 10
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "R1"
		        button_id: 11
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Triangle"
		        button_id: 12
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Circle"
		        button_id: 13
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Cross"
		        button_id: 14
		        device: _device.selectedIndex
		        player: player
		    }
		    ButtonMap { 
		        button: "Square"
		        button_id: 15
		        device: _device.selectedIndex
		        player: player
		    }
		}
    }
	
}