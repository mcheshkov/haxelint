import haxelint.ChecksInfo;
import haxelint.LintMessage.SeverityLevel;
import haxelint.checks.HexademicalLiteralsCheck;
import Test.CheckTestCase;

class ChecksInfoTest extends haxe.unit.TestCase {
	function testChecksInfo() {
		//should at least construct
		var info:ChecksInfo = new ChecksInfo();
		assertTrue(info != null);
	}
}