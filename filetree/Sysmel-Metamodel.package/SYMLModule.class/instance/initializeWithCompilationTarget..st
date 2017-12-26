initialization
initializeWithCompilationTarget: aCompilationTarget
	compilationTarget := aCompilationTarget.
	currentDirectory := FileSystem workingDirectory.
	globalNamespace := SYMLNamespace new module: self.