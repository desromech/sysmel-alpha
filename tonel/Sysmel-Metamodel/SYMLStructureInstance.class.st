Class {
	#name : #SYMLStructureInstance,
	#superclass : #SYMLObjectInstance,
	#instVars : [
		'slots'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLStructureInstance >> createSSAInitialValueConstant [
	^ self createSSAInitialValueConstantForModule: type module
]

{ #category : #converting }
SYMLStructureInstance >> createSSAInitialValueConstantForModule: module [
	| constantType constantSlots |
	constantSlots := type slotsLayout collectWithIndex: [ :slot :index |
		slot type generateSSAConstant: (slots at: index) forModule: module
	].

	constantType := self ssaInitialValueType.
	^ SLVMConstant structure: constantType slots: constantSlots
]

{ #category : #'code generation' }
SYMLStructureInstance >> generateSSAReferenceWith: builder [
	^ self createSSAInitialValueConstant
]

{ #category : #'code generation' }
SYMLStructureInstance >> generateSSAValueForModule: aModule [
	^ self createSSAInitialValueConstantForModule: aModule
]

{ #category : #accessing }
SYMLStructureInstance >> slots [
	^ slots
]

{ #category : #accessing }
SYMLStructureInstance >> slots: anObject [
	slots := anObject
]

{ #category : #converting }
SYMLStructureInstance >> ssaInitialValueType [
	^ type ssaType
]
