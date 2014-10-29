import haxelint.LintMessage.SeverityLevel;
import haxelint.checks.ShortEmptyBlockCheck;
import Test.CheckTestCase;

class ShortEmptyBlockCheckTest extends CheckTestCase {
	function testShortEmptyBlock() {
		var src = "
class A {
	var a = {};
	var b = {a:1, c:{}};
	function f() {}
}";

		checkMessages(src,new ShortEmptyBlockCheck(), []);

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

		checkMessages(src,new ShortEmptyBlockCheck(), [message]);

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

		checkMessages(src,new ShortEmptyBlockCheck(), [message]);

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

		checkMessages(src,new ShortEmptyBlockCheck(), [message]);

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

		checkMessages(src,new ShortEmptyBlockCheck(), [message]);
	}
}