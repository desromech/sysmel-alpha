initialization
initializeWithCompilationTarget: aCompilationTarget
	compilationTarget := aCompilationTarget.
	currentDirectory := FileSystem workingDirectory.
	globalNamespace := SYMLNamespace new name: #__global; module: self.