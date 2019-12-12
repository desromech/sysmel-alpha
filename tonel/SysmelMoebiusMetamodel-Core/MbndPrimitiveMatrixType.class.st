Class {
	#name : #MbndPrimitiveMatrixType,
	#superclass : #MbndPrimitiveType,
	#instVars : [
		'elementType',
		'rows',
		'columns',
		'columnType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveMatrixType class >> typeName [
	^ #_PrimitiveMatrixType
]

{ #category : #visiting }
MbndPrimitiveMatrixType >> accept: visitor [
	^ visitor visitPrimitiveMatrixType: self
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> addArithmeticIntrinsics [
	elementType addArithmeticIntrinsicsToMatrixType: self
	
]

{ #category : #adding }
MbndPrimitiveMatrixType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	elementType ifNotNil: [ 
		elementType
			addConversionTo: self rule: MbndExpandScalarToMatrixConversionRule.
	]
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> addInstanceMacros [
	self class == MbndPrimitiveMatrixType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	#(firstColumn secondColumn thirdColumn fourthColumn
	) doWithIndex: [ :fieldName :fieldIndex |
		self addMatrixElementField: (fieldIndex - 1) withName: fieldName
	].

	#(firstRow secondRow thirdRow fourthRow
	) doWithIndex: [ :fieldName :fieldIndex |
		self addMatrixRowAccessor: (fieldIndex - 1) withName: fieldName
	].

	self type
		onMacroSelector: #identity do: [ :node :builder |
			self assert: node receiver value isPrimitiveMatrixType.
			node receiver value expandIdentityMatrixConstruction: node with: builder.
		];
		onMacroSelector: #zeros do: [ :node :builder |
			self assert: node receiver value isPrimitiveMatrixType.
			node receiver value expandZerosMatrixConstruction: node with: builder.
		];
		onMacroSelector: #ones do: [ :node :builder |
			self assert: node receiver value isPrimitiveMatrixType.
			node receiver value expandOnesMatrixConstruction: node with: builder.
		];
		onMacroSelector: #rowMajorIndices do: [ :node :builder |
			self assert: node receiver value isPrimitiveMatrixType.
			node receiver value expandConstantMatrixConstruction: node with: builder valuesComputedWith: [ :r :c :i :j |
				j*c + i
			].
		];
		onMacroSelector: #columnMajorIndices do: [ :node :builder |
			self assert: node receiver value isPrimitiveMatrixType.
			node receiver value expandConstantMatrixConstruction: node with: builder valuesComputedWith: [ :r :c :i :j |
				i*r + j
			].
		];
		onMacroSelector: #applyWithArguments: do: [ :node :builder :analyzer |
			self assert: node receiver value isPrimitiveMatrixType.
			node receiver value analyzeMatrixConstructionNode: node with: analyzer.
		]
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> addMatrixElementField: fieldIndex withName: fieldName [
	| getterName setterName |
	getterName := fieldName.
	setterName := (fieldName , ':') asSymbol.
	
	self onMacroSelector: getterName do: [ :node :builder |
		(builder matrix: node receiver getColumn: (builder literalInteger: fieldIndex))
			position: node
	].
	self onMacroSelector: setterName do: [ :node :builder |
		(builder matrix: node receiver setColumn: (builder literalInteger: fieldIndex) value: node arguments first)
			position: node
	]
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> addMatrixRowAccessor: fieldIndex withName: fieldName [
	| getterName setterName |
	getterName := fieldName.
	setterName := (fieldName , ':') asSymbol.
	
	self onMacroSelector: getterName do: [ :node :builder |
		(builder matrix: node receiver getRow: (builder literalInteger: fieldIndex))
			position: node
	].
	self onMacroSelector: setterName do: [ :node :builder |
		(builder matrix: node receiver setRow: (builder literalInteger: fieldIndex) value: node arguments first)
			position: node
	]
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> analyzeMatrixConstructionNode: node with: analyzer [
	| builder splicedTuple |
	builder := analyzer astBuilder.
	splicedTuple := analyzer visitSplicingTupleNode: node arguments first.
	splicedTuple size = 1 ifTrue: [ 
		"The diagonal is set to the element. This case is equivalent to expanding a scalar into a matrix."
		^ analyzer visitNode: (builder expandScalar: splicedTuple first toMatrixType: self)
	].

	splicedTuple size = (rows * columns) ifTrue: [
		^ analyzer visitNode: (builder constructMatrix: self
			withColumns: ((0 to: columns - 1) collect: [ :columnIndex |
				builder constructVector: self columnType withElements: ((0 to: rows - 1) collect: [ :rowIndex |
					| elementIndex |
					elementIndex := (rowIndex *columns) + columnIndex.
					splicedTuple at: elementIndex + 1
				])
			]))
	].

	"The columns are specified explicitly."
	^ analyzer visitNode: (builder constructMatrix: self withColumns: splicedTuple)

]

{ #category : #accessing }
MbndPrimitiveMatrixType >> columnType [
	<compileTime>
	^ columnType ifNil: [columnType := elementType primitiveVectorWithElements: rows]
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> columns [
	^ columns
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> columns: anObject [
	columns := anObject
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> elementType: anObject [
	elementType := anObject
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> expandAllConstant: constantValue matrixConstruction: node with: builder [
	| constantValueNode column |
	constantValueNode := constantValue asLiteralValueNode position: node.
	column := (builder constructVector: self columnType withElements: ((1 to: rows) collect: [ :i | constantValueNode ]))
		position: node.
	^ (builder constructMatrix: self withColumns: ((1 to: columns) collect: [ :i | column ]))
		position: node
	
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> expandConstantMatrixConstruction: node with: builder valuesComputedWith: valueComputationBlock [
	^ (builder constructMatrix: self withColumns: ((0 to: columns - 1) collect: [ :i |
			(builder constructVector: self columnType withElements: ((0 to: rows - 1) collect: [ :j |
				| constantValue |
				constantValue := valueComputationBlock value: rows value: columns value: i value value: j.
				(constantValue asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
					position: node
			]))
			position: node.
		]))
		position: node
	
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> expandIdentityMatrixConstruction: node with: builder [
	^ builder expandScalar: (elementType oneConstantValue asLiteralValueNode position: node) toMatrixType: self
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> expandOnesMatrixConstruction: node with: builder [
	^ self expandAllConstant: elementType oneConstantValue matrixConstruction: node with: builder
]

{ #category : #initialization }
MbndPrimitiveMatrixType >> expandZerosMatrixConstruction: node with: builder [
	^ self expandAllConstant: elementType zeroConstantValue matrixConstruction: node with: builder
]

{ #category : #sizes }
MbndPrimitiveMatrixType >> instanceAlignment [
	<compileTime>
	^ instanceAlignment ifNil: [ instanceAlignment := self columnType instanceAlignment ]
]

{ #category : #sizes }
MbndPrimitiveMatrixType >> instanceSize [
	<compileTime>
	^ instanceSize ifNil: [ instanceSize := (self columnType instanceSize alignedTo: self columnType instanceSize) * columns ]
]

{ #category : #'testing methods' }
MbndPrimitiveMatrixType >> isPrimitiveMatrixType [
	^ true
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> rowType [
	<compileTime>
	^ elementType primitiveVectorWithElements: columns
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> rows [
	^ rows
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> rows: anObject [
	rows := anObject
]
