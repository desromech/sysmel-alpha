as yet unclassified
forCurrentImage
	^ CurrentImageCompilationTarget ifNil: [ CurrentImageCompilationTarget := SYMLSLVMCompilationTarget for: SLVMCompilationTarget forCurrentImage ]