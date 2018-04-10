Class {
	#name : #SYMLStructure,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'fields'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #adding }
SYMLStructure >> addFieldVariable: field at: aPosition [
	symbols at: field name ifPresent: [ :existent |
		self error: 'Field {1} overrides an existent field.' format: { field name } at: aPosition
	] ifAbsentPut: [ field ].
	fields add: field
]

{ #category : #definition }
SYMLStructure >> definitionScopeClass [
	^ SYMLStructureScope
]

{ #category : #initialization }
SYMLStructure >> initialize [
	super initialize.
	fields := OrderedCollection new.
	
]

{ #category : #printing }
SYMLStructure >> printOn: aStream [
	aStream nextPutAll: 'structure '; nextPutAll: self validName
]
