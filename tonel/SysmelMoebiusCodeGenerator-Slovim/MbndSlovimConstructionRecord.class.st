Class {
	#name : #MbndSlovimConstructionRecord,
	#superclass : #Object,
	#instVars : [
		'priority',
		'constructor',
		'destructor'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Utility'
}

{ #category : #accessing }
MbndSlovimConstructionRecord >> constructor [
	^ constructor
]

{ #category : #accessing }
MbndSlovimConstructionRecord >> constructor: anObject [
	constructor := anObject
]

{ #category : #accessing }
MbndSlovimConstructionRecord >> destructor [
	^ destructor
]

{ #category : #accessing }
MbndSlovimConstructionRecord >> destructor: anObject [
	destructor := anObject
]

{ #category : #accessing }
MbndSlovimConstructionRecord >> priority [
	^ priority
]

{ #category : #accessing }
MbndSlovimConstructionRecord >> priority: anObject [
	priority := anObject
]
