Extension { #name : #Dictionary }

{ #category : #'*SysmelTools-Bridge' }
Dictionary >> encodeForSysmelBridge [
	^ Dictionary newFromPairs: {
		#type . #Dictionary .
		#value . (self associations collect: [:assoc |
				{ assoc key encodeForSysmelBridge . assoc value encodeForSysmelBridge }])
	}
]
