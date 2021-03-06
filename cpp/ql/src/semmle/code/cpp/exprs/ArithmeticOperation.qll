import semmle.code.cpp.exprs.Expr

/**
 * A C/C++ unary arithmetic operation.
 *
 * This is an abstract base QL class.
 */
abstract class UnaryArithmeticOperation extends UnaryOperation { }

/**
 * A C/C++ unary minus expression.
 * ```
 * b = - a;
 * ```
 */
class UnaryMinusExpr extends UnaryArithmeticOperation, @arithnegexpr {
  override string getOperator() { result = "-" }

  override string getCanonicalQLClass() { result = "UnaryMinusExpr" }

  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ unary plus expression.
 * ```
 * b = + a;
 * ```
 */
class UnaryPlusExpr extends UnaryArithmeticOperation, @unaryplusexpr {
  override string getOperator() { result = "+" }

  override string getCanonicalQLClass() { result = "UnaryPlusExpr" }

  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ GNU conjugation expression.  It operates on `_Complex` or
 * `__complex__ `numbers, and is similar to the C99 `conj`, `conjf` and `conjl`
 * functions.
 * ```
 * _Complex double a =  ( 1.0, 2.0 );
 * _Complex double b = ~ a;  // ( 1.0, - 2.0 )
 * ```
 */
class ConjugationExpr extends UnaryArithmeticOperation, @conjugation {
  override string getOperator() { result = "~" }

  override string getCanonicalQLClass() { result = "ConjugationExpr" }
}

/**
 * A C/C++ `++` or `--` expression (either prefix or postfix).
 *
 * This is the abstract base QL class for increment and decrement operations.
 *
 * Note that this does not include calls to user-defined `operator++`
 * or `operator--`.
 */
abstract class CrementOperation extends UnaryArithmeticOperation {
  override predicate mayBeImpure() { any() }

  override predicate mayBeGloballyImpure() {
    not exists(VariableAccess va, LocalScopeVariable v |
      va = this.getOperand() and
      v = va.getTarget() and
      not va.getConversion+() instanceof ReferenceDereferenceExpr and
      not v.isStatic()
    )
  }
}

/**
 * A C/C++ `++` expression (either prefix or postfix).
 *
 * Note that this does not include calls to user-defined `operator++`.
 */
abstract class IncrementOperation extends CrementOperation { }

/**
 * A C/C++ `--` expression (either prefix or postfix).
 *
 * Note that this does not include calls to user-defined `operator--`.
 */
abstract class DecrementOperation extends CrementOperation { }

/**
 * A C/C++ `++` or `--` prefix expression.
 *
 * Note that this does not include calls to user-defined operators.
 */
abstract class PrefixCrementOperation extends CrementOperation { }

/**
 * A C/C++ `++` or `--` postfix expression.
 *
 * Note that this does not include calls to user-defined operators.
 */
abstract class PostfixCrementOperation extends CrementOperation { }

/**
 * A C/C++ prefix increment expression, as in `++x`.
 *
 * Note that this does not include calls to user-defined `operator++`.
 * ```
 * b = ++a;
 * ```
 */
class PrefixIncrExpr extends IncrementOperation, PrefixCrementOperation, @preincrexpr {
  override string getOperator() { result = "++" }

  override string getCanonicalQLClass() { result = "PrefixIncrExpr" }

  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ prefix decrement expression, as in `--x`.
 *
 * Note that this does not include calls to user-defined `operator--`.
 * ```
 * b = --a;
 * ```
 */
class PrefixDecrExpr extends DecrementOperation, PrefixCrementOperation, @predecrexpr {
  override string getOperator() { result = "--" }

  override string getCanonicalQLClass() { result = "PrefixDecrExpr" }

  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ postfix increment expression, as in `x++`.
 *
 * Note that this does not include calls to user-defined `operator++`.
 * ```
 * b = a++;
 * ```
 */
class PostfixIncrExpr extends IncrementOperation, PostfixCrementOperation, @postincrexpr {
  override string getOperator() { result = "++" }

  override string getCanonicalQLClass() { result = "PostfixIncrExpr" }

  override int getPrecedence() { result = 16 }

  override string toString() { result = "... " + getOperator() }
}

/**
 * A C/C++ postfix decrement expression, as in `x--`.
 *
 * Note that this does not include calls to user-defined `operator--`.
 * ```
 * b = a--;
 * ```
 */
class PostfixDecrExpr extends DecrementOperation, PostfixCrementOperation, @postdecrexpr {
  override string getOperator() { result = "--" }

  override string getCanonicalQLClass() { result = "PostfixDecrExpr" }

  override int getPrecedence() { result = 16 }

  override string toString() { result = "... " + getOperator() }
}

/**
 * A C/C++ GNU real part expression.  It operates on `_Complex` or
 * `__complex__` numbers.
 * ```
 * _Complex double f = { 2.0, 3.0 };
 * double d = __real(f);  // 2.0
 * ```
 */
class RealPartExpr extends UnaryArithmeticOperation, @realpartexpr {
  override string getOperator() { result = "__real" }

  override string getCanonicalQLClass() { result = "RealPartExpr" }
}

/**
 * A C/C++ GNU imaginary part expression.  It operates on `_Complex` or
 * `__complex__` numbers.
 * ```
 * _Complex double f = { 2.0, 3.0 };
 * double d = __imag(f);  // 3.0
 * ```
 */
class ImaginaryPartExpr extends UnaryArithmeticOperation, @imagpartexpr {
  override string getOperator() { result = "__imag" }

  override string getCanonicalQLClass() { result = "ImaginaryPartExpr" }
}

/**
 * A C/C++ binary arithmetic operation.
 *
 * This is an abstract base QL class for all binary arithmetic operations.
 */
abstract class BinaryArithmeticOperation extends BinaryOperation { }

/**
 * A C/C++ add expression.
 * ```
 * c = a + b;
 * ```
 */
class AddExpr extends BinaryArithmeticOperation, @addexpr {
  override string getOperator() { result = "+" }

  override string getCanonicalQLClass() { result = "AddExpr" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ subtract expression.
 * ```
 * c = a - b;
 * ```
 */
class SubExpr extends BinaryArithmeticOperation, @subexpr {
  override string getOperator() { result = "-" }

  override string getCanonicalQLClass() { result = "SubExpr" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ multiply expression.
 * ```
 * c = a * b;
 * ```
 */
class MulExpr extends BinaryArithmeticOperation, @mulexpr {
  override string getOperator() { result = "*" }

  override string getCanonicalQLClass() { result = "MulExpr" }

  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ divide expression.
 * ```
 * c = a / b;
 * ```
 */
class DivExpr extends BinaryArithmeticOperation, @divexpr {
  override string getOperator() { result = "/" }

  override string getCanonicalQLClass() { result = "DivExpr" }

  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ remainder expression.
 * ```
 * c = a % b;
 * ```
 */
class RemExpr extends BinaryArithmeticOperation, @remexpr {
  override string getOperator() { result = "%" }

  override string getCanonicalQLClass() { result = "RemExpr" }

  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ multiply expression with an imaginary number.  This is specific to
 * C99 and later.
 * ```
 * double z;
 * _Imaginary double x, y;
 * z = x * y;
 * ```
 */
class ImaginaryMulExpr extends BinaryArithmeticOperation, @jmulexpr {
  override string getOperator() { result = "*" }

  override string getCanonicalQLClass() { result = "ImaginaryMulExpr" }

  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ divide expression with an imaginary number.  This is specific to
 * C99 and later.
 * ```
 * double z;
 * _Imaginary double y;
 * z = z / y;
 * ```
 */
class ImaginaryDivExpr extends BinaryArithmeticOperation, @jdivexpr {
  override string getOperator() { result = "/" }

  override string getCanonicalQLClass() { result = "ImaginaryDivExpr" }

  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ add expression with a real term and an imaginary term.  This is
 * specific to C99 and later.
 * ```
 * double z;
 * _Imaginary double x;
 * _Complex double w;
 * w = z + x;
 * ```
 */
class RealImaginaryAddExpr extends BinaryArithmeticOperation, @fjaddexpr {
  override string getOperator() { result = "+" }

  override string getCanonicalQLClass() { result = "RealImaginaryAddExpr" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ add expression with an imaginary term and a real term.  This is
 * specific to C99 and later.
 * ```
 * double z;
 * _Imaginary double x;
 * _Complex double w;
 * w = x + z;
 * ```
 */
class ImaginaryRealAddExpr extends BinaryArithmeticOperation, @jfaddexpr {
  override string getOperator() { result = "+" }

  override string getCanonicalQLClass() { result = "ImaginaryRealAddExpr" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ subtract expression with a real term and an imaginary term.  This is
 * specific to C99 and later.
 * ```
 * double z;
 * _Imaginary double x;
 * _Complex double w;
 * w = z - x;
 * ```
 */
class RealImaginarySubExpr extends BinaryArithmeticOperation, @fjsubexpr {
  override string getOperator() { result = "-" }

  override string getCanonicalQLClass() { result = "RealImaginarySubExpr" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ subtract expression with an imaginary term and a real term.  This is
 * specific to C99 and later.
 * ```
 * double z;
 * _Imaginary double x;
 * _Complex double w;
 * w = x - z;
 * ```
 */
class ImaginaryRealSubExpr extends BinaryArithmeticOperation, @jfsubexpr {
  override string getOperator() { result = "-" }

  override string getCanonicalQLClass() { result = "ImaginaryRealSubExpr" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ GNU min expression.
 * ```
 * c = a <? b;
 * ```
 */
class MinExpr extends BinaryArithmeticOperation, @minexpr {
  override string getOperator() { result = "<?" }

  override string getCanonicalQLClass() { result = "MinExpr" }
}

/**
 * A C/C++ GNU max expression.
 * ```
 * c = a >? b;
 * ```
 */
class MaxExpr extends BinaryArithmeticOperation, @maxexpr {
  override string getOperator() { result = ">?" }

  override string getCanonicalQLClass() { result = "MaxExpr" }
}

/**
 * A C/C++ pointer arithmetic operation.
 */
abstract class PointerArithmeticOperation extends BinaryArithmeticOperation { }

/**
 * A C/C++ pointer add expression.
 * ```
 * foo *ptr = &f[0];
 * ptr = ptr + 2;
 * ```
 */
class PointerAddExpr extends PointerArithmeticOperation, @paddexpr {
  override string getOperator() { result = "+" }

  override string getCanonicalQLClass() { result = "PointerAddExpr" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ pointer subtract expression.
 * ```
 * foo *ptr = &f[3];
 * ptr = ptr - 2;
 * ```
 */
class PointerSubExpr extends PointerArithmeticOperation, @psubexpr {
  override string getOperator() { result = "-" }

  override string getCanonicalQLClass() { result = "PointerSubExpr" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ pointer difference expression.
 * ```
 * foo *start = &f[0], *end = &f[4];
 * int size = end - size;
 * ```
 */
class PointerDiffExpr extends PointerArithmeticOperation, @pdiffexpr {
  override string getOperator() { result = "-" }

  override string getCanonicalQLClass() { result = "PointerDiffExpr" }

  override int getPrecedence() { result = 12 }
}
