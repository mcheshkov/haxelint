import haxelint.LintMessage.SeverityLevel;
import haxelint.checks.IndentationCharacterCheck;
import Test.CheckTestCase;

class IndentationCharacterCheckTest extends CheckTestCase {
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

	function testIndentaion() {
//Use show whitespace on this test

		var src = "
class A {
//no whitespace here\nvar a;\n
}";


		checkMessages(src,new IndentationCharacterCheck(), []);

		src = "
class A {
//tabs here\n\t\tvar a;\n
}";

		checkMessages(src,new IndentationCharacterCheck(), []);

		src = "
class A {
//spaces here\n        var a;\n
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

		src = "
class A {
//spaces here\n\t\t  \t  var a;\n
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
}