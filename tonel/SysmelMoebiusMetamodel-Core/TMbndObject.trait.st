Trait {
	#name : #TMbndObject,
	#category : #'SysmelMoebiusMetamodel-Core-Object'
}

{ #category : #errors }
TMbndObject >> compilerBugError: anErrorString at: aSourcePosition [
	<compileTime>
	^ MbndCompilerBugError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		signal
]

{ #category : #errors }
TMbndObject >> error: anErrorString at: aSourcePosition [
	<compileTime>
	^ MbndCompilationError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		signal
]

{ #category : #errors }
TMbndObject >> error: anErrorString format: formatArguments [
	<compileTime>
	^ self error: (anErrorString format: formatArguments)
]

{ #category : #errors }
TMbndObject >> error: anErrorString format: formatArguments at: aSourcePosition [
	^ self error: (anErrorString format: formatArguments) at: aSourcePosition
]

{ #category : #errors }
TMbndObject >> warning: anErrorString at: aSourcePosition [
	<compileTime>
	^ MbndCompilationWarning new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		signal
]

{ #category : #errors }
TMbndObject >> warning: anErrorString format: formatArguments [
	<compileTime>
	^ self error: (anErrorString format: formatArguments)
]

{ #category : #errors }
TMbndObject >> warning: anErrorString format: formatArguments at: aSourcePosition [
	<compileTime>
	^ self warning: (anErrorString format: formatArguments) at: aSourcePosition
]
