Class {
	#name : #SYMLBooleanConstant,
	#superclass : #SYMLConstant,
	#instVars : [
		'module'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLBooleanConstant >> module [
	^ module
]

{ #category : #accessing }
SYMLBooleanConstant >> module: anObject [
	module := anObject
]
