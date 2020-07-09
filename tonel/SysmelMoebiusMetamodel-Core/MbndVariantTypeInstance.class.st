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

{ #category : #serialization }
MbndVariantTypeInstance class >> messagePackTypeName [
	^ #VariantTypeInstance
]

{ #category : #converting }
MbndVariantTypeInstance >> asLiteralValueNode [
	<compileTime>
	<returnType: #_ASTNodeType>
	^ MbndAstLiteralValueNode new
		value: self;
		type: (type isPOD ifTrue: [ type ] ifFalse: [ type const ref]);
		yourself
]

{ #category : #accessing }
MbndVariantTypeInstance >> content [
	^ content
]

{ #category : #accessing }
MbndVariantTypeInstance >> content: anObject [
	content := anObject
]

{ #category : #serialization }
MbndVariantTypeInstance >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#type . type encodeGraphForMessagePackWith: graphEncoder.
		#typeSelector . typeSelector encodeGraphForMessagePackWith: graphEncoder.
		#content . content encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #testing }
MbndVariantTypeInstance >> isAllZeros [
	^ typeSelector = 0 and: [ content = 0 or: [content isNil or:
			[ content isMbndAbstractValue and: [ content isAllZeros ] ] ]]
]

{ #category : #serialization }
MbndVariantTypeInstance >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	type := encodedFields at: #type.
	typeSelector := encodedFields at: #typeSelector.
	content := encodedFields at: #content.
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
