Class {
	#name : #MbndAstPatternMatchingIntervalPatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'start',
		'stop'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingIntervalPatternNode >> accept: visitor [
	^ visitor visitPatternMatchingIntervalPatternNode: self
]

{ #category : #serialization }
MbndAstPatternMatchingIntervalPatternNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#start . start encodeGraphForMessagePackWith: graphEncoder.
		#stop . stop encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstPatternMatchingIntervalPatternNode >> isPatternMatchingIntervalPatternNode [
	^ true
]

{ #category : #testing }
MbndAstPatternMatchingIntervalPatternNode >> isPatternMatchingLiteralValueSetPatternNode [
	^ true
]

{ #category : #serialization }
MbndAstPatternMatchingIntervalPatternNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	start := encodedFields at: #start.
	stop := encodedFields at: #stop.
]

{ #category : #accessing }
MbndAstPatternMatchingIntervalPatternNode >> start [
	^ start
]

{ #category : #accessing }
MbndAstPatternMatchingIntervalPatternNode >> start: anObject [
	start := anObject
]

{ #category : #accessing }
MbndAstPatternMatchingIntervalPatternNode >> stop [
	^ stop
]

{ #category : #accessing }
MbndAstPatternMatchingIntervalPatternNode >> stop: anObject [
	stop := anObject
]
