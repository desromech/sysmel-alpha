Class {
	#name : #MbndAbstractCompilationTarget,
	#superclass : #Object,
	#traits : 'TMbndCoreCompilationTarget',
	#classTraits : 'TMbndCoreCompilationTarget classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #accessing }
MbndAbstractCompilationTarget >> pointerSize [
	self subclassResponsibility
]
