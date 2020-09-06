Class {
	#name : #MbndRGEnvironmentBackend,
	#superclass : #RGEnvironmentBackend,
	#instVars : [
		'compilationEnvironment',
		'targetModule',
		'loadingEnvironment',
		'addedClasses'
	],
	#category : #'SysmelCalypso-RingBackend'
}

{ #category : #environment }
MbndRGEnvironmentBackend >> addBehavior: anRGBehavior to: anRGEnvironment [
	loadingEnvironment ifFalse: [
		addedClasses add: anRGBehavior.
	].
	 ^ super addBehavior: anRGBehavior to: anRGEnvironment
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> compilationEnvironment [
	^ compilationEnvironment
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> compilationEnvironment: anObject [
	compilationEnvironment := anObject
]

{ #category : #initialization }
MbndRGEnvironmentBackend >> initialize [
	super initialize.
	addedClasses := OrderedCollection new.
	
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> loadingEnvironment [
	^ loadingEnvironment
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> loadingEnvironment: anObject [
	loadingEnvironment := anObject
]

{ #category : #environment }
MbndRGEnvironmentBackend >> notSupportedOperation [
	self error: 'Unsupported operation'
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> targetModule [
	^ targetModule
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> targetModule: anObject [
	targetModule := anObject
]
