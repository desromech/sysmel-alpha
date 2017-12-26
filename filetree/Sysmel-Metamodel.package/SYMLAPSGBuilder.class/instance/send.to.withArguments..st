builder methods
send: selector to: aReceiver withArguments: arguments
	<compileTime>
	<compileTime>
	^ SYMLAPSGMessageSend new
		selector: selector;
		receiver: aReceiver;
		arguments: arguments;
		yourself
		