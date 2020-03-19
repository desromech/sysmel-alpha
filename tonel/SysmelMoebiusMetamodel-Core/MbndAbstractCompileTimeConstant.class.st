Class {
	#name : #MbndAbstractCompileTimeConstant,
	#superclass : #Object,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'as yet unclassified' }
MbndAbstractCompileTimeConstant class >> messagePackTypeName [
	^ nil
]

{ #category : #'as yet unclassified' }
MbndAbstractCompileTimeConstant >> messagePackTypeName [
	^ self class messagePackTypeName
]
