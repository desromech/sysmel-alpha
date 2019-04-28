Class {
	#name : #MbndWorkingDirectoryScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'workingDirectory'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #accessing }
MbndWorkingDirectoryScope >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
MbndWorkingDirectoryScope >> workingDirectory: anObject [
	workingDirectory := anObject
]
