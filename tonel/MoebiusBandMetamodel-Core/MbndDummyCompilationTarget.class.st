Class {
	#name : #MbndDummyCompilationTarget,
	#superclass : #MbndAbstractCompilationTarget,
	#category : #'MoebiusBandMetamodel-Core-CompilationTarget'
}

{ #category : #accessing }
MbndDummyCompilationTarget >> float64Alignment [
	^ 8
]

{ #category : #initialization }
MbndDummyCompilationTarget >> initialize [
	super initialize.
	self initializeTypeSystem
]

{ #category : #accessing }
MbndDummyCompilationTarget >> int64Alignment [
	^ 8
]

{ #category : #accessing }
MbndDummyCompilationTarget >> pointerSize [
	^ 4
]
