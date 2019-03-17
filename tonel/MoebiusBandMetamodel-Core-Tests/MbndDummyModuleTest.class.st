"
A MbndDummyModuleTest is a test class for testing the behavior of MbndDummyModule
"
Class {
	#name : #MbndDummyModuleTest,
	#superclass : #TestCase,
	#instVars : [
		'module'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-Module'
}

{ #category : #running }
MbndDummyModuleTest >> setUp [
	module := MbndDummyModule new
]

{ #category : #running }
MbndDummyModuleTest >> testCompilationTarget [
	self assert: module compilationTarget isNotNil
]
