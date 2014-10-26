import haxelint.ChecksInfo;

class ChecksInfoTest extends haxe.unit.TestCase {
	function testChecksInfo() {
		//should at least construct
		var info:ChecksInfo = new ChecksInfo();
		assertTrue(info != null);
	}
}