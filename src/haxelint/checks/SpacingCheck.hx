package haxelint.checks;

import haxe.macro.Printer;
import haxe.macro.Expr.Binop;
import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

@name("Spacing")
class SpacingCheck extends Check {
	public function new(){
		super();
	}

	public var spaceAroundBinop = true;
	public var spaceIfCondition = true;

	override function actualRun() {
		var lastExpr = null;

		Utils.walkFile(_checker.ast,function(e){
			if (lastExpr == null){
				lastExpr = e;
				return;
			}

			switch e.expr {
			case EBinop(bo,l,r) if (spaceAroundBinop):
				if (r.pos.min - l.pos.max < opSize(bo)+2) logPos('No space around ${opString(bo)}', e.pos, INFO);
			case EIf(econd,eif,eelse) if (spaceIfCondition):
				if (econd.pos.min - e.pos.min < "if (".length) logPos('No space between `if\' and condition', e.pos, INFO);
				if (eif.pos.min - econd.pos.max < ") ".length) logPos('No space between `if\' and condition', e.pos, INFO);
			default:
			}

			lastExpr = e;
		});
	}

	function opSize(bo:Binop){
		return opString(bo).length;
	}

	function opString(bo:Binop){
		return (new Printer()).printBinop(bo);
	}
}
