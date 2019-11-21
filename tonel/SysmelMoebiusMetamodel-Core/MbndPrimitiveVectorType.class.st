Class {
	#name : #MbndPrimitiveVectorType,
	#superclass : #MbndPrimitiveType,
	#instVars : [
		'elementType',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveVectorType class >> typeName [
	^ #_PrimitiveVectorType
]

{ #category : #visiting }
MbndPrimitiveVectorType >> accept: visitor [
	^ visitor visitPrimitiveVectorType: self
]

{ #category : #adding }
MbndPrimitiveVectorType >> addArithmeticOperationCoercionMacro: selector [
	self flag: 'TODO: implement this'
]

{ #category : #initialization }
MbndPrimitiveVectorType >> addInstanceMacros [
	self class == MbndPrimitiveVectorType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].

	self type
		onMacroSelector: #applyWithArguments: do: [ :node :builder :analyzer |
			self assert: node receiver value isPrimitiveVectorType.
			analyzer visitNode: (builder constructVector: node receiver value withElements: node arguments first)
		];
		onMacroSelectors: #(
			x: x:y: x:y:z: x:y:z:w:
			r: r:g: r:g:b: r:g:b:a:
		) do: [ :node :builder :analyzer |
			analyzer visitNode: (
				(builder unexpandedSend: (builder literalSymbol: #applyWithArguments:) to: node receiver withArguments: { 
					(builder tuple: node arguments) position: node
				})
					position: node
			)
		].
]

{ #category : #'as yet unclassified' }
MbndPrimitiveVectorType >> alignmentMultiplier [
	^ elements asLargerPowerOfTwo
]

{ #category : #'default values' }
MbndPrimitiveVectorType >> defaultValueAt: aPosition [
	| defaultElementValue |
	defaultElementValue := elementType defaultValueAt: aPosition.
	^ MbndAggregateTypeInstanceValue new
		type: self;
		slots: ((1 to: elements) collect: [:i | defaultElementValue]);
		yourself
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elementType: anObject [
	elementType := anObject
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elements [
	^ elements
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elements: anObject [
	elements := anObject
]

{ #category : #sizes }
MbndPrimitiveVectorType >> instanceAlignment [
	^ instanceAlignment ifNil: [ instanceAlignment := elementType instanceAlignment * self alignmentMultiplier ]
]

{ #category : #sizes }
MbndPrimitiveVectorType >> instanceSize [
	^ instanceSize ifNil: [ instanceSize := elementType instanceSize * elements ]
]

{ #category : #'testing methods' }
MbndPrimitiveVectorType >> isPrimitiveVectorType [
	^ true
]
