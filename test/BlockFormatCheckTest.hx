import haxelint.LintMessage.SeverityLevel;
import haxelint.checks.BlockFormatCheck;
import Test.CheckTestCase;

class BlockFormatCheckTest extends CheckTestCase {
	function testShortEmptyBlock() {
		var src = "
class A {
	var a = {};
	var b = {a:1, c:{}};
	var d = {
		a:1
	};
	function f() {}
}";

		checkMessages(src,new BlockFormatCheck(), []);

		src = "
class A {
	var a = { };
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"ShortEmptyBlock",
		line:3,
		column:10,
		severity:SeverityLevel.INFO,
		message:"Empty block should be written as {}"
		};

		checkMessages(src,new BlockFormatCheck(), [message]);

		src = "
class A {
	var b = {\n};
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"ShortEmptyBlock",
		line:3,
		column:10,
		severity:SeverityLevel.INFO,
		message:"Empty block should be written as {}"
		};

		checkMessages(src,new BlockFormatCheck(), [message]);

		src = "
class A {
	function f() { }
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"ShortEmptyBlock",
		line:3,
		column:15,
		severity:SeverityLevel.INFO,
		message:"Empty block should be written as {}"
		};

		checkMessages(src,new BlockFormatCheck(), [message]);

		src = "
class A {
	function g() {\n}
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"ShortEmptyBlock",
		line:3,
		column:15,
		severity:SeverityLevel.INFO,
		message:"Empty block should be written as {}"
		};

		checkMessages(src,new BlockFormatCheck(), [message]);

		src = "
class A {
	var a = {a:1
	};
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"ShortEmptyBlock",
		line:3,
		column:10,
		severity:SeverityLevel.INFO,
		message:"First line of multiline block should contain only `{'"
		};

		checkMessages(src,new BlockFormatCheck(), [message]);
	}
}