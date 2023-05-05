macroScript BipedKeyKey
	category:"Bomggotge"
	toolTip:"BipedKeyKey"
	icon:#("VCRControls", 17)
(
	fn isCom selection = (return selection.controller as string == "Controller:Body")
	fn isBiped selection = (return classof selection == Biped_Object)

	fn getBipedOriginKey selection SelectedkeyList =
	(
	    local s = selection

	    if isCom(s) then
	    (
			for k = 1 to 3 do
			(
				append SelectedkeyList #()
			)
	        ctrls = #(s.controller.vertical.controller, s.controller.Horizontal.controller, s.controller.Turning.controller)
	        for i = 1 to 3 do
	        (
	            n = numKeys ctrls[i]
	            if n > 0 do
	            (
	                for k = 1 to n do
	                (
	                    if isKeySelected ctrls[i] k do
	                    ( 
	                        append SelectedkeyList[i] (getKeyTime ctrls[i] k)
	                    )
	                )
	            )
	        )
	    ) else (
	        n = numKeys s.controller
	        if n > 0 do
	        (
	            for k = 1 to n do
	            (
	                if isKeySelected s.controller k do
	                ( 
	                    append SelectedkeyList (getKeyTime s.controller k) 
	                )
	            )
	        )
	    )
	)

	fn setBipedOriginKeyToCurrentLayer selection SelectedkeyList =
	(
	    local s = selection

	    if isCom(s) then
	    (
	        for k in SelectedkeyList[1] do
	        (
	            biped.addNewKey s.controller.vertical.controller k
	        )
	        for k in SelectedkeyList[2] do
	        (
	            biped.addNewKey s.controller.horizontal.controller k
	        )
	        for k in SelectedkeyList[3] do
	        (
	            biped.addNewKey s.controller.turning.controller k
	        )
	    ) else (
	        for k in SelectedkeyList do
	        (
	            biped.addNewKey s.controller k
	        )
	    )

	)

	fn main =
	(
	    s = selection[1]
	    SelectedkeyList = #()

	    if not isBiped s do
	    (
	        messagebox "Select Biped"
	        return undefined
	    )

	    disableSceneRedraw()
	    try (
	        currentLayer = biped.getCurrentLayer s.controller
	        if currentLayer != 0 do biped.setCurrentLayer s.controller 0
	        getBipedOriginKey s SelectedkeyList
	        if currentLayer != 0 do biped.setCurrentLayer s.controller currentLayer
	        if SelectedkeyList.count > 0 do setBipedOriginKeyToCurrentLayer s SelectedkeyList
	    ) catch (
	        format "*** % ***\n" (getCurrentException())
	    )
	    enableSceneRedraw()
	)

	main()
)
