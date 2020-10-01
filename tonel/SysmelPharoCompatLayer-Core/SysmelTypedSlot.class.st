Class {
	#name : #SysmelTypedSlot,
	#superclass : #InstanceVariableSlot,
	#instVars : [
		'type'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'instance creation' }
SysmelTypedSlot class >> named: aSymbol for: aType [
	^ (self named: aSymbol)
		type: aType;
		yourself
]

{ #category : #printing }
SysmelTypedSlot >> definitionString [
	^ self printString
]

{ #category : #'code generation' }
SysmelTypedSlot >> emitStore: methodBuilder [
	"Emit an implicit cast to during each store."
	type isBehavior ifTrue: [
		methodBuilder pushLiteralVariable: type binding
	] ifFalse: [ 
		methodBuilder pushLiteral: type binding
	].
	methodBuilder send: #implicitCastTo:.
	^ super emitStore: methodBuilder
]

{ #category : #testing }
SysmelTypedSlot >> isSysmelTypedSlot [
	^ true
]

{ #category : #printing }
SysmelTypedSlot >> printOn: aStream [
	"Every subclass that adds state must redefine either this method or #definitionString"
	aStream 
		store: self name;
		nextPutAll: ' => ';
		print: type
]

{ #category : #accessing }
SysmelTypedSlot >> type [
	^ type
]

{ #category : #accessing }
SysmelTypedSlot >> type: anObject [
	type := anObject
]
