Class {
	#name : #MbndVariantTypeInstance,
	#superclass : #MbndAbstractValue,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'type',
		'typeSelector',
		'content'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #accessing }
MbndVariantTypeInstance >> content [
	^ content
]

{ #category : #accessing }
MbndVariantTypeInstance >> content: anObject [
	content := anObject
]

{ #category : #testing }
MbndVariantTypeInstance >> isAllZeros [
	^ typeSelector = 0 and: [ content = 0 or: [content isNil or:
			[ content isMbndAbstractValue and: [ content isAllZeros ] ] ]]
]

{ #category : #accessing }
MbndVariantTypeInstance >> type [
	^ type
]

{ #category : #accessing }
MbndVariantTypeInstance >> type: anObject [
	type := anObject
]

{ #category : #accessing }
MbndVariantTypeInstance >> typeSelector [
	^ typeSelector
]

{ #category : #accessing }
MbndVariantTypeInstance >> typeSelector: anObject [
	typeSelector := anObject
]
