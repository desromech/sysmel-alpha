Class {
	#name : #MbndDummyCompilationTargetTest,
	#superclass : #MbndCompilationTargetTest,
	#category : #'MoebiusBandMetamodel-Core-Tests-CompilationTarget'
}

{ #category : #running }
MbndDummyCompilationTargetTest >> setUp [
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
]
