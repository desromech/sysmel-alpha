Class {
	#name : #MbndAbstractManagedObjectModel,
	#superclass : #Object,
	#traits : 'TMbndCoreManagedObjectModel',
	#classTraits : 'TMbndCoreManagedObjectModel classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'instance creation' }
MbndAbstractManagedObjectModel class >> for: aCompilationTarget [
	^ self basicNew initializeWithCompilationTarget: aCompilationTarget
]

{ #category : #initialization }
MbndAbstractManagedObjectModel >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget
]
