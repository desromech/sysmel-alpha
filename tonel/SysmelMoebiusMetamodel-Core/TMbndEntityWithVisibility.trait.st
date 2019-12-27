Trait {
	#name : #TMbndEntityWithVisibility,
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
TMbndEntityWithVisibility >> defaultVisibilityMode [
	^ #public
]

{ #category : #accessing }
TMbndEntityWithVisibility >> external [
	<compileTime>
	self addFlag: #external
]

{ #category : #accessing }
TMbndEntityWithVisibility >> hasExternalVisibility [
	^ self visibilityMode == #external
]

{ #category : #accessing }
TMbndEntityWithVisibility >> hasInternalVisibility [
	^ self visibilityMode == #internal
]

{ #category : #accessing }
TMbndEntityWithVisibility >> hasPrivateVisibility [
	^ self visibilityMode == #private
]

{ #category : #accessing }
TMbndEntityWithVisibility >> hasProtectedVisibility [
	^ self visibilityMode == #protected
]

{ #category : #accessing }
TMbndEntityWithVisibility >> hasPublicOrExternalVisibility [
	^ self hasPublicVisibility or: [self hasExternalVisibility]
]

{ #category : #accessing }
TMbndEntityWithVisibility >> hasPublicVisibility [
	^ self visibilityMode == #public
]

{ #category : #accessing }
TMbndEntityWithVisibility >> private [
	<compileTime>
	self addFlag: #private
]

{ #category : #accessing }
TMbndEntityWithVisibility >> protected [
	<compileTime>
	self addFlag: #protected
]

{ #category : #accessing }
TMbndEntityWithVisibility >> public [
	<compileTime>
	self addFlag: #public
]

{ #category : #accessing }
TMbndEntityWithVisibility >> visibilityMode [
	(self hasFlag: #external) ifTrue: [ ^ #external ].
	(self hasFlag: #public) ifTrue: [ ^ #public ].
	(self hasFlag: #internal) ifTrue: [ ^ #internal ].
	(self hasFlag: #protected) ifTrue: [ ^ #protected ].
	(self hasFlag: #private) ifTrue: [ ^ #private ].
	^ self defaultVisibilityMode
]
