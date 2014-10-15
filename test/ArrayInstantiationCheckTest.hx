import haxelint.checks.ArrayInstantiationCheck;
import haxelint.LintMessage.SeverityLevel;
import Test.CheckTestCase;

class ArrayInstantiationCheckTest extends CheckTestCase {
	function testArrayInstantiation() {
		var src = "
class A {
	var a = [];
}";

		checkMessages(src,new ArrayInstantiationCheck(), []);

		src = "
class A {
	var a = new Array<Int>();
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"ArrayInstantiation",
		line:3,
		column:11 - 1, // -1 is because now it reports position of whole binop expr
		severity:SeverityLevel.WARNING,
		message:"Bad array instantiation"
		};

		checkMessages(src,new ArrayInstantiationCheck(), [message]);
	}
}