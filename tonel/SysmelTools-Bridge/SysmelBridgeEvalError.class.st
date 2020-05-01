Class {
	#name : #SysmelBridgeEvalError,
	#superclass : #Error,
	#instVars : [
		'sysmelError'
	],
	#category : #'SysmelTools-Bridge'
}

{ #category : #accessing }
SysmelBridgeEvalError >> messageText [
	^ messageText ifNil: [messageText := 'Got Sysmel error on eval: {1}' format: { sysmelError }]
]

{ #category : #accessing }
SysmelBridgeEvalError >> sysmelError [
	^ sysmelError
]

{ #category : #accessing }
SysmelBridgeEvalError >> sysmelError: anObject [
	sysmelError := anObject
]
