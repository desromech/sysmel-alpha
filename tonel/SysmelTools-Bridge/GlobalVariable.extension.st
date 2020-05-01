Extension { #name : #GlobalVariable }

{ #category : #'*SysmelTools-Bridge' }
GlobalVariable >> encodeForSysmelBridge [
	^ Dictionary newFromPairs: {
		#type . #GlobalVariable .
		#key . key.
	}
]
