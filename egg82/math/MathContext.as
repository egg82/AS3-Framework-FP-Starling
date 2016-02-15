package egg82.math {
    /* ------------------------------------------------------------------ */
    /* MathContext -- Math context settings */
    /* ------------------------------------------------------------------ */
    /* Copyright IBM Corporation, 1997, 2000, 2005. All Rights Reserved. */
    /* */
    /* The MathContext object encapsulates the settings used by the */
    /* BigDecimal class; it could also be used by other arithmetics. */
    /* ------------------------------------------------------------------ */
    /* Notes: */
    /* */
    /* 1. The properties are checked for validity on construction, so */
    /* the BigDecimal class may assume that they are correct. */
    /* ------------------------------------------------------------------ */
    /* Author: Mike Cowlishaw */
    /* 1997.09.03 Initial version (edited from netrexx.lang.RexxSet) */
    /* 1997.09.12 Add lostDigits property */
    /* 1998.05.02 Make the class immutable and final; drop set methods */
    /* 1998.06.05 Add Round (rounding modes) property */
    /* 1998.06.25 Rename from DecimalContext; allow digits=0 */
    /* 1998.10.12 change to com.ibm.icu.math package */
    /* 1999.02.06 add javadoc comments */
    /* 1999.03.05 simplify; changes from discussion with J. Bloch */
    /* 1999.03.13 1.00 release to IBM Centre for Java Technology */
    /* 1999.07.10 1.04 flag serialization unused */
    /* 2000.01.01 1.06 copyright update */
    /* ------------------------------------------------------------------ */
	
    public class MathContext {
        public static const NOTATION_PLAIN:int = 0;
        public static const NOTATION_SCIENTIFIC:int = 1;
        public static const NOTATION_ENGINEERING:int = 2;
        public static const ROUND_CEILING:int = 2;
        public static const ROUND_DOWN:int = 1;
        public static const ROUND_FLOOR:int = 3;
        public static const ROUND_HALF_DOWN:int = 5;
        public static const ROUND_HALF_EVEN:int = 6;
        public static const ROUND_HALF_UP:int = 4;
        public static const ROUND_UNNECESSARY:int = 7;
        public static const ROUND_UP:int = 0;
        
        internal var digits:int;
        internal var form:int;
        internal var lostDigits:Boolean;
        internal var roundingMode:int;
        
        private static const DEFAULT_FORM:int = NOTATION_SCIENTIFIC;
        private static const DEFAULT_DIGITS:int = 9;
        private static const DEFAULT_LOSTDIGITS:Boolean = false;
        private static const DEFAULT_ROUNDINGMODE:int = ROUND_HALF_UP;
		
        private static const MIN_DIGITS:int = 0;
        private static const MAX_DIGITS:int = 999999999;
		
        private static const ROUNDS:Array = [ROUND_HALF_UP,ROUND_UNNECESSARY,ROUND_CEILING,ROUND_DOWN,ROUND_FLOOR,ROUND_HALF_DOWN,ROUND_HALF_EVEN,ROUND_UP];
        private static const ROUNDWORDS:Array = ["ROUND_HALF_UP", "ROUND_UNNECESSARY", "ROUND_CEILING", "ROUND_DOWN", "ROUND_FLOOR", "ROUND_HALF_DOWN", "ROUND_HALF_EVEN", "ROUND_UP"];
		
        public static const DEFAULT:MathContext = new MathContext(DEFAULT_DIGITS,DEFAULT_FORM,DEFAULT_LOSTDIGITS,DEFAULT_ROUNDINGMODE);
        public static const PLAIN:MathContext = new MathContext(0,NOTATION_PLAIN);
        
        public function MathContext(setdigits:int, setform:int = DEFAULT_FORM, setlostdigits:Boolean = DEFAULT_LOSTDIGITS, setroundingmode:int = DEFAULT_ROUNDINGMODE) {
            if (setdigits!=DEFAULT_DIGITS) {
                if (setdigits<MIN_DIGITS) {
                    throw new Error("Digits too small:"+" "+setdigits);
                }
                if (setdigits>MAX_DIGITS) {
                    throw new Error("Digits too large:"+" "+setdigits);
                }
            }

            {
                if (setform==NOTATION_SCIENTIFIC) {
                    // [most common]
                } else if (setform==NOTATION_ENGINEERING) {
                } else if (setform==NOTATION_PLAIN) {
                } else {
                    throw new Error("Bad form value:"+" "+setform);
                }
            }
            
            if ((!(isValidRound(setroundingmode)))) {
                throw new Error("Bad roundingMode value:"+" "+setroundingmode);
            }
            
            digits=setdigits;
            form=setform;
            lostDigits=setlostdigits;
            roundingMode=setroundingmode;
        }
		
        public function getDigits():int {
            return digits;
        }
        
        public function getForm():int {
            return form;
        }
        
        public function getLostDigits():Boolean {
            return lostDigits;
        }
        
        public function getRoundingMode():int {
            return roundingMode;
        }
        
        public function toString():String {
            var formstr:String = null;
            var r:int = 0;
            
            var roundword:String = null;
            
            {
                if (form==NOTATION_SCIENTIFIC) {
                    formstr="SCIENTIFIC";
                } else if (form==NOTATION_ENGINEERING) {
                    formstr="ENGINEERING";
                } else{
                    formstr="PLAIN";
                }
            }
            
            {
            
                var one:int = ROUNDS.length;
                r = 0;
                
                for(; one > 0; one--, r++){
                    if (roundingMode==ROUNDS[r]) {
                        roundword=ROUNDWORDS[r];
                        break;
                    }
                }
            }
            
            return "digits="+digits+" "+"form="+formstr+" "+"lostDigits="+(lostDigits?"1":"0")+" "+"roundingMode="+roundword;
        }
        
        private static function isValidRound(testround:int):Boolean {
            var r:int = 0;
            
            {
                var two:int = ROUNDS.length;
                r=0;
                for(; two > 0; two--,r++){
                    if (testround==ROUNDS[r]) {
                        return true;
                    }
                }
            }
            
            return false;
        }
    }
}