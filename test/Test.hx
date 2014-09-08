import haxelint.checks.IndentationCharacterCheck;
import haxelint.checks.NamingCheck;
import haxelint.checks.SpacingCheck;
import haxelint.LintMessage;
import haxelint.LintFile;
import haxelint.reporter.IReporter;
import haxelint.Checker;

class TestReporter implements IReporter{
	public function new() {
		messages = [];
	}

	public function start():Void {
	}

	public function finish():Void {
	}

	public function fileStart(f:LintFile):Void {
	}

	public function fileFinish(f:LintFile):Void {
	}

	public var messages:Array<LintMessage>;

	public function addMessage(m:LintMessage):Void {
		messages.push(m);
	}
}

class Test extends haxe.unit.TestCase {
	static inline var FILE_NAME = "LintTest.hx";

	static function main() {
		var r = new haxe.unit.TestRunner();
		r.add(new Test());
		var success = r.run();
		Sys.exit(success?0:1);
	}

	function testIndentaionOnEmptyLines() {
		//Use show whitespace on this test

		var src = "
class A {
//no whitespace here\n
}";


		checkMessages(src,new IndentationCharacterCheck(), []);

		src = "
class A {
//tabs here\n\t\t
}";

		checkMessages(src,new IndentationCharacterCheck(), []);

		src = "
class A {
//spaces here\n        \n
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"IndentationCharacter",
		line:4,
		column:1,
		severity:INFO,
		message:"Wrong indentation character"
		};

		checkMessages(src,new IndentationCharacterCheck(), [message]);
	}

	function testSpacingAroundBinOp() {
		var src = "
class A {
	function f(){
		a=b;
	}
}";

		var message = {
			fileName:FILE_NAME,
			moduleName:"Spacing",
			line:4,
			column:4 - 1, // -1 is because now it reports position of whole binop expr
			severity:INFO,
			message:"No space around ="
		};

		checkMessages(src,new SpacingCheck(), [message]);
	}

	function testVariableCasing() {
		var src = "
class A {
	public function f(){
		var Abc;
	}
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"Naming",
		line:4,
		column:3,
		severity:INFO,
		message:"Invalid casing of variable Abc"
		};

		checkMessages(src,new NamingCheck(), [message]);
	}

	function testFieldVariableCasing() {
		var src = "
class A {
	public var Abc:Int;
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"Naming",
		line:3,
		column:9,
		severity:INFO,
		message:"Invalid casing of variable Abc"
		};

		checkMessages(src,new NamingCheck(), [message]);
	}

	function testInlineFieldVariableCasing() {
		var src = "
class A {
	static inline var abc:Int;
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"Naming",
		line:3,
		column:16, // haxeparser skips position of field flags
		severity:INFO,
		message:"Invalid casing of variable abc"
		};

		checkMessages(src,new NamingCheck(), [message]);
	}

	function testPrivateFieldVariableCasing() {
		var src = "
class A {
	var abc:Int;
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"Naming",
		line:3,
		column:2, // haxeparser skips position of field flags
		severity:INFO,
		message:"Invalid casing of private field abc"
		};

		checkMessages(src,new NamingCheck(), [message]);
	}

	function messageEquals(expected:LintMessage,actual:LintMessage){
		assertEquals(expected.fileName,   actual.fileName);
		assertEquals(expected.moduleName, actual.moduleName);
		assertEquals(expected.line,       actual.line);
		assertEquals(expected.column,     actual.column);
		assertEquals(expected.severity,   actual.severity);
		assertEquals(expected.message,    actual.message);
	}

	function checkMessages(src,check,expected:Array<LintMessage>){
		var checker = new Checker();
		var reporter = new TestReporter();
		checker.addCheck(check);
		checker.addReporter(reporter);
		checker.process([{name:FILE_NAME,content:src}]);
		assertEquals(expected.length,reporter.messages.length);
		for (i in 0 ... expected.length)
			messageEquals(expected[i],reporter.messages[i]);
	}
}