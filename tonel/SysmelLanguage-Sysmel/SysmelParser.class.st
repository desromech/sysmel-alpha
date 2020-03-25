Class {
	#name : #SysmelParser,
	#superclass : #SmaCCParser,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #'generated-accessing' }
SysmelParser class >> cacheId [
	^'2020-03-25T19:32:13.467377+01:00'
]

{ #category : #generated }
SysmelParser class >> definitionComment [
"<whitespace> : \s+ ;
<comment> : \#\# [^\r\n]* 
	| \#\*([^*]|[\r\n]|(\*+([^*\#]|[\r\n])))*\*+\#
	;

<FLOAT> : [+\-]?[0-9]+ \. [0-9]+ ([eE] [\+\-]? [0-9]+)? ;
<INTEGER> : [+\-]?[0-9]+ (r [0-9A-Za-z]+)?;

<KEYWORD> : ([_A-Za-z][_A-Za-z0-9]*\:)+;
<IDENTIFIER> : [_A-Za-z][_A-Za-z0-9]* ;
<STRING> : \"" ([^\\\""] | (\\.) )*\"";
<CHARACTER> : \' ([^\\\'] | (\\.) )*\';

<SYMBOL_KEYWORD> : \#([_A-Za-z][_A-Za-z0-9]*\:)+ ;
<SYMBOL_IDENTIFIER> : \#([_A-Za-z][_A-Za-z0-9]*)+ ;
<SYMBOL_OPERATOR> : \#[\+\-/\\\*~<>=@,%|&?!^]+ ;
<SYMBOL_STRING> : \# \"" ([^\\\""] | (\\.) )*\"";

<LOW_PREC_BINARY> : \:\: [\+\-/\\\*~<>=@,%|&?!^]+;
<GENERIC_BINARY_OPERATOR> :  [\+\-/\\\*~<>=@,%|&?!^]+;

%start entry ;

%left <GENERIC_BINARY_OPERATOR> ;
%left ""||"" ;
%left ""&&"" ;
%left ""|"" ;
%left ""^"" ;
%left ""&"" ;
%left ""="" ""=="" ""~="" ""~~"" ;
%left ""<="" "">="" ""<"" "">"" ;
%left ""<<"" "">>"";
%left ""+"" ""-"";
%left ""*"" ""/"" ""//"" ""%"";

%root Abstract;
%prefix Sysmel;
%suffix ASTNode;
%annotate_tokens;

%hierarchy Expression (CallExpression CommaExpression BinaryExpression IdentifierReference MessageChain Literal KeywordMessage UnaryPrefixExpression UnaryMessage SubscriptExpression UnquoteUnaryMessage ParenthesesExpression QuoteExpression QuasiQuoteExpression QuasiUnquoteExpression SpliceExpression BlockExpression DictionaryExpression DictionaryElement DictionaryKey DictionaryKeywordKey LiteralArray) ;
%hierarchy Literal (LiteralCharacter LiteralFloat LiteralInteger LiteralString LiteralSymbol ) ;

entry
	: expressionList   'expressionList' {{File}}
	;
	
expressionList
	: expression 'expression'? (""."" 'dot' expression 'expression' ?)* {{ExpressionList}}
	;

expression
	: commaExpression {{Expression}}
	;

commaExpression
	: assignmentExpression 'expression' ("","" 'comma' assignmentExpression 'expression')+ "","" 'comma' ? {{CommaExpression}}
	| assignmentExpression 'expression' "","" 'comma' {{CommaExpression}}
	| assignmentExpression  {{Expression}}
	;

assignmentExpression
	: lowPrecedenceExpression  'left'  "":="" 'operation' assignmentExpression 'right' {{BinaryExpression}}
	| lowPrecedenceExpression {{Expression}}
	;
	
lowPrecedenceExpression
	: lowPrecedenceExpression 'left' <LOW_PREC_BINARY> 'operation' anyChainExpression 'right' {{BinaryExpression}}
	| anyChainExpression {{Expression}}
	;
	
anyChainExpression
	: implicitContextChainExpression {{Expression}}
	| chainExpression {{Expression}}
	;
	
implicitContextChainExpression
	: chainKeywordMessage 'firstMessage' ("";"" 'semicolon' chainedMessage 'chainedMessage')* {{MessageChain}}
	;
	
chainExpression
	: chainReceiver 'receiver' (chainKeywordMessage 'firstMessage')? ("";"" 'semicolon' chainedMessage 'chainedMessage')* {{MessageChain}}
	;
	
chainReceiver
	: binaryExpression {{Expression}}
	;

chainedMessage
	: chainKeywordMessage {{Expression}}
	| chainUnaryMessage {{Expression}}
	;
	
chainKeywordMessage
	: (<KEYWORD> 'keyword' binaryExpression 'argument') + {{KeywordMessage}}
	;

chainUnaryMessage
	: <IDENTIFIER> 'selector' {{UnaryMessage}}
	;

binaryExpression
	: unaryPrefixExpression {{Expression}}
	| binaryExpression 'left' ""*"" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' ""/"" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' ""//"" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' ""%"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""+"" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' ""-"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""<<"" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' "">>"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""<="" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' "">="" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' ""<"" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' "">"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""="" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' ""=="" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' ""~="" 'operation' binaryExpression 'right' {{BinaryExpression}}
	| binaryExpression 'left' ""~~"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""&"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""^"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""|"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""&&"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' ""||"" 'operation' binaryExpression 'right' {{BinaryExpression}}

	| binaryExpression 'left' <GENERIC_BINARY_OPERATOR> 'operation' binaryExpression 'right' {{BinaryExpression}}
	;
	
unaryPrefixExpression
	: unaryExpression {{Expression}}
	| ""+"" 'operation' unaryPrefixExpression 'operand' {{UnaryPrefixExpression}}
	| ""-"" 'operation' unaryPrefixExpression 'operand' {{UnaryPrefixExpression}}
	| ""!"" 'operation' unaryPrefixExpression 'operand' {{UnaryPrefixExpression}}
	| ""~"" 'operation' unaryPrefixExpression 'operand' {{UnaryPrefixExpression}}
	;
	
unaryExpression
	: primaryExpression {{Expression}}
	| unaryExpression 'receiver' <IDENTIFIER> 'selector' {{UnaryMessage}}
	| unaryExpression 'function' ""("" 'lparent' callArguments 'arguments' "")"" 'rparent' {{CallExpression}}
	| unaryExpression 'array' ""["" 'lbracket' expression 'subscript' ""]"" 'rbracket' {{SubscriptExpression}}
	| unaryExpression 'receiver' ""`,"" 'operator' primaryExpression 'selector' {{UnquoteUnaryMessage}}
	;
	
callArguments
	: (assignmentExpression 'argument' ("","" assignmentExpression 'argument' )*)? {{CallExpressionArguments}}
	;
	
primaryExpression
	: parentExpression {{Expression}}
	| quoteExpression {{Expression}}
	| quasiQuoteExpression {{Expression}}
	| quasiUnquoteExpression {{Expression}}
	| spliceExpression {{Expression}}
	| identifierReference {{Expression}}
	| dictionaryExpression{{Expression}}
	| blockExpression {{Expression}}
	| literalExpression {{Expression}}
	;

parentExpression
	: ""("" 'lparent' (expression 'expression')? "")"" 'rparent' {{ParenthesesExpression}}
	;

quoteExpression 
	:  ""`'"" 'operator' primaryExpression 'expression' {{QuoteExpression}}
	;

quasiQuoteExpression 
	:  ""``"" 'operator' primaryExpression 'expression' {{QuasiQuoteExpression}}
	;

quasiUnquoteExpression 
	:  ""`,"" 'operator' primaryExpression 'expression' {{QuasiUnquoteExpression}}
	;

spliceExpression 
	:  ""`@"" 'operator' primaryExpression 'expression' {{SpliceExpression}}
	;
	
identifierReference
	: <IDENTIFIER> 'symbol' {{IdentifierReference}}
	;
	
blockExpression
	: ""{"" 'lbracket' blockClosureSignature 'blockClosureSignature' ? (pragma 'pragma')* expressionList 'expressions' ""}"" 'rbracket' {{BlockExpression}}
	;
	
blockClosureSignature
	:  (blockClosureArgument 'argument') * (""::"" 'colonColon' blockClosureReturnType 'returnType') ? ""|"" {{BlockClosureSignature}}
	;
	
blockClosureArgument
	:  "":"" (parentExpression 'type')?  identifierExpressionOrMacroExpansion 'name' {{BlockClosureArgument}}
	;
	
blockClosureReturnType
	: identifierExpressionOrMacroExpansion {{Expression}}
	| parentExpression {{Expression}}
	;
	
identifierExpressionOrMacroExpansion
	: identifierReference {{Expression}}
	| quasiUnquoteExpression {{Expression}}
	;

pragma
	: ""<"" 'lessThan' pragmaChainedMessage 'message' "">"" 'greaterThan' {{Pragma}}
	;

pragmaChainedMessage
	: pragmaChainKeywordMessage {{Expression}}
	| pragmaChainUnaryMessage {{Expression}}
	;

pragmaChainKeywordMessage
	: (<KEYWORD> 'keyword' primaryExpression 'argument') + {{KeywordMessage}}
	;

pragmaChainUnaryMessage
	: <IDENTIFIER> 'selector' {{UnaryMessage}}
	;
	
dictionaryExpression
	: ""#{"" (dictionaryElement 'element') ? (""."" (dictionaryElement 'element') ?)* ""}"" {{DictionaryExpression}}
	;

dictionaryElement
	: dictionaryKey 'key' expression 'value' ? {{DictionaryElement}}
	; 

dictionaryKey
	: dictionaryKeywordKey'value' {{DictionaryKey}}
	|  binaryExpression 'value' "":"" {{DictionaryKey}}
	;

dictionaryKeywordKey
	: <KEYWORD> 'value' {{DictionaryKeywordKey}}
	;
	
literalExpression
	: <FLOAT> 'value' {{LiteralFloat}}
	| <INTEGER> 'value' {{LiteralInteger}}
	| <STRING> 'value' {{LiteralString}}
	| <CHARACTER> 'value' {{LiteralCharacter}}
	| <SYMBOL_KEYWORD> 'value' {{LiteralSymbol}}
	| <SYMBOL_IDENTIFIER> 'value' {{LiteralSymbol}}
	| <SYMBOL_OPERATOR> 'value' {{LiteralSymbol}}
	| <SYMBOL_STRING> 'value' {{LiteralSymbol}}
	| literalArray {{Expression}}
	;
	
literalArray
	: ""#("" (literalArrayLiteral 'element')* "")"" {{LiteralArray}}
	;

literalArrayParentLiteral
	: ""("" (literalArrayLiteral 'element')* "")"" {{LiteralArray}}
	;
	
literalArrayLiteral
	: <KEYWORD> 'value' {{LiteralSymbol}}
	| <IDENTIFIER> 'value' {{LiteralSymbol}}
	| ""*"" 'value' {{LiteralSymbol}}
	| ""/"" 'value' {{LiteralSymbol}}
	| ""//"" 'value' {{LiteralSymbol}}
	| ""%"" 'value' {{LiteralSymbol}}
	| ""+"" 'value' {{LiteralSymbol}}
	| ""-"" 'value' {{LiteralSymbol}}
	| ""<<"" 'value' {{LiteralSymbol}}
	| "">>"" 'value' {{LiteralSymbol}}
	| ""<="" 'value' {{LiteralSymbol}}
	| "">="" 'value' {{LiteralSymbol}}
	| ""<"" 'value' {{LiteralSymbol}}
	| "">"" 'value' {{LiteralSymbol}}
	| ""="" 'value' {{LiteralSymbol}}
	| ""=="" 'value' {{LiteralSymbol}}
	| ""~="" 'value' {{LiteralSymbol}}
	| ""~~"" 'value' {{LiteralSymbol}}
	| ""&"" 'value' {{LiteralSymbol}}
	| ""^"" 'value' {{LiteralSymbol}}
	| ""|"" 'value' {{LiteralSymbol}}
	| ""&&"" 'value' {{LiteralSymbol}}
	| ""||"" 'value' {{LiteralSymbol}}
	| <GENERIC_BINARY_OPERATOR> 'value' {{LiteralSymbol}}
	| literalArrayParentLiteral {{Expression}}
	| literalExpression {{Expression}}
	;"
]

{ #category : #'generated-accessing' }
SysmelParser class >> scannerClass [
	^SysmelScanner
]

{ #category : #generated }
SysmelParser class >> startingStateForentry [
	^ 1
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFor___KEYWORD___keyword__binaryExpression__argument___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: ((nodes at: 1) at: 1) to: (result at: 1).
	self add: ((nodes at: 1) at: 2) to: (result at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFor___KEYWORD___keyword__binaryExpression__argument___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFor________colonColon__blockClosureReturnType__returnType___1: nodes [
	| result |
	result := Array new: 2.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFor_______semicolon__chainedMessage__chainedMessage___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFor__assignmentExpression__argument________assignmentExpression__argument____1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: (nodes at: 1) to: (result at: 1).
	self addAll: ((nodes at: 2) at: 1) to: (result at: 2).
	self addAll: ((nodes at: 2) at: 2) to: (result at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFor__blockClosureArgument__argument___1: nodes [
	| result |
	result := OrderedCollection new: 2.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFor__blockClosureArgument__argument___2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: result.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForassignmentExpression1: nodes [
	| result |
	result := SysmelBinaryExpressionASTNode new.
	result left: (nodes at: 1).
	result operation: (nodes at: 2).
	result right: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForassignmentExpression2: nodes [
	| result |
	result := nodes at: 1.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForblockClosureArgument1: nodes [
	| result |
	result := SysmelBlockClosureArgumentASTNode new.
	result colonToken: (nodes at: 1).
	result type: (nodes at: 2).
	result name: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForblockClosureSignature1: nodes [
	| result |
	result := SysmelBlockClosureSignatureASTNode new.
	result addNodes: (nodes at: 1) to: result arguments.
	result colonColon: ((nodes at: 2) at: 1).
	result returnType: ((nodes at: 2) at: 2).
	result orToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForblockExpression1: nodes [
	| result |
	result := SysmelBlockExpressionASTNode new.
	result lbracket: (nodes at: 1).
	result blockClosureSignature: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result pragmas.
	result expressions: (nodes at: 4).
	result rbracket: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForcallArguments1: nodes [
	| result |
	result := SysmelCallExpressionArgumentsASTNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result arguments.
	result addTokens: ((nodes at: 1) at: 2) to: result commaTokens.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForchainExpression1: nodes [
	| result |
	result := SysmelMessageChainASTNode new.
	result receiver: (nodes at: 1).
	result firstMessage: (nodes at: 2).
	result addTokens: ((nodes at: 3) at: 1) to: result semicolons.
	result addNodes: ((nodes at: 3) at: 2) to: result chainedMessages.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForchainKeywordMessage1: nodes [
	| result |
	result := SysmelKeywordMessageASTNode new.
	result addTokens: ((nodes at: 1) at: 1) to: result keywords.
	result addNodes: ((nodes at: 1) at: 2) to: result arguments.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForchainUnaryMessage1: nodes [
	| result |
	result := SysmelUnaryMessageASTNode new.
	result selector: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForcommaExpression1: nodes [
	| result |
	result := SysmelCommaExpressionASTNode new.
	result addNode: (nodes at: 1) to: result expressions.
	result addTokens: ((nodes at: 2) at: 1) to: result commas.
	result addNodes: ((nodes at: 2) at: 2) to: result expressions.
	result addToken: (nodes at: 3) to: result commas.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForcommaExpression2: nodes [
	| result |
	result := SysmelCommaExpressionASTNode new.
	result addNode: (nodes at: 1) to: result expressions.
	result addToken: (nodes at: 2) to: result commas.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFordictionaryElement1: nodes [
	| result |
	result := SysmelDictionaryElementASTNode new.
	result key: (nodes at: 1).
	result value: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFordictionaryExpression1: nodes [
	| result |
	result := SysmelDictionaryExpressionASTNode new.
	result _LeftBraceToken: (nodes at: 1).
	result addNode: (nodes at: 2) to: result elements.
	result addTokens: ((nodes at: 3) at: 1) to: result periodTokens.
	result addNodes: ((nodes at: 3) at: 2) to: result elements.
	result rightBraceToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFordictionaryKey1: nodes [
	| result |
	result := SysmelDictionaryKeyASTNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFordictionaryKey2: nodes [
	| result |
	result := SysmelDictionaryKeyASTNode new.
	result value: (nodes at: 1).
	result colonToken: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionFordictionaryKeywordKey1: nodes [
	| result |
	result := SysmelDictionaryKeywordKeyASTNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForentry1: nodes [
	| result |
	result := SysmelFileASTNode new.
	result expressionList: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForexpressionList1: nodes [
	| result |
	result := SysmelExpressionListASTNode new.
	result addNode: (nodes at: 1) to: result expressions.
	result addTokens: ((nodes at: 2) at: 1) to: result dots.
	result addNodes: ((nodes at: 2) at: 2) to: result expressions.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForexpression__expression___2: nodes [
	^ nodes at: 1
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForidentifierReference1: nodes [
	| result |
	result := SysmelIdentifierReferenceASTNode new.
	result symbol: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForimplicitContextChainExpression1: nodes [
	| result |
	result := SysmelMessageChainASTNode new.
	result firstMessage: (nodes at: 1).
	result addTokens: ((nodes at: 2) at: 1) to: result semicolons.
	result addNodes: ((nodes at: 2) at: 2) to: result chainedMessages.
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForliteralArray1: nodes [
	| result |
	result := SysmelLiteralArrayASTNode new.
	result _LeftParenToken: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result elements.
	result rightParenToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForliteralArrayParentLiteral1: nodes [
	| result |
	result := SysmelLiteralArrayASTNode new.
	result leftParenToken: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result elements.
	result rightParenToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForliteralExpression1: nodes [
	| result |
	result := SysmelLiteralFloatASTNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForliteralExpression2: nodes [
	| result |
	result := SysmelLiteralIntegerASTNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForliteralExpression3: nodes [
	| result |
	result := SysmelLiteralStringASTNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForliteralExpression4: nodes [
	| result |
	result := SysmelLiteralCharacterASTNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForliteralExpression5: nodes [
	| result |
	result := SysmelLiteralSymbolASTNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForparentExpression1: nodes [
	| result |
	result := SysmelParenthesesExpressionASTNode new.
	result lparent: (nodes at: 1).
	result expression: (nodes at: 2).
	result rparent: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForpragma1: nodes [
	| result |
	result := SysmelPragmaASTNode new.
	result lessThan: (nodes at: 1).
	result message: (nodes at: 2).
	result greaterThan: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForquasiQuoteExpression1: nodes [
	| result |
	result := SysmelQuasiQuoteExpressionASTNode new.
	result operator: (nodes at: 1).
	result expression: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForquasiUnquoteExpression1: nodes [
	| result |
	result := SysmelQuasiUnquoteExpressionASTNode new.
	result operator: (nodes at: 1).
	result expression: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForquoteExpression1: nodes [
	| result |
	result := SysmelQuoteExpressionASTNode new.
	result operator: (nodes at: 1).
	result expression: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForspliceExpression1: nodes [
	| result |
	result := SysmelSpliceExpressionASTNode new.
	result operator: (nodes at: 1).
	result expression: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForunaryExpression2: nodes [
	| result |
	result := SysmelUnaryMessageASTNode new.
	result receiver: (nodes at: 1).
	result selector: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForunaryExpression3: nodes [
	| result |
	result := SysmelCallExpressionASTNode new.
	result function: (nodes at: 1).
	result lparent: (nodes at: 2).
	result arguments: (nodes at: 3).
	result rparent: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForunaryExpression4: nodes [
	| result |
	result := SysmelSubscriptExpressionASTNode new.
	result array: (nodes at: 1).
	result lbracket: (nodes at: 2).
	result subscript: (nodes at: 3).
	result rbracket: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForunaryExpression5: nodes [
	| result |
	result := SysmelUnquoteUnaryMessageASTNode new.
	result receiver: (nodes at: 1).
	result operator: (nodes at: 2).
	result selector: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SysmelParser >> reduceActionForunaryPrefixExpression2: nodes [
	| result |
	result := SysmelUnaryPrefixExpressionASTNode new.
	result operation: (nodes at: 1).
	result operand: (nodes at: 2).
	^ result
]

{ #category : #generated }
SysmelParser >> reduceTable [
^#(
	#(123 0 #nil) 
	#(93 0 #nil) 
	#(99 0 #reduceActionFor__blockClosureArgument__argument___1:) 
	#(113 0 #nil) 
	#(130 0 #reduceActionFor__blockClosureArgument__argument___1:) 
	#(91 0 #nil) 
	#(89 1 #reduceActionForliteralExpression1:) 
	#(89 1 #reduceActionForliteralExpression2:) 
	#(86 1 #reduceActionForidentifierReference1:) 
	#(89 1 #reduceActionForliteralExpression3:) 
	#(89 1 #reduceActionForliteralExpression4:) 
	#(89 1 #reduceActionForliteralExpression5:) 
	#(119 1 #reduceActionForassignmentExpression2:) 
	#(56 1 #reduceActionForassignmentExpression2:) 
	#(57 1 #reduceActionForassignmentExpression2:) 
	#(63 0 #reduceActionFor_______semicolon__chainedMessage__chainedMessage___1:) 
	#(66 0 #nil) 
	#(64 1 #reduceActionForassignmentExpression2:) 
	#(71 1 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___1:) 
	#(60 1 #reduceActionForchainKeywordMessage1:) 
	#(67 1 #reduceActionForassignmentExpression2:) 
	#(73 1 #reduceActionForassignmentExpression2:) 
	#(74 1 #reduceActionForassignmentExpression2:) 
	#(75 1 #reduceActionForassignmentExpression2:) 
	#(120 1 #reduceActionForassignmentExpression2:) 
	#(124 1 #reduceActionForassignmentExpression2:) 
	#(121 0 #reduceActionFor_______semicolon__chainedMessage__chainedMessage___1:) 
	#(123 1 #reduceActionForexpression__expression___2:) 
	#(68 1 #reduceActionForentry1:) 
	#(89 1 #reduceActionForassignmentExpression2:) 
	#(73 2 #reduceActionForunaryPrefixExpression2:) 
	#(85 2 #reduceActionForspliceExpression1:) 
	#(83 2 #reduceActionForquasiQuoteExpression1:) 
	#(93 1 #reduceActionForexpression__expression___2:) 
	#(96 0 #reduceActionFor__blockClosureArgument__argument___1:) 
	#(102 0 #reduceActionFor________colonColon__blockClosureReturnType__returnType___1:) 
	#(82 2 #reduceActionForquoteExpression1:) 
	#(118 1 #reduceActionFordictionaryKeywordKey1:) 
	#(112 1 #reduceActionForexpression__expression___2:) 
	#(113 1 #reduceActionForexpression__expression___2:) 
	#(115 0 #reduceActionFor_______semicolon__chainedMessage__chainedMessage___1:) 
	#(117 0 #nil) 
	#(116 1 #reduceActionFordictionaryKey1:) 
	#(84 2 #reduceActionForquasiUnquoteExpression1:) 
	#(91 1 #reduceActionForexpression__expression___2:) 
	#(90 1 #reduceActionForexpression__expression___2:) 
	#(70 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1:) 
	#(58 2 #reduceActionForimplicitContextChainExpression1:) 
	#(65 1 #reduceActionForexpression__expression___2:) 
	#(66 1 #reduceActionForexpression__expression___2:) 
	#(71 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___2:) 
	#(80 0 #reduceActionFor_______semicolon__chainedMessage__chainedMessage___1:) 
	#(74 2 #reduceActionForunaryExpression2:) 
	#(120 2 #reduceActionForcommaExpression2:) 
	#(69 0 #nil) 
	#(72 1 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___1:) 
	#(126 2 #reduceActionForexpressionList1:) 
	#(104 0 #nil) 
	#(98 1 #reduceActionForexpression__expression___2:) 
	#(99 2 #reduceActionFor__blockClosureArgument__argument___2:) 
	#(102 1 #reduceActionForassignmentExpression2:) 
	#(116 2 #reduceActionFordictionaryKey2:) 
	#(111 2 #reduceActionFordictionaryElement1:) 
	#(117 1 #reduceActionForexpression__expression___2:) 
	#(128 1 #reduceActionForliteralExpression5:) 
	#(127 3 #reduceActionForliteralArray1:) 
	#(128 1 #reduceActionForassignmentExpression2:) 
	#(129 1 #reduceActionForexpression__expression___2:) 
	#(130 2 #reduceActionFor__blockClosureArgument__argument___2:) 
	#(81 3 #reduceActionForparentExpression1:) 
	#(119 3 #reduceActionForassignmentExpression1:) 
	#(56 3 #reduceActionForassignmentExpression1:) 
	#(63 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___2:) 
	#(59 3 #reduceActionForchainExpression1:) 
	#(67 3 #reduceActionForassignmentExpression1:) 
	#(74 3 #reduceActionForunaryExpression5:) 
	#(80 1 #reduceActionForassignmentExpression2:) 
	#(76 1 #reduceActionForcallArguments1:) 
	#(78 0 #reduceActionFor_______semicolon__chainedMessage__chainedMessage___1:) 
	#(88 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1:) 
	#(69 1 #reduceActionForexpression__expression___2:) 
	#(120 3 #reduceActionForcommaExpression1:) 
	#(72 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___2:) 
	#(121 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___2:) 
	#(95 1 #reduceActionForexpression__expression___2:) 
	#(96 2 #reduceActionFor__blockClosureArgument__argument___2:) 
	#(103 1 #reduceActionForexpression__expression___2:) 
	#(104 1 #reduceActionForexpression__expression___2:) 
	#(100 1 #reduceActionForassignmentExpression2:) 
	#(105 1 #reduceActionForassignmentExpression2:) 
	#(101 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1:) 
	#(92 3 #reduceActionForblockClosureSignature1:) 
	#(87 4 #reduceActionFordictionaryExpression1:) 
	#(115 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___2:) 
	#(135 1 #reduceActionForchainUnaryMessage1:) 
	#(61 1 #reduceActionForassignmentExpression2:) 
	#(62 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1:) 
	#(74 4 #reduceActionForunaryExpression3:) 
	#(79 2 #reduceActionFor__assignmentExpression__argument________assignmentExpression__argument____1:) 
	#(74 4 #reduceActionForunaryExpression4:) 
	#(122 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1:) 
	#(108 1 #reduceActionForchainUnaryMessage1:) 
	#(106 1 #reduceActionForassignmentExpression2:) 
	#(110 1 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___1:) 
	#(107 1 #reduceActionForchainKeywordMessage1:) 
	#(134 5 #reduceActionForblockExpression1:) 
	#(97 3 #reduceActionForblockClosureArgument1:) 
	#(114 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1:) 
	#(131 3 #reduceActionForliteralArrayParentLiteral1:) 
	#(78 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___2:) 
	#(109 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1:) 
	#(94 3 #reduceActionForpragma1:) 
	#(110 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument___2:) 
	#(77 2 #reduceActionFor___KEYWORD___keyword__binaryExpression__argument__1:)
	).
]

{ #category : #generated }
SysmelParser >> symbolNames [
	^ #('"<<"' '">"' '">>"' '"+"' '"<"' '"/"' '"*"' '"<="' '">="' '"-"' '"//"' '"|"' '"&&"' '"^"' '"&"' '"||"' '"~="' '"=="' '"~~"' '"%"' '"="' '"`@"' '"``"' '"{"' '"}"' '"`''"' '"#{"' '":"' '"]"' '"`,"' '"::"' '"#("' '":="' '","' '";"' '"!"' '"."' '")"' '"("' '"["' '"~"' '<whitespace>' '<comment>' '<FLOAT>' '<INTEGER>' '<KEYWORD>' '<IDENTIFIER>' '<STRING>' '<CHARACTER>' '<SYMBOL_KEYWORD>' '<SYMBOL_IDENTIFIER>' '<SYMBOL_OPERATOR>' '<SYMBOL_STRING>' '<LOW_PREC_BINARY>' '<GENERIC_BINARY_OPERATOR>' 'lowPrecedenceExpression' 'anyChainExpression' 'implicitContextChainExpression' 'chainExpression' 'chainKeywordMessage' 'chainedMessage' '( ";" ''semicolon'' chainedMessage ''chainedMessage'')' '( ";" ''semicolon'' chainedMessage ''chainedMessage'')*' 'chainReceiver' '( chainKeywordMessage ''firstMessage'')' '( chainKeywordMessage ''firstMessage'')?' 'binaryExpression' 'entry' '"," ''comma'' ?' '( <KEYWORD> ''keyword'' binaryExpression ''argument'')' '( <KEYWORD> ''keyword'' binaryExpression ''argument'')+' '( "," ''comma'' assignmentExpression ''expression'')+' 'unaryPrefixExpression' 'unaryExpression' 'primaryExpression' 'callArguments' '( "," assignmentExpression ''argument'')' '( "," assignmentExpression ''argument'')*' '( assignmentExpression ''argument'' ( "," assignmentExpression ''argument'')*)' '( assignmentExpression ''argument'' ( "," assignmentExpression ''argument'')*)?' 'parentExpression' 'quoteExpression' 'quasiQuoteExpression' 'quasiUnquoteExpression' 'spliceExpression' 'identifierReference' 'dictionaryExpression' '( "," ''comma'' assignmentExpression ''expression'')' 'literalExpression' '( expression ''expression'')' '( expression ''expression'')?' 'blockClosureSignature' 'blockClosureSignature ''blockClosureSignature'' ?' 'pragma' '( pragma ''pragma'')' '( pragma ''pragma'')*' 'blockClosureArgument' '( blockClosureArgument ''argument'')' '( blockClosureArgument ''argument'')*' 'blockClosureReturnType' '( "::" ''colonColon'' blockClosureReturnType ''returnType'')' '( "::" ''colonColon'' blockClosureReturnType ''returnType'')?' '( parentExpression ''type'')' '( parentExpression ''type'')?' 'identifierExpressionOrMacroExpansion' 'pragmaChainedMessage' 'pragmaChainKeywordMessage' 'pragmaChainUnaryMessage' '( <KEYWORD> ''keyword'' primaryExpression ''argument'')' '( <KEYWORD> ''keyword'' primaryExpression ''argument'')+' 'dictionaryElement' '( dictionaryElement ''element'')' '( dictionaryElement ''element'')?' '( "." ( dictionaryElement ''element'')?)' '( "." ( dictionaryElement ''element'')?)*' 'dictionaryKey' 'expression ''value'' ?' 'dictionaryKeywordKey' 'assignmentExpression' 'commaExpression' '( "." ''dot'' expression ''expression'' ?)*' '( "." ''dot'' expression ''expression'' ?)' 'expression ''expression'' ?' 'expression' 'B e g i n' 'expressionList' 'literalArray' 'literalArrayLiteral' '( literalArrayLiteral ''element'')' '( literalArrayLiteral ''element'')*' 'literalArrayParentLiteral' 'E O F' 'error' 'blockExpression' 'chainUnaryMessage')
]

{ #category : #generated }
SysmelParser >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SysmelExpressionASTNode #SysmelExpressionASTNode #SysmelMessageChainASTNode #SysmelMessageChainASTNode #SysmelKeywordMessageASTNode #SysmelExpressionASTNode #OrderedCollection #OrderedCollection #SysmelExpressionASTNode #SysmelKeywordMessageASTNode #SysmelKeywordMessageASTNode #SysmelExpressionASTNode #SysmelFileASTNode #SmaCCToken #OrderedCollection #OrderedCollection #OrderedCollection #SysmelExpressionASTNode #SysmelExpressionASTNode #SysmelExpressionASTNode #SysmelCallExpressionArgumentsASTNode #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #SysmelParenthesesExpressionASTNode #SysmelQuoteExpressionASTNode #SysmelQuasiQuoteExpressionASTNode #SysmelQuasiUnquoteExpressionASTNode #SysmelSpliceExpressionASTNode #SysmelIdentifierReferenceASTNode #SysmelDictionaryExpressionASTNode #OrderedCollection #SysmelExpressionASTNode #SysmelExpressionASTNode #SysmelExpressionASTNode #SysmelBlockClosureSignatureASTNode #SysmelBlockClosureSignatureASTNode #SysmelPragmaASTNode #SysmelPragmaASTNode #OrderedCollection #SysmelBlockClosureArgumentASTNode #SysmelBlockClosureArgumentASTNode #OrderedCollection #SysmelExpressionASTNode #OrderedCollection #OrderedCollection #SysmelParenthesesExpressionASTNode #SysmelParenthesesExpressionASTNode #SysmelExpressionASTNode #SysmelExpressionASTNode #SysmelKeywordMessageASTNode #SysmelUnaryMessageASTNode #OrderedCollection #OrderedCollection #SysmelDictionaryElementASTNode #SysmelDictionaryElementASTNode #SysmelDictionaryElementASTNode #OrderedCollection #OrderedCollection #SysmelDictionaryKeyASTNode #SysmelExpressionASTNode #SysmelDictionaryKeywordKeyASTNode #SysmelExpressionASTNode #SysmelExpressionASTNode #OrderedCollection #OrderedCollection #SysmelExpressionASTNode #SysmelExpressionASTNode #SysmelFileASTNode #SysmelExpressionListASTNode #SysmelLiteralArrayASTNode #SysmelExpressionASTNode #SysmelExpressionASTNode #OrderedCollection #SysmelLiteralArrayASTNode #SmaCCToken #SmaCCToken #SysmelBlockExpressionASTNode #SysmelUnaryMessageASTNode)
]

{ #category : #generated }
SysmelParser >> transitionTable [
^#(
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 6 0 37 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 125 0 68 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 181 0 119 0 185 0 120 0 189 0 123 0 193 0 124 0 197 0 126 0 201 0 127 0 6 0 132 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 209 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 213 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 49 0 39 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 217 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 49 0 39 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 221 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 10 0 4 0 10 0 5 0 10 0 10 0 14 0 12 0 10 0 22 0 10 0 23 0 10 0 24 0 10 0 25 0 10 0 26 0 10 0 27 0 14 0 28 0 10 0 30 0 14 0 31 0 10 0 32 0 10 0 36 0 10 0 37 0 10 0 39 0 10 0 41 0 10 0 44 0 10 0 45 0 10 0 46 0 10 0 47 0 10 0 48 0 10 0 49 0 10 0 50 0 10 0 51 0 10 0 52 0 10 0 53 0 225 0 92 0 229 0 93 0 233 0 99] 
#[1 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 49 0 39 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 237 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 18 0 25 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 18 0 37 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 241 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 245 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 249 0 111 0 253 0 112 1 1 0 113 1 5 0 116 1 9 0 118 0 201 0 127 0 205 0 134] 
#[1 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 49 0 39 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 1 13 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 22 0 1 0 22 0 2 0 22 0 3 0 22 0 4 0 22 0 5 0 22 0 6 0 22 0 7 0 22 0 8 0 22 0 9 0 22 0 10 0 22 0 11 0 22 0 12 0 22 0 13 0 22 0 14 0 22 0 15 0 22 0 16 0 22 0 17 0 22 0 18 0 22 0 19 0 22 0 20 0 22 0 21 0 22 0 32 0 22 0 38 0 22 0 39 0 22 0 44 0 22 0 45 0 22 0 46 0 22 0 47 0 22 0 48 0 22 0 49 0 22 0 50 0 22 0 51 0 22 0 52 0 22 0 53 0 22 0 55 1 17 0 130] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 1 21 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 26 0 38 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 1 25 0 90 1 29 0 91 0 181 0 119 0 185 0 120 1 33 0 124 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 1 37 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[0 0 30 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[0 0 34 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 1 41 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[0 0 38 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 42 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[0 0 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[0 0 50 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[0 0 50 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[0 0 50 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[0 0 50 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[1 0 54 0 25 0 54 0 29 1 45 0 33 0 54 0 34 0 54 0 37 0 54 0 38 1 49 0 54 0 54 0 132] 
#[0 0 58 0 25 0 29 0 33 0 34 0 37 0 38 0 54 0 132] 
#[0 0 62 0 25 0 29 0 33 0 34 0 37 0 38 0 54 0 132] 
#[0 0 62 0 25 0 29 0 33 0 34 0 37 0 38 0 54 0 132] 
#[1 0 66 0 25 0 66 0 29 0 66 0 33 0 66 0 34 0 66 0 35 0 66 0 37 0 66 0 38 0 66 0 54 1 53 0 63 0 66 0 132] 
#[1 0 70 0 25 0 70 0 29 0 70 0 33 0 70 0 34 0 70 0 35 0 70 0 37 0 70 0 38 0 65 0 46 0 70 0 54 1 57 0 60 1 61 0 65 1 65 0 66 0 129 0 70 0 133 0 71 0 70 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 113 0 12 1 117 0 13 1 121 0 14 1 125 0 15 1 129 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 0 74 0 25 0 74 0 29 0 74 0 33 0 74 0 34 0 74 0 35 0 74 0 37 0 74 0 38 0 74 0 46 0 74 0 54 1 153 0 55 0 74 0 132] 
#[0 0 0 0 132] 
#[0 0 78 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 132] 
#[1 0 82 0 25 0 82 0 29 0 82 0 33 0 82 0 34 0 82 0 35 0 82 0 37 0 82 0 38 0 65 0 46 0 82 0 54 1 157 0 70 0 82 0 132] 
#[0 0 86 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[1 0 90 0 1 0 90 0 2 0 90 0 3 0 90 0 4 0 90 0 5 0 90 0 6 0 90 0 7 0 90 0 8 0 90 0 9 0 90 0 10 0 90 0 11 0 90 0 12 0 90 0 13 0 90 0 14 0 90 0 15 0 90 0 16 0 90 0 17 0 90 0 18 0 90 0 19 0 90 0 20 0 90 0 21 0 90 0 25 0 90 0 28 0 90 0 29 1 161 0 30 0 90 0 33 0 90 0 34 0 90 0 35 0 90 0 37 0 90 0 38 1 165 0 39 1 169 0 40 0 90 0 46 1 173 0 47 0 90 0 54 0 90 0 55 0 90 0 132] 
#[0 0 94 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[1 0 102 0 25 0 102 0 29 1 177 0 34 0 102 0 37 0 102 0 38 1 181 0 72 1 185 0 88 0 102 0 132] 
#[0 0 106 0 25 0 29 0 37 0 38 0 132] 
#[1 0 110 0 25 0 110 0 37 1 189 0 121 0 110 0 132] 
#[0 0 114 0 25 0 37 0 132] 
#[0 0 118 0 132] 
#[0 0 122 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 126 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[0 0 126 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[0 0 130 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 134 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 138 0 4 0 5 0 10 0 22 0 23 0 24 0 25 0 26 0 27 0 30 0 32 0 36 0 37 0 39 0 41 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53] 
#[1 0 142 0 4 0 142 0 5 0 142 0 10 0 142 0 22 0 142 0 23 0 142 0 24 0 142 0 25 0 142 0 26 0 142 0 27 0 142 0 30 0 142 0 32 0 142 0 36 0 142 0 37 0 142 0 39 0 142 0 41 0 142 0 44 0 142 0 45 0 142 0 46 0 142 0 47 0 142 0 48 0 142 0 49 0 142 0 50 0 142 0 51 0 142 0 52 0 142 0 53 1 193 0 96] 
#[1 0 146 0 12 1 197 0 28 1 201 0 31 1 205 0 97 1 209 0 98 1 213 0 101 1 217 0 102] 
#[0 0 150 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 0 154 0 4 0 10 0 22 0 23 0 24 0 25 0 26 0 27 0 30 0 32 0 36 0 37 0 39 0 41 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 113 0 12 1 117 0 13 1 121 0 14 1 125 0 15 1 129 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 1 221 0 28 1 153 0 55] 
#[0 0 158 0 25 0 37] 
#[0 0 162 0 25 0 37] 
#[1 0 166 0 25 0 166 0 37 1 225 0 115] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 170 0 25 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 170 0 37 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 1 229 0 117 0 181 0 119 0 185 0 120 1 233 0 124 0 201 0 127 0 205 0 134] 
#[0 0 174 0 4 0 10 0 22 0 23 0 24 0 25 0 26 0 27 0 30 0 32 0 36 0 37 0 39 0 41 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53] 
#[0 0 178 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[1 1 237 0 1 1 241 0 2 1 245 0 3 1 249 0 4 1 253 0 5 2 1 0 6 2 5 0 7 2 9 0 8 2 13 0 9 2 17 0 10 2 21 0 11 2 25 0 12 2 29 0 13 2 33 0 14 2 37 0 15 2 41 0 16 2 45 0 17 2 49 0 18 2 53 0 19 2 57 0 20 2 61 0 21 0 41 0 32 2 65 0 38 2 69 0 39 0 57 0 44 0 61 0 45 2 73 0 46 2 77 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 81 0 55 2 85 0 89 0 201 0 127 2 89 0 128 2 93 0 129 2 97 0 131] 
#[0 0 126 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[0 0 182 0 38] 
#[0 2 101 0 38] 
#[0 0 186 0 38] 
#[0 0 126 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 113 0 12 1 117 0 13 1 121 0 14 1 125 0 15 1 129 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 0 190 0 25 0 190 0 29 0 190 0 33 0 190 0 34 0 190 0 35 0 190 0 37 0 190 0 38 0 190 0 46 0 190 0 54 1 153 0 55 0 190 0 132] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 2 105 0 119 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 109 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 194 0 25 0 194 0 29 0 194 0 33 0 194 0 34 2 113 0 35 0 194 0 37 0 194 0 38 0 194 0 54 2 117 0 62 0 194 0 132] 
#[0 0 198 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 54 0 132] 
#[0 0 202 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 54 0 132] 
#[1 0 66 0 25 0 66 0 29 0 66 0 33 0 66 0 34 0 66 0 35 0 66 0 37 0 66 0 38 0 66 0 54 2 121 0 63 0 66 0 132] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 125 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 129 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 133 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 137 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 141 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 145 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 149 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 153 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 157 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 161 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 165 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 169 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 173 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 177 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 181 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 185 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 189 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 193 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 197 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 201 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 205 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 209 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[0 0 206 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 132] 
#[1 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 49 0 39 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 213 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 210 0 38 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 2 217 0 76 2 221 0 79 2 225 0 80 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 2 229 0 119 0 201 0 127 0 205 0 134] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 181 0 119 0 185 0 120 2 233 0 124 0 201 0 127 0 205 0 134] 
#[0 0 214 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 218 0 25 0 29 0 26 0 33 0 27 0 218 0 29 0 37 0 30 0 41 0 32 0 45 0 36 0 218 0 37 0 218 0 38 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 2 237 0 119 0 201 0 127 0 218 0 132 0 205 0 134] 
#[1 0 222 0 25 0 222 0 29 2 241 0 34 0 222 0 37 0 222 0 38 2 245 0 69 2 249 0 88 0 222 0 132] 
#[0 0 226 0 25 0 29 0 34 0 37 0 38 0 132] 
#[1 0 230 0 25 2 253 0 37 3 1 0 122 0 230 0 132] 
#[1 0 9 0 4 3 5 0 5 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 6 0 25 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 6 0 37 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 3 9 0 94 3 13 0 95 0 181 0 119 0 185 0 120 0 189 0 123 0 193 0 124 3 17 0 126 0 201 0 127 0 205 0 134] 
#[1 0 234 0 30 0 49 0 39 0 234 0 47 3 21 0 81 3 25 0 103 3 29 0 104] 
#[1 0 37 0 30 0 49 0 39 0 69 0 47 3 33 0 81 3 37 0 84 3 41 0 86 3 45 0 100 3 49 0 105] 
#[0 0 238 0 12 0 28 0 31] 
#[0 0 242 0 12 0 28 0 31] 
#[0 0 246 0 12] 
#[0 3 53 0 12] 
#[0 0 250 0 4 0 10 0 22 0 23 0 24 0 25 0 26 0 27 0 30 0 32 0 36 0 37 0 39 0 41 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53] 
#[1 3 57 0 25 3 61 0 37 3 65 0 114] 
#[0 0 254 0 25 0 37] 
#[0 1 2 0 25 0 37] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 10 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 132] 
#[1 0 22 0 1 0 22 0 2 0 22 0 3 0 22 0 4 0 22 0 5 0 22 0 6 0 22 0 7 0 22 0 8 0 22 0 9 0 22 0 10 0 22 0 11 0 22 0 12 0 22 0 13 0 22 0 14 0 22 0 15 0 22 0 16 0 22 0 17 0 22 0 18 0 22 0 19 0 22 0 20 0 22 0 21 0 22 0 32 0 22 0 38 0 22 0 39 0 22 0 44 0 22 0 45 0 22 0 46 0 22 0 47 0 22 0 48 0 22 0 49 0 22 0 50 0 22 0 51 0 22 0 52 0 22 0 53 0 22 0 55 3 69 0 130] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 14 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 18 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 22 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 14 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[0 1 26 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 1 30 0 25 0 29 0 34 0 37 0 38 0 132] 
#[0 1 34 0 25 0 29 0 33 0 34 0 37 0 38 0 54 0 132] 
#[1 0 65 0 46 3 73 0 47 3 77 0 60 3 81 0 61 0 129 0 70 0 133 0 71 3 85 0 135] 
#[0 1 38 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 54 0 132] 
#[1 1 42 0 25 1 42 0 29 1 42 0 33 1 42 0 34 2 113 0 35 1 42 0 37 1 42 0 38 1 42 0 54 2 117 0 62 1 42 0 132] 
#[1 1 46 0 1 1 46 0 2 1 46 0 3 1 81 0 4 1 46 0 5 1 89 0 6 1 93 0 7 1 46 0 8 1 46 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 46 0 2 1 77 0 3 1 81 0 4 1 46 0 5 1 89 0 6 1 93 0 7 1 46 0 8 1 46 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 46 0 1 1 46 0 2 1 46 0 3 1 81 0 4 1 46 0 5 1 89 0 6 1 93 0 7 1 46 0 8 1 46 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 46 0 1 1 46 0 2 1 46 0 3 1 46 0 4 1 46 0 5 1 89 0 6 1 93 0 7 1 46 0 8 1 46 0 9 1 46 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 46 0 2 1 77 0 3 1 81 0 4 1 46 0 5 1 89 0 6 1 93 0 7 1 46 0 8 1 46 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[0 1 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[0 1 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[1 1 69 0 1 1 46 0 2 1 77 0 3 1 81 0 4 1 46 0 5 1 89 0 6 1 93 0 7 1 46 0 8 1 46 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 46 0 2 1 77 0 3 1 81 0 4 1 46 0 5 1 89 0 6 1 93 0 7 1 46 0 8 1 46 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 46 0 1 1 46 0 2 1 46 0 3 1 46 0 4 1 46 0 5 1 89 0 6 1 93 0 7 1 46 0 8 1 46 0 9 1 46 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[0 1 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 121 0 14 1 125 0 15 1 46 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 113 0 12 1 46 0 13 1 121 0 14 1 125 0 15 1 46 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 125 0 15 1 46 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 113 0 12 1 117 0 13 1 121 0 14 1 125 0 15 1 46 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[0 1 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 33 0 34 0 35 0 37 0 38 0 46 0 54 0 55 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 46 0 12 1 46 0 13 1 46 0 14 1 46 0 15 1 46 0 16 1 46 0 17 1 46 0 18 1 46 0 19 1 145 0 20 1 46 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[1 1 69 0 1 1 73 0 2 1 77 0 3 1 81 0 4 1 85 0 5 1 89 0 6 1 93 0 7 1 97 0 8 1 101 0 9 1 105 0 10 1 109 0 11 1 113 0 12 1 117 0 13 1 121 0 14 1 125 0 15 1 129 0 16 1 133 0 17 1 137 0 18 1 141 0 19 1 145 0 20 1 149 0 21 1 46 0 25 1 46 0 28 1 46 0 29 1 46 0 33 1 46 0 34 1 46 0 35 1 46 0 37 1 46 0 38 1 46 0 46 1 46 0 54 1 46 0 55 1 46 0 132] 
#[0 1 50 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 3 89 0 38] 
#[0 1 54 0 38] 
#[0 1 58 0 38] 
#[1 1 62 0 34 1 62 0 38 3 93 0 78] 
#[0 3 97 0 29] 
#[0 1 66 0 25 0 29 0 34 0 37 0 38 0 132] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 1 70 0 25 0 29 0 26 0 33 0 27 1 70 0 29 0 37 0 30 0 41 0 32 0 45 0 36 1 70 0 37 1 70 0 38 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 2 237 0 119 0 201 0 127 1 70 0 132 0 205 0 134] 
#[0 1 74 0 25 0 29 0 37 0 38 0 132] 
#[0 1 78 0 25 0 29 0 34 0 37 0 38 0 132] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 6 0 25 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 6 0 37 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 181 0 119 0 185 0 120 3 101 0 123 0 193 0 124 0 201 0 127 0 6 0 132 0 205 0 134] 
#[0 1 82 0 25 0 37 0 132] 
#[1 3 105 0 46 3 109 0 47 3 113 0 106 3 117 0 107 3 121 0 108 3 125 0 109 3 129 0 110] 
#[0 1 86 0 4 0 5 0 10 0 22 0 23 0 24 0 25 0 26 0 27 0 30 0 32 0 36 0 37 0 39 0 41 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53] 
#[0 1 90 0 4 0 5 0 10 0 22 0 23 0 24 0 25 0 26 0 27 0 30 0 32 0 36 0 37 0 39 0 41 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53] 
#[0 3 133 0 25] 
#[0 1 94 0 30 0 47] 
#[0 1 98 0 30 0 47] 
#[1 0 37 0 30 0 69 0 47 3 37 0 84 3 41 0 86 3 137 0 105] 
#[0 1 102 0 12] 
#[0 1 106 0 12 0 28 0 31] 
#[0 1 106 0 12 0 28 0 31] 
#[0 1 110 0 12] 
#[0 1 102 0 12] 
#[0 1 114 0 4 0 5 0 10 0 22 0 23 0 24 0 25 0 26 0 27 0 30 0 32 0 36 0 37 0 39 0 41 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53] 
#[0 1 118 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 18 0 25 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 18 0 37 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 241 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 245 0 67 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 249 0 111 0 253 0 112 3 141 0 113 1 5 0 116 1 9 0 118 0 201 0 127 0 205 0 134] 
#[0 1 122 0 25 0 37] 
#[1 1 237 0 1 1 241 0 2 1 245 0 3 1 249 0 4 1 253 0 5 2 1 0 6 2 5 0 7 2 9 0 8 2 13 0 9 2 17 0 10 2 21 0 11 2 25 0 12 2 29 0 13 2 33 0 14 2 37 0 15 2 41 0 16 2 45 0 17 2 49 0 18 2 53 0 19 2 57 0 20 2 61 0 21 0 41 0 32 3 145 0 38 2 69 0 39 0 57 0 44 0 61 0 45 2 73 0 46 2 77 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 2 81 0 55 2 85 0 89 0 201 0 127 2 89 0 128 2 93 0 129 2 97 0 131] 
#[0 1 126 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 54 0 132] 
#[0 1 130 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 54 0 132] 
#[0 1 134 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 54 0 132] 
#[0 1 130 0 25 0 29 0 33 0 34 0 35 0 37 0 38 0 54 0 132] 
#[0 1 138 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[1 3 149 0 34 1 142 0 38 3 153 0 77] 
#[0 1 146 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 1 150 0 25 0 37 0 132] 
#[1 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 49 0 39 0 57 0 44 0 61 0 45 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 3 157 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 0 201 0 127 0 205 0 134] 
#[0 1 154 0 2] 
#[0 3 161 0 2] 
#[0 1 158 0 2] 
#[0 1 158 0 2] 
#[0 1 162 0 2 0 46] 
#[1 1 166 0 2 3 105 0 46 3 165 0 109] 
#[0 1 170 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 25 0 28 0 29 0 30 0 31 0 33 0 34 0 35 0 37 0 38 0 39 0 40 0 46 0 47 0 54 0 55 0 132] 
#[0 1 174 0 12 0 28 0 31] 
#[0 1 178 0 25 0 37] 
#[0 1 182 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 32 0 38 0 39 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 55] 
#[1 0 9 0 4 0 13 0 10 0 17 0 22 0 21 0 23 0 25 0 24 0 29 0 26 0 33 0 27 0 37 0 30 0 41 0 32 0 45 0 36 0 49 0 39 0 53 0 41 0 57 0 44 0 61 0 45 0 65 0 46 0 69 0 47 0 73 0 48 0 77 0 49 0 81 0 50 0 85 0 51 0 89 0 52 0 93 0 53 0 97 0 56 0 101 0 57 0 105 0 58 0 109 0 59 0 113 0 60 0 117 0 64 0 121 0 67 0 129 0 70 0 133 0 71 0 137 0 73 0 141 0 74 0 145 0 75 0 149 0 81 0 153 0 82 0 157 0 83 0 161 0 84 0 165 0 85 0 169 0 86 0 173 0 87 0 177 0 89 3 169 0 119 0 201 0 127 0 205 0 134] 
#[0 1 186 0 34 0 38] 
#[0 1 190 0 2 0 46] 
#[0 1 194 0 4 0 5 0 10 0 22 0 23 0 24 0 25 0 26 0 27 0 30 0 32 0 36 0 37 0 39 0 41 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53] 
#[0 1 198 0 2 0 46] 
#[0 1 202 0 34 0 38]
	).
]
