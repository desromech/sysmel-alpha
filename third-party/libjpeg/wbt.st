self platform name selectCase: {
    #linux -> [
        self importLibrary: 'jpeg' fromDebianPackage: 'libjpeg-turbo8-dev'.
    ].
    #osx -> [

    ].
    #windows -> [

    ].
    [true] -> []
}.
