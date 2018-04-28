Class {
	#name : #SYMLTopLevelConstant,
	#superclass : #SYMLConstant,
	#instVars : [
		'module'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLTopLevelConstant >> module [
	^ module
]

{ #category : #accessing }
SYMLTopLevelConstant >> module: anObject [
	module := anObject
]
