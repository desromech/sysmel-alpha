Class {
	#name : #MbndTensorTypeInstanceValue,
	#superclass : #MbndAggregateTypeInstanceValue,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #serialization }
MbndTensorTypeInstanceValue class >> messagePackTypeName [
	^ #TensorTypeInstanceValue
]

{ #category : #arithmetic }
MbndTensorTypeInstanceValue >> + other [
	^ self elementWiseApply: #+ to: other
]

{ #category : #arithmetic }
MbndTensorTypeInstanceValue >> - other [
	^ self elementWiseApply: #- to: other
]

{ #category : #accessing }
MbndTensorTypeInstanceValue >> abs [
	^ self elementWiseApply: #abs
]

{ #category : #arithmetic }
MbndTensorTypeInstanceValue >> elementWiseApply: selector [
	^ self class new
		type: type;
		slots: (slots collect: [:each | each perform: selector ]);
		yourself

]

{ #category : #arithmetic }
MbndTensorTypeInstanceValue >> elementWiseApply: selector to: other [
	self subclassResponsibility
]

{ #category : #accessing }
MbndTensorTypeInstanceValue >> max: other [
	^ self elementWiseApply: #max: to: other
]

{ #category : #accessing }
MbndTensorTypeInstanceValue >> min: other [
	^ self elementWiseApply: #min: to: other
]

{ #category : #accessing }
MbndTensorTypeInstanceValue >> negated [
	^ self elementWiseApply: #negated
]

{ #category : #testing }
MbndTensorTypeInstanceValue >> sign [
	^ self elementWiseApply: #sign
]
