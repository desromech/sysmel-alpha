Class {
	#name : #MbndMatrixTypeInstanceValue,
	#superclass : #MbndTensorTypeInstanceValue,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #serialization }
MbndMatrixTypeInstanceValue class >> messagePackTypeName [
	^ #MatrixTypeInstanceValue
]

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

{ #category : #accessing }
MbndMatrixTypeInstanceValue >> transpose [
	| resultType result resultColumnType |
	resultType := self type transpose.
	resultColumnType := resultType columnType.
	result := self class new
		type: resultType;
		slots: ((1 to: resultType columns) collect: [ :columnIndex |
			| resultColumn |
			resultColumn := resultColumnType defaultValue.
			(1 to: resultType rows) do: [ :rowIndex |
				resultColumn slots at: rowIndex put: ((slots at: rowIndex) slots at: columnIndex)
			].
			resultColumn
		]);
		yourself.
	^ result
]
