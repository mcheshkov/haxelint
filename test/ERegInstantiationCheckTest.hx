import haxelint.checks.ERegInstantiationCheck;
import haxelint.LintMessage.SeverityLevel;
import Test.CheckTestCase;

class ERegInstantiationCheckTest extends CheckTestCase {
	function testArrayInstantiation() {
		var src = "
class A {
	var a = ~//;
}";

		checkMessages(src,new ERegInstantiationCheck(), []);

		src = "
class A {
	var a = new EReg(\"\",\"\");
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"ERegInstantiation",
		line:3,
		column:11 - 1, // -1 is because now it reports position of whole binop expr
		severity:SeverityLevel.WARNING,
		message:"Bad EReg instantiation"
		};

		checkMessages(src,new ERegInstantiationCheck(), [message]);
	}
}