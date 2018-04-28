#!/usr/bin/python
import sys
import json
import os.path
import subprocess

BaseDirectory = os.getcwd()
CompilerCommandName = 'sysmelc'
CompilerCommand = os.path.join(BaseDirectory, CompilerCommandName)

def toAbsolutePath(path):
    if os.path.isabs(path):
        return path
    return os.path.join(BaseDirectory, path)

def runCommand(commandWithArguments):
    process = subprocess.Popen(commandWithArguments, bufsize=-1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdoutdata, stderrdata = process.communicate()
    exitcode = process.returncode
    return exitcode, stdoutdata, stderrdata

def compilerRun(arguments):
    allArguments = [CompilerCommand] + arguments
    return runCommand(allArguments)

def compilerEval(arguments, string):
    return compilerRun(arguments + ['-eval', string])

def beginTestSuite(name):
    print 'Test suite', name

def beginTestCase(name):
    print 'Test case %s... ' % (name),

def testCaseError(errorCode, errorMessage):
    print 'ERROR. Result Code %d' % errorCode
    print errorMessage

def testCaseSuccess():
    print 'OK'

def testCaseFailure(expected, obtained):
    print 'FAILURE'
    print 'Expected: %s Got: %s' % (expected, obtained)

class TestSettings:
    def __init__(self):
        self.name = 'Unnamed'
        self.arguments = []
        self.cases = []

    def loadFrom(self, filename):
        with open(filename, 'rb') as f:
            data = json.load(f)

        self.name = data.get('name', self.name)
        self.arguments = data.get('arguments', self.arguments)
        self.cases = data.get('cases', self.cases)
        return self

class TestActionEval:
    def __init__(self, testCase, evaluatedString):
        self.testCase = testCase
        self.evaluatedString = evaluatedString

    def run(self):
        return compilerEval(self.testCase.testSuite.settings.arguments, self.evaluatedString)

class TestCase:
    def __init__(self, testSuite):
        self.name = "Unnamed"
        self.testSuite = testSuite

    def loadFromJson(self, json):
        self.name = json.get('name', self.name)
        self.expected = json.get('expected', '')
        if 'eval' in json:
            self.action = TestActionEval(self, json['eval'])

        return self

    def run(self):
        beginTestCase(self.name)
        resultCode, resultOutput, resultError = self.action.run()
        if resultCode != 0:
            testCaseError(resultCode, resultError)
        else:
            result = resultOutput.strip()
            if result == self.expected:
                testCaseSuccess()
            else:
                testCaseFailure(self.expected, result)

class TestSuite:
    def __init__(self, directory):
        self.directory = toAbsolutePath(directory)
        self.settings = TestSettings().loadFrom(os.path.join(self.directory, "suite.json"))
        self.cases = map(lambda x: TestCase(self).loadFromJson(x), self.settings.cases)

    def run(self):
        beginTestSuite(self.settings.name)
        for case in self.cases:
            case.run()

def runTestSuites(directories):
    for directory in directories:
        TestSuite(directory).run()

if __name__ == "__main__":
    BaseDirectory = os.path.dirname(sys.argv[0])
    CompilerCommand = os.path.join(os.path.join(BaseDirectory, '..'), CompilerCommandName)

    runTestSuites([
        "sysmel/bootstrap-env",
        "sysmel/kernel",
        "sysmel/runtime",
    ])
