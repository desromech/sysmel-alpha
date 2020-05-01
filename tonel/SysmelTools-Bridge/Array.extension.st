Extension { #name : #Array }

{ #category : #'*SysmelTools-Bridge' }
Array >> encodeForSysmelBridge [
	^ self collect: [ :each | each encodeForSysmelBridge ]
]
