package haxelint.checks;

import haxelint.LintMessage.SeverityLevel;

@name("ShortEmptyBlock")
class ShortEmptyBlockCheck extends Check {
	public function new(){
		super();
	}

	override function actualRun() {
		ExprUtils.walkFile(_checker.ast, function(e){
			switch(e.expr){
			case EBlock([]) | EObjectDecl([]):
				if (e.pos.max - e.pos.min > "{}".length)
					logPos("Empty block should be written as {}", e.pos, SeverityLevel.INFO);
			default:
			}
		});
	}
}
