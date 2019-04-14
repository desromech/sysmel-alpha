"
A MbndSmalltalkImageModuleTest is a test class for testing the behavior of MbndSmalltalkImageModule
"
Class {
	#name : #MbndSmalltalkImageModuleTest,
	#superclass : #TestCase,
	#category : #'SysmelMoebiusMetamodel-Core-Tests-Module'
}

{ #category : #running }
MbndSmalltalkImageModuleTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	MbndSmalltalkImageModule setUpCleanForTest
]

{ #category : #running }
MbndSmalltalkImageModuleTest >> tearDown [
	"Hooks that subclasses may override to define the fixture of test."
	MbndSmalltalkImageModule tearDownCleanForTest
]

{ #category : #tests }
MbndSmalltalkImageModuleTest >> testCompilationTarget [
	self assert: Smalltalk moebiusBandModule compilationTarget isNotNil.
]

{ #category : #tests }
MbndSmalltalkImageModuleTest >> testMoebiusBandModule [
	self assert: Smalltalk moebiusBandModule isNotNil
]

{ #category : #tests }
MbndSmalltalkImageModuleTest >> testObjectType [
	self assert: Object asMoebiusType isNotNil.
	self assert: Object asMoebiusType type equals: Object class asMoebiusType.
	self assert: Object asMoebiusType supertype equals: ProtoObject asMoebiusType.
]
