Class {
	#name : #SYMLSLVMFunctionGCSysmelLoweringPass,
	#superclass : #SLVMFunctionGCLoweringPass,
	#category : #'Sysmel-Metamodel-GC'
}

{ #category : #'as yet unclassified' }
SYMLSLVMFunctionGCSysmelLoweringPass class >> gcName [
	^ #sysmel
]

{ #category : #applying }
SYMLSLVMFunctionGCSysmelLoweringPass >> passOnFunction: aFunction [
	aFunction isEmpty ifTrue: [ ^ self ].
	
	"Abort if the plugin is not present."
	aFunction compilationTarget compilationPlugins ifEmpty: [ ^ self ].
	
	"Tell llvm to use this gc stragegy"
	aFunction propertyAt: #llvmGCStrategy put: #sysmel
]
