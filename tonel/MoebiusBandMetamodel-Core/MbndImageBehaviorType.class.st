Class {
	#name : #MbndImageBehaviorType,
	#superclass : #Object,
	#traits : 'TMbndType',
	#classTraits : 'TMbndType classTrait',
	#instVars : [
		'behavior'
	],
	#category : #'MoebiusBandMetamodel-Core-In-Image'
}

{ #category : #accessing }
MbndImageBehaviorType >> behavior [
	^ behavior
]

{ #category : #accessing }
MbndImageBehaviorType >> behavior: aBehavior [
	behavior := aBehavior
]

{ #category : #'type hierarchy' }
MbndImageBehaviorType >> supertype [
	^ behavior superclass ifNotNil: [ :st | st asMoebiusType ]
]

{ #category : #'type hierarchy' }
MbndImageBehaviorType >> type [
	^ behavior class ifNotNil: [ :st | st asMoebiusType ]
]
