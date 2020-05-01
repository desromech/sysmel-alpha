Extension { #name : #Class }

{ #category : #'*SysmelTools-Bridge' }
Class >> encodeForSysmelBridge [
	^ Dictionary newFromPairs: {
		#type . #Class .
		#name . name
	}
]
