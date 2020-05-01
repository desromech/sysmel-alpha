Class {
	#name : #SysmelBridgeCallState,
	#superclass : #Object,
	#instVars : [
		'serial',
		'semaphore',
		'response'
	],
	#category : #'SysmelTools-Bridge'
}

{ #category : #initialization }
SysmelBridgeCallState >> initialize [
	semaphore := Semaphore new.
]

{ #category : #accessing }
SysmelBridgeCallState >> serial [
	^ serial
]

{ #category : #accessing }
SysmelBridgeCallState >> serial: anObject [
	serial := anObject
]

{ #category : #signalling }
SysmelBridgeCallState >> setResponse: aResponse [
	response := aResponse.
	semaphore signal
]

{ #category : #signalling }
SysmelBridgeCallState >> signalResponse [
	semaphore signal
]

{ #category : #signalling }
SysmelBridgeCallState >> waitResponse [
	semaphore wait.
	^ response
]
