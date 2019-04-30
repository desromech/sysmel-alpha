Class {
	#name : #MbndInImageCompilationTarget,
	#superclass : #MbndSlovimCompilationTarget,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #accessing }
MbndInImageCompilationTarget >> float64Alignment [
	^ Smalltalk platform ffiFloat64Alignment
]

{ #category : #initialization }
MbndInImageCompilationTarget >> initialize [
	self slvmCompilationTarget: SLVMCompilationTarget forCurrentImage.
	super initialize.
]

{ #category : #accessing }
MbndInImageCompilationTarget >> int64Alignment [
	^ Smalltalk platform ffiInt64Alignment
]
