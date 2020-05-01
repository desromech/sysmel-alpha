Extension { #name : #Metaclass }

{ #category : #'*SysmelTools-Bridge' }
Metaclass >> encodeForSysmelBridge [
	^ Dictionary newFromPairs: {
		#type . #Metaclass .
		#name . thisClass name
	}
]
