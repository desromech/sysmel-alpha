Class {
	#name : #MbndDummyCompilationTargetTest,
	#superclass : #MbndCompilationTargetTest,
	#category : #'SysmelMoebiusMetamodel-Core-Tests-CompilationTarget'
}

{ #category : #running }
MbndDummyCompilationTargetTest >> setUp [
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
]
