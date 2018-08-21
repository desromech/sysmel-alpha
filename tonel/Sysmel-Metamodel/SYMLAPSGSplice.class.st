Class {
	#name : #SYMLAPSGSplice,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'node'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #testing }
SYMLAPSGSplice >> isSplice [
	^ true
]

{ #category : #accessing }
SYMLAPSGSplice >> node [
	^ node
]

{ #category : #accessing }
SYMLAPSGSplice >> node: anObject [
	node := anObject
]
