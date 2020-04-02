Class {
	#name : #MbndMatrixTypeInstanceValue,
	#superclass : #MbndTensorTypeInstanceValue,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #arithmetic }
MbndMatrixTypeInstanceValue >> %% other [
	^ self elementWiseApply: #% to: other
]

{ #category : #arithmetic }
MbndMatrixTypeInstanceValue >> %/ other [
	^ self elementWiseApply: #/ to: other
]

{ #category : #arithmetic }
MbndMatrixTypeInstanceValue >> %// other [
	^ self elementWiseApply: #// to: other
]

{ #category : #arithmetic }
MbndMatrixTypeInstanceValue >> %\\ other [
	^ self elementWiseApply: #\\ to: other
]

{ #category : #arithmetic }
MbndMatrixTypeInstanceValue >> elementWiseApply: selector [
	^ self class new
		type: type;
		slots: (slots collect: [:each | each perform: selector ]);
		yourself

]

{ #category : #arithmetic }
MbndMatrixTypeInstanceValue >> elementWiseApply: selector to: other [
	| otherSlots |
	self assert: other isMatrixTypeInstanceValue.
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
MbndMatrixTypeInstanceValue >> isMatrixTypeInstanceValue [
	^ false
]
