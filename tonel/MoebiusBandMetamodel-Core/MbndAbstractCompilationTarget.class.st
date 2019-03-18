Class {
	#name : #MbndAbstractCompilationTarget,
	#superclass : #Object,
	#traits : 'TMbndCoreCompilationTarget',
	#classTraits : 'TMbndCoreCompilationTarget classTrait',
	#category : #'MoebiusBandMetamodel-Core-CompilationTarget'
}

{ #category : #accessing }
MbndAbstractCompilationTarget >> pointerSize [
	self subclassResponsibility
]
