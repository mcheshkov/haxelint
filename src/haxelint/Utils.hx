package haxelint;

import haxe.macro.Expr;

class Utils {

	static function walkTypePath(tp:TypePath, cb:Expr -> Void) {
		if (tp.params != null) {
			for (p in tp.params) {
				switch(p){
					case TPType(t): walkComplexType(t, cb);
					case TPExpr(e): walkExpr(e, cb);
				}
			}
		}
	}

	static function walkVar(v:Var, cb:Expr -> Void) {
		if (v.type != null) walkComplexType(v.type, cb);
		if (v.expr != null) walkExpr(v.expr, cb);
	}

	static function walkTypeParamDecl(tp:TypeParamDecl, cb:Expr -> Void) {
		if (tp.constraints != null) {
			for (c in tp.constraints) walkComplexType(c, cb);
		}
		if (tp.params != null) {
			for (t in tp.params) walkTypeParamDecl(t, cb);
		}
	}

	static function walkFunction(f:Function, cb:Expr -> Void) {
		for (a in f.args) {
			if (a.type != null) walkComplexType(a.type, cb);
			if (a.value != null) walkExpr(a.value, cb);
		}
		if (f.ret != null) walkComplexType(f.ret, cb);
		if (f.expr != null) walkExpr(f.expr, cb);
		if (f.params != null) {
			for (tp in f.params) {
				walkTypeParamDecl(tp, cb);
			}
		}
	}

	static function walkCase(c:Case, cb:Expr -> Void) {
		for (v in c.values) {
			walkExpr(v, cb);
		}
		if (c.guard != null) walkExpr(c.guard, cb);
		if (c.expr != null) walkExpr(c.expr, cb);
	}

	static function walkCatch(c:Catch, cb:Expr -> Void) {
		walkComplexType(c.type, cb);
		walkExpr(c.expr, cb);
	}

	static function walkField(f:Field, cb:Expr -> Void) {
		switch(f.kind){
			case FVar(t, e):
				if (t != null) walkComplexType(t, cb);
				if (e != null) walkExpr(e, cb);
			case FFun(f):
				walkFunction(f, cb);
			case FProp(get, set, t, e):
				if (t != null) walkComplexType(t, cb);
				if (e != null) walkExpr(e, cb);
		}
	}

	static function walkComplexType(t:ComplexType, cb:Expr -> Void) {
		switch(t){
			case TPath(p): walkTypePath(p, cb);
			case TFunction(args, ret):
				for (a in args) walkComplexType(a, cb);
				walkComplexType(ret, cb);
			case TAnonymous(fields):
				for (f in fields) walkField(f, cb);
			case TParent(t):
				walkComplexType(t, cb);
			case TExtend(p, fields):
				for (tp in p) walkTypePath(tp, cb);
				for (f in fields) walkField(f, cb);
			case TOptional(t):
				walkComplexType(t, cb);
		}
	}

	static function walkExpr(e:Expr, cb:Expr -> Void) {
		cb(e);

		switch(e.expr){
			case EConst(c):
			case EArray(e1, e2): walkExpr(e1, cb); walkExpr(e2, cb);
			case EBinop(op, e1, e2): walkExpr(e1, cb); walkExpr(e2, cb);
			case EField(e, field): walkExpr(e, cb);
			case EParenthesis(e): walkExpr(e, cb);
			case EObjectDecl(fields):
				for (f in fields) {
					walkExpr(f.expr, cb);
				}
			case EArrayDecl(values):
				for (v in values) {
					walkExpr(v, cb);
				}
			case ECall(e, params):
				walkExpr(e, cb);
				for (p in params) {
					walkExpr(p, cb);
				}
			case ENew(t, params):
				walkTypePath(t, cb);
				for (p in params) {
					walkExpr(p, cb);
				}
			case EUnop(op, postFix, e): walkExpr(e, cb);
			case EVars(vars):
				for (v in vars) {
					walkVar(v, cb);
				}
			case EFunction(name, f): walkFunction(f, cb);
			case EBlock(exprs):
				for (e in exprs) {
					walkExpr(e, cb);
				}
			case EFor(it, expr): walkExpr(it, cb); walkExpr(expr, cb);
			case EIn(e1, e2): walkExpr(e1, cb); walkExpr(e2, cb);
			case EIf(econd, eif, eelse):
				walkExpr(econd, cb);
				walkExpr(eif, cb);
				if (eelse != null) walkExpr(eelse, cb);
			case EWhile(econd, e, normalWhile): walkExpr(econd, cb); walkExpr(e, cb);
			case ESwitch(e, cases, edef):
				walkExpr(e, cb);
				for (c in cases) walkCase(c, cb);
				if (edef != null) walkExpr(edef, cb);
			case ETry(e, catches):
				walkExpr(e, cb);
				for (c in catches) walkCatch(c, cb);
			case EReturn(e):
				if (e != null) walkExpr(e, cb);
			case EBreak:
			case EContinue:
			case EUntyped(e): walkExpr(e, cb);
			case EThrow(e): walkExpr(e, cb);
			case ECast(e, t):
				walkExpr(e, cb);
				if (t != null) walkComplexType(t, cb);
			case EDisplay(e, isCall): walkExpr(e, cb);
			case EDisplayNew(t): walkTypePath(t, cb);
			case ETernary(econd, eif, eelse):
				walkExpr(econd, cb);
				walkExpr(eif, cb);
				walkExpr(eelse, cb);
			case ECheckType(e, t):
				walkExpr(e, cb);
				walkComplexType(t, cb);
			case EMeta(s, e):
				if (s.params != null) {
					for (mp in s.params) walkExpr(mp, cb);
				}
				walkExpr(e, cb);
		}
	}

}
