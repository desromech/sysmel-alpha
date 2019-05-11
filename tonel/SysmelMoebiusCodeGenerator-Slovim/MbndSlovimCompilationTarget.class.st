Class {
	#name : #MbndSlovimCompilationTarget,
	#superclass : #MbndAbstractConcreteCompilationTarget,
	#instVars : [
		'slvmCompilationTarget'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> llvm_x86 [
	^ self slvmCompilationTarget: SLVMLLVMCompilationTarget x86
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> llvm_x86_64 [
	^ self slvmCompilationTarget: SLVMLLVMCompilationTarget x86_64
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> slvmCompilationTarget: slvmTarget [
	^ self basicNew
		slvmCompilationTarget: slvmTarget;
		yourself
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> float64Alignment [
	^ slvmCompilationTarget float64 alignment
]

{ #category : #initialization }
MbndSlovimCompilationTarget >> initialize [
	super initialize.
	self initializeTypeSystem.
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> int64Alignment [
	^ slvmCompilationTarget int64 alignment
]

{ #category : #'instance creation' }
MbndSlovimCompilationTarget >> newCodeModuleGenerator [
	^ MbndSlovimCodeModuleGenerator new
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> pointerSize [
	^ slvmCompilationTarget pointerSize
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTarget [
	^ slvmCompilationTarget
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTarget: anObject [
	slvmCompilationTarget := anObject
]
