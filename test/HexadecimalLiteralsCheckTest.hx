import haxelint.LintMessage.SeverityLevel;
import haxelint.checks.HexadecimalLiteralsCheck;
import Test.CheckTestCase;

class HexadecimalLiteralsCheckTest extends CheckTestCase {
	function testHexademicalLiterals() {
		var src = "
class A {
	var a = 0xA;
}";

		checkMessages(src,new HexadecimalLiteralsCheck(), []);

		src = "
class A {
	var a = 0xa;
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"HexadecimalLiterals",
		line:3,
		column:11 - 1, // -1 is because now it reports position of whole binop expr
		severity:SeverityLevel.INFO,
		message:"Bad hexademical literal"
		};

		checkMessages(src,new HexadecimalLiteralsCheck(), [message]);
	}
}