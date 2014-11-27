import haxelint.LintMessage.SeverityLevel;
import haxelint.LintMessage.SeverityLevel;
import haxelint.checks.EmptyLinesCheck;
import Test.CheckTestCase;

class EmptyLinesCheckTest extends CheckTestCase {
	function testConsecutiveEmptyLines() {
		var src = "
class A {
var a;
var b;
\t\t
var c;
}";

		checkMessages(src, new EmptyLinesCheck(), []);

		var src = "
class A {
var a;
\t\t
\t\t  \t
var b;
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"EmptyLines",
		line:3,
		column:0,
		severity:SeverityLevel.INFO,
		message:"Too many consecutive empty lines"
		};

		checkMessages(src, new EmptyLinesCheck(), [message]);
	}
}