Class {
	#name : #MbndAbstractConcreteCompilationTarget,
	#superclass : #Object,
	#traits : 'TMbndCoreCompilationTarget',
	#classTraits : 'TMbndCoreCompilationTarget classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerAlignment [
	self subclassResponsibility
]

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerSize [
	self subclassResponsibility
]
