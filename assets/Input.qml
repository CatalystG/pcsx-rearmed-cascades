import bb.cascades 1.0

Page {   
    titleBar: TitleBar {
        id: titleBar
        title: "Input Settings"
        visibility:  ChromeVisibility.Visible
    }
    
    Container {
	    Container {
	        preferredWidth: 768
	        horizontalAlignment: HorizontalAlignment.Center
	        background: Color.create("#E8E8E8");
	        bottomPadding: 10
	        topPadding: 10
	        
	        
	        SegmentedControl {
	            id: _player
	            Option {
	                id: player1
	                text: "Player 1"
	                selected: true
	            }
	            Option {
	                id: player2
	                text: "Player 2"
	                enabled: false
	            }
	        }
	    }
	    
	    Container{
	        topPadding: 10
	        rightPadding: 20
	        leftPadding: 20
	        
	        
	        Container {
	            Devices {
	                player: _player.selectedIndex
	            }
	        }
	    }
	}
}