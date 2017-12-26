accessing
inspectorChildren
	^ { selector .
		receiver .
		#arguments -> arguments .
	}