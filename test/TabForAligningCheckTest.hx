import haxelint.LintMessage.SeverityLevel;
import haxelint.checks.TabForAligningCheck;
import Test.CheckTestCase;

class TabForAligningCheckTest extends CheckTestCase {
	function testTabAligning() {
		var src = "
class A {
\tvar _a:Int =0;
}";

		checkMessages(src, new TabForAligningCheck(), []);

		src = "
class A {
\tvar _a:Int\t= 0;
}";

		var message = {
		fileName:FILE_NAME,
		moduleName:"TabForAligning",
		line:3,
		column:16,
		severity:SeverityLevel.INFO,
		message:"Tab after non-space character. Use space for aligning"
		};

		checkMessages(src,new TabForAligningCheck(), [message]);
	}
}