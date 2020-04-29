Class {
	#name : #MbndAbstractConcreteCompilationTarget,
	#superclass : #Object,
	#traits : 'TMbndCoreCompilationTarget',
	#classTraits : 'TMbndCoreCompilationTarget classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'instance creation' }
MbndAbstractConcreteCompilationTarget class >> for: aCompilationTarget [
	^ self basicNew initializeWithCompilationTarget: aCompilationTarget
]

{ #category : #serialization }
MbndAbstractConcreteCompilationTarget class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	self assert: objectType = #CompilationTarget.
	graphDecoder registerObjectInstance: graphDecoder compilationTarget.
	graphDecoder decodeNext.
	^ graphDecoder compilationTarget
]

{ #category : #'derived types' }
MbndAbstractConcreteCompilationTarget >> blockClosureTypeWithArguments: argumentTypes returnType: returnType [
	^ (self functionTypeWithArguments: argumentTypes returnType: returnType) asGCBlockClosureType
]

{ #category : #'convenience type accessors' }
MbndAbstractConcreteCompilationTarget >> patternMatchingPatternType [
	^ self getBasicTypeNamed: MbndPatternMatchingPatternType typeName
]

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerAlignment [
	self subclassResponsibility
]

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerSize [
	self subclassResponsibility
]
