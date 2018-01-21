converting
evaluateInEnvironment: anEnvironment
	^ (SYMLScapedLanguageCompiler compilerForLanguage: language) evaluateNode: self inEnvironment: anEnvironment