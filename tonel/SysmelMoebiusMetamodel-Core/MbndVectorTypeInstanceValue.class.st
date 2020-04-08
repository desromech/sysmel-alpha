Class {
	#name : #MbndVectorTypeInstanceValue,
	#superclass : #MbndTensorTypeInstanceValue,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #serialization }
MbndVectorTypeInstanceValue class >> messagePackTypeName [
	^ #VectorTypeInstanceValue
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> % other [
	^ self elementWiseApply: #% to: other
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> * other [
	^ self elementWiseApply: #* to: other
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> / other [
	^ self elementWiseApply: #/ to: other
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> // other [
	^ self elementWiseApply: #// to: other
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> \\ other [
	^ self elementWiseApply: #\\ to: other
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> dot: other [
	^ (self privateDot: other) asMoebiusValueWithType: type elementType
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> elementWiseApply: selector to: other [
	| otherSlots |
	self assert: other isVectorTypeInstanceValue.
	self assert: other slots size = slots size.
	otherSlots := other slots.
	^ self class new
		type: type;
		slots: (slots collectWithIndex: [:left :index |
			left perform: selector with: (otherSlots at: index)
		]);
		yourself

]

{ #category : #testing }
MbndVectorTypeInstanceValue >> isVectorTypeInstanceValue [
	^ true
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> length [
	^ (self privateDot: self) sqrt asMoebiusValueWithType: type elementType
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> length2 [
	^ (self privateDot: self) asMoebiusValueWithType: type elementType
]

{ #category : #arithmetic }
MbndVectorTypeInstanceValue >> privateDot: other [
	| otherSlots result |
	self assert: other isVectorTypeInstanceValue.
	self assert: other slots size = slots size.
	otherSlots := other slots.
	result := 0.
	
	(slots doWithIndex: [:left :index |
		result := result + (left * otherSlots at: index)
	]).

	^ result
]
