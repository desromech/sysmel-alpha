Class {
	#name : #SYMLFieldAccessor,
	#superclass : #SYMLMacro,
	#instVars : [
		'field'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #converting }
SYMLFieldAccessor >> asCompiledMethod [
	^ nil
]

{ #category : #accessing }
SYMLFieldAccessor >> field [
	^ field
]

{ #category : #accessing }
SYMLFieldAccessor >> field: anObject [
	field := anObject
]
