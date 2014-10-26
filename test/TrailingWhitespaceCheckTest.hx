import haxelint.LintMessage.SeverityLevel;
import haxelint.checks.TrailingWhitespaceCheck;
import Test.CheckTestCase;

class TrailingWhitespaceCheckTest extends CheckTestCase {
	function testTrailingWhitespace() {
		var src = "
class A {
	var _a:Int = 0;\n
}";

		checkMessages(src, new TrailingWhitespaceCheck(), []);

		var src = "\r
class A {\r
	var _a:Int = 0;\r
}";

		checkMessages(src, new TrailingWhitespaceCheck(), []);

		src = "
class A {
	var _a:Int = 0;   \n
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"TrailingWhitespace",
		line:3,
		column:19, // -1 is because now it reports position of whole binop expr
		severity:INFO,
		message:"Trailing whitespace"
		};

		checkMessages(src,new TrailingWhitespaceCheck(), [message]);

		src = "
class A {
	var _a:Int = 0;\t\n
}";

		message = {
		fileName:FILE_NAME,
		moduleName:"TrailingWhitespace",
		line:3,
		column:17, // -1 is because now it reports position of whole binop expr
		severity:INFO,
		message:"Trailing whitespace"
		};

		checkMessages(src,new TrailingWhitespaceCheck(), [message]);
	}
}