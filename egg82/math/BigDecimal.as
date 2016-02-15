package egg82.math {
    //##header 1189099963000 FOUNDATION
    /* Generated from 'BigDecimal.nrx' 8 Sep 2000 11:10:50 [v2.00] */
    /* Options: Binary Comments Crossref Format Java Logo Strictargs Strictcase Trace2 Verbose3 */

    /* ------------------------------------------------------------------ */
    /* BigDecimal -- Decimal arithmetic for Java */
    /* ------------------------------------------------------------------ */
    /* Copyright IBM Corporation, 1996-2006. All Rights Reserved. */
    /* */
    /* The BigDecimal class provides immutable arbitrary-precision */
    /* floating point (including integer) decimal numbers. */
    /* */
    /* As the numbers are decimal, there is an exact correspondence */
    /* between an instance of a BigDecimal object and its String */
    /* representation; the BigDecimal class provides direct conversions */
    /* to and from String and character array objects, and well as */
    /* conversions to and from the Java primitive types (which may not */
    /* be exact). */
    /* ------------------------------------------------------------------ */
    /* Notes: */
    /* */
    /* 1. A BigDecimal object is never changed in value once constructed; */
    /* this avoids the need for locking. Note in particular that the */
    /* mantissa array may be shared between many BigDecimal objects, */
    /* so that once exposed it must not be altered. */
    /* */
    /* 2. This class looks at MathContext class fields directly (for */
    /* performance). It must not and does not change them. */
    /* */
    /* 3. Exponent checking is delayed until finish(), as we know */
    /* intermediate calculations cannot cause 31-bit overflow. */
    /* [This assertion depends on MAX_DIGITS in MathContext.] */
    /* */
    /* 4. Comments for the public API now follow the javadoc conventions. */
    /* The NetRexx -comments option is used to pass these comments */
    /* through to the generated Java code (with -format, if desired). */
    /* */
    /* 5. System.arraycopy is faster than explicit loop as follows */
    /* Mean length 4: equal */
    /* Mean length 8: x2 */
    /* Mean length 16: x3 */
    /* Mean length 24: x4 */
    /* From prior experience, we expect mean length a little below 8, */
    /* but arraycopy is still the one to use, in general, until later */
    /* measurements suggest otherwise. */
    /* */
    /* 6. 'DMSRCN' referred to below is the original (1981) IBM S/370 */
    /* assembler code implementation of the algorithms below; it is */
    /* now called IXXRCN and is available with the OS/390 and VM/ESA */
    /* operating systems. */
    /* ------------------------------------------------------------------ */
    /* Change History: */
    /* 1997.09.02 Initial version (derived from netrexx.lang classes) */
    /* 1997.09.12 Add lostDigits checking */
    /* 1997.10.06 Change mantissa to a byte array */
    /* 1997.11.22 Rework power [did not prepare arguments, etc.] */
    /* 1997.12.13 multiply did not prepare arguments */
    /* 1997.12.14 add did not prepare and align arguments correctly */
    /* 1998.05.02 0.07 packaging changes suggested by Sun and Oracle */
    /* 1998.05.21 adjust remainder operator finalization */
    /* 1998.06.04 rework to pass MathContext to finish() and round() */
    /* 1998.06.06 change format to use round(); support rounding modes */
    /* 1998.06.25 rename to BigDecimal and begin merge */
    /* zero can now have trailing zeros (i.e., exp\=0) */
    /* 1998.06.28 new methods: movePointXxxx, scale, toBigInteger */
    /* unscaledValue, valueof */
    /* 1998.07.01 improve byteaddsub to allow array reuse, etc. */
    /* 1998.07.01 make null testing explicit to avoid JIT bug [Win32] */
    /* 1998.07.07 scaled division [divide(BigDecimal, int, int)] */
    /* 1998.07.08 setScale, faster equals */
    /* 1998.07.11 allow 1E6 (no sign) <sigh>; new double/float conversion */
    /* 1998.10.12 change package to com.ibm.icu.math */
    /* 1998.12.14 power operator no longer rounds RHS [to match ANSI] */
    /* add toBigDecimal() and BigDecimal(java.math.BigDecimal) */
    /* 1998.12.29 improve byteaddsub by using table lookup */
    /* 1999.02.04 lostdigits=0 behaviour rounds instead of digits+1 guard */
    /* 1999.02.05 cleaner code for BigDecimal(char[]) */
    /* 1999.02.06 add javadoc comments */
    /* 1999.02.11 format() changed from 7 to 2 method form */
    /* 1999.03.05 null pointer checking is no longer explicit */
    /* 1999.03.05 simplify; changes from discussion with J. Bloch: */
    /* null no longer permitted for MathContext; drop Boolean, */
    /* byte, char, float, short constructor, deprecate double */
    /* constructor, no blanks in string constructor, add */
    /* offset and length version of char[] constructor; */
    /* add valueOf(double); drop BooleanValue, charValue; */
    /* add ...Exact versions of remaining convertors */
    /* 1999.03.13 add toBigIntegerExact */
    /* 1999.03.13 1.00 release to IBM Centre for Java Technology */
    /* 1999.05.27 1.01 correct 0-0.2 bug under scaled arithmetic */
    /* 1999.06.29 1.02 constructors should not allow exponent > 9 digits */
    /* 1999.07.03 1.03 lost digits should not be checked if digits=0 */
    /* 1999.07.06 lost digits Exception message changed */
    /* 1999.07.10 1.04 more work on 0-0.2 (scaled arithmetic) */
    /* 1999.07.17 improve messages from pow method */
    /* 1999.08.08 performance tweaks */
    /* 1999.08.15 fastpath in multiply */
    /* 1999.11.05 1.05 fix problem in intValueExact [e.g., 5555555555] */
    /* 1999.12.22 1.06 remove multiply fastpath, and improve performance */
    /* 2000.01.01 copyright update [Y2K has arrived] */
    /* 2000.06.18 1.08 no longer deprecate BigDecimal(double) */
    /* ------------------------------------------------------------------ */
    
    /** ActionScript 3 conversion (c) 2009 
    *   Jean-Francois Larouche, Canada 
    * 
    *   To know what have been changed, just search for 
    *   ActionScript in this file.
    * 
    *   Constructors:
    * 
    *   new BigDecimal() : Default BigDecimal to 0
    *   new BigDecimal(String) : String must be a decimal representation.
    *   new BigDecimal(int)  
    *   new BigDecimal(Number) 
    * 
    *   This class is Immutable exactly like the Java version
    * 
    *   To convert the value back:
    *   decimal.numberValue();
    *   decimal.toString()
    *  
    **/
	
    public class BigDecimal {
        private static function div(a:int, b:int):int {
            return (a-(a%b))/b as int;
        }
        
        private static function arraycopy(src:Array, srcindex:int, dest:Array, destindex:int, length:int):void {
            var i:int;
            
            if (destindex > srcindex) {
                for (i = length-1; i >= 0; --i) {
                    dest[i+destindex] = src[i+srcindex];
                }
            } else {
                for (i = 0; i < length; ++i) {
                    dest[i+destindex] = src[i+srcindex];
                }
            }
        }
		
        private static function createArrayWithZeros(length:int):Array {
            var retVal:Array = new Array(length);
            var i:int;
            for (i = 0; i < length; ++i) {
                retVal[i] = 0;
            }
            return retVal;
        }
        
        private static function isDigit(string:String):Boolean {
            return    string.charCodeAt(0) >= BigDecimal.VALUE_ZERO && 
                      string.charCodeAt(0) <= BigDecimal.VALUE_NINE;
        }
		
        private static function isDigitInt(value:int):Boolean {
            return    value >= BigDecimal.VALUE_ZERO && 
                      value <= BigDecimal.VALUE_NINE;
        }
        
        public static function getChars(src:String, srcBegin:int, srcEnd:int, dst:Array, dstBegin:int):void {

            if (srcBegin == srcEnd) {
                return;
            }

            for(srcBegin; srcBegin < srcEnd; ++srcBegin) {
                dst[dstBegin++] = src.charAt(srcBegin);
            }
        }
		
        private function assignMyself(other:BigDecimal):void {
            this.ind = other.ind;
            this.form = other.form;
            this.exp = other.exp;
            this.mant = other.mant;
        }
		
        public static const ZERO:BigDecimal = BigDecimal.createStatic(0);
        public static const ONE:BigDecimal = BigDecimal.createStatic(1);
        public static const TEN:BigDecimal = BigDecimal.createStatic(10);
		
        private static const ispos:int = 1;
        private static const iszero:int = 0;
        private static const isneg:int = -1;

        private static const MinExp:int = -999999999;
        private static const MaxExp:int = 999999999;
        private static const MinArg:int = -999999999;
        private static const MaxArg:int = 999999999;
		
        private static const VALUE_ZERO:int = (new String("0")).charCodeAt(0);
        private static const VALUE_NINE:int = (new String("9")).charCodeAt(0);
        private static const VALUE_EUPPER:int = (new String("e")).charCodeAt(0);
        private static const VALUE_ELOWER:int = (new String("E")).charCodeAt(0);
        private static const VALUE_DOT:int = (new String(".")).charCodeAt(0);
		
        private static const bytecar:Array = new Array((90+99)+1);
        private static const bytedig:Array = diginit();
		
        private var ind:int;
        private var form:int = MathContext.NOTATION_PLAIN;
        private var mant:Array;
		
        private var exp:int;

        public function BigDecimal(inobject:Object = 0, offset:int = 0, length:int = -1) {
            var exotic:Boolean;
            var hadexp:Boolean;
            var d:int;
            var dotoff:int;
            var last:int;
            var i:int = 0;
            var si:int = 0;
            var eneg:Boolean = false;
            var k:int = 0;
            var elen:int = 0;
            var j:int = 0;
            var sj:int = 0;
            var dvalue:int = 0;
            var mag:int = 0;
            var inchars:String = null;
            var createdFromNumber:Boolean = false;
            
            if(inobject == null) {
                return;
            }
            
            if(inobject is int) {
                createFromInt(inobject as int);
                return;             
            } else if(inobject is Number) {
                inchars = (inobject as Number).toString();
                createdFromNumber = true;
            } else if(!(inobject is String)) {
                badarg("bad parameter", 0, inchars);
            } else {
                inchars = inobject as String;
            }
			
            if(length == -1) {
                length = inchars.length;
            }
			
            if (length<=0) {
                bad(inchars);
                // [bad offset will raise array bounds exception]
            }
			
            ind = ispos;

            if (inchars.charAt(offset)==("-")) {
                length--;

                if (length==0) {
                    bad(inchars);
                }
                ind=isneg;
                offset++;
            } else if (inchars.charAt(offset)==("+")) {
                length--;
                if (length==0) {
                    bad(inchars);
                }
                offset++;
            }
			
            exotic = false;
            hadexp = false;
            d = 0;
            dotoff = -1;
            last = -1;

            {
                var $1:int = length;
                
                i = offset;
                
                _i:for(; $1 > 0; $1--,i++) {
                    si=inchars.charCodeAt(i);
                    if (si>=BigDecimal.VALUE_ZERO) {
                        if (si<=BigDecimal.VALUE_NINE) {
                            last=i;
                            d++;
                            continue;
                        }
                    }
        
                    if (si==BigDecimal.VALUE_DOT) {
                        if (dotoff>=0) {
                            bad(inchars);
                        }
                        dotoff=i-offset;
                        continue _i;
                    }

                    if (si!=BigDecimal.VALUE_ELOWER) {
                        if (si!=BigDecimal.VALUE_EUPPER) {
                            if ((!(isDigitInt(si)))) {
                                bad(inchars);
                            }
                            exotic = true;
                            last = i;
                            d++;
                            continue _i;
                        }
                    }
					
                    if ((i-offset)>(length-2)) {
                        bad(inchars);
                    }
                    eneg = false;

                    if ((inchars.charAt(i+1))==("-")) {
                        eneg=true;
                        k=i+2;
                    } else if ((inchars.charAt(i+1))==("+")) {
                        k=i+2;
                    } else {
                        k=i+1;
                    }
					
                    elen = length - ((k - offset));
                    if ((elen==0)||(elen>9)) {
                        bad(inchars);
                    }

                    {
                        var $2:int = elen;
                        j = k;
                        
                        _j:for(; $2 > 0; $2--,j++) {
                            sj=inchars.charCodeAt(j);
                            if (sj<BigDecimal.VALUE_ZERO) {
                                bad(inchars);
                            }
                            if (sj>BigDecimal.VALUE_NINE) {
                                bad(inchars);
                            } else {
                                dvalue=((sj))-((BigDecimal.VALUE_ZERO));
                            }
                            exp=(exp*10)+dvalue;
                        }
                    }

                    if (eneg) {
                        exp = -exp;
                    }

                    hadexp=true;
                    break _i;
                }
            }
			
            if (d==0) {
                bad(inchars);
            }
            if (dotoff>=0) {
                exp=(exp+dotoff)-d;
            }
			
            {
                var $3:int = last-1;
                i = offset;
                
                _i2:for(; i <= $3; i++) {
                    si=inchars.charCodeAt(i);
                    if (si==BigDecimal.VALUE_ZERO) {
                        offset++;
                        dotoff--;
                        d--;
                    } else if (si==BigDecimal.VALUE_DOT) {
                        offset++;
                        dotoff--;
                    } else if (si<=BigDecimal.VALUE_NINE) {
                        break _i2;
                    } else {
                        break _i2;
                    }
                }
            }
			
            mant = new Array(d);
            j = offset;

            if (exotic) {
                exotica:do {
                    {
                        var $4:int = d;
                        i = 0;

                        _i3:for(; $4 > 0; $4--, i++) {
                            if (i==dotoff) {
                                j++;
                            }
                            sj=inchars[j];
                            if (sj<=BigDecimal.VALUE_NINE) {
                                mant[i]=(sj-VALUE_ZERO);
                            } else {
                                bad(inchars);
                            }

                            j++;
                        }
                    }
                } while(false);
            } else {
                simple:do {
                    {
                        var $5:int = d;
                        i = 0;
                        _i4:for(; $5 > 0; $5--, i++) {
                            if (i==dotoff) {
                                j++;
                            }
                            mant[i]=((inchars.charCodeAt(j))-(BigDecimal.VALUE_ZERO));
                            j++;
                        }
                    }
                } while(false);
            }
            if (mant[0]==0) {
                ind=iszero;
                if (exp>0) {
                    exp=0;
                }

                if (hadexp) {
                    mant=ZERO.mant;
                    exp=0;
                }
            } else {
                // [ind was set earlier]
                if (hadexp) {
                    form = MathContext.NOTATION_SCIENTIFIC;
                    mag=(exp+mant.length)-1;
                    if ((mag<MinExp)||(mag>MaxExp)) {
                        bad(inchars);
                    }
                }
            }
            if(createdFromNumber) {
                var newScale:int = ((-exp) < 10) ? 10 : (-exp); 
                assignMyself(setScale(newScale));
            }
        }
		
        private function createFromInt(num:int = 0):void {

            var mun:int;
            var i:int = 0;

            // We fastpath commoners
            if (num<=9) {
                if (num>=(-9)) {
                    singledigit:do {
                        // very common single digit case
                        {/*select*/
                            if (num==0) {
                                mant=ZERO.mant;
                                ind=iszero;
                            } else if (num==1) {
                                mant=ONE.mant;
                                ind=ispos;
                            } else if (num==(-1)) {
                                mant=ONE.mant;
                                ind=isneg;
                            } else {
                                {
                                    mant=new Array(1);
                                    if (num>0) {
                                        mant[0]=num as int;
                                        ind=ispos;
                                    } else { // num<-1
                                        mant[0]=(-num) as int;
                                        ind=isneg;
                                    }
                                }
                            }
                        }

                        return;
                    } while(false);
                }/*singledigit*/
            }

            /* We work on negative numbers so we handle the most negative number */
            if (num>0) {
                ind=ispos;
                num=(-num) as int;
            } else {
                ind=isneg;/* negative */ // [0 case already handled]
            }

            // [it is quicker, here, to pre-calculate the length with
            // one loop, then allocate exactly the right length of byte array,
            // then re-fill it with another loop]
            mun=num; // working copy

            {
                i=9;
                _i:for(;;i--) {
                    mun=div(mun,10);
                    if (mun==0) {
                        break _i;
                    }
                }
            }/*i*/

            // i is the position of the leftmost digit placed
            mant=new Array(10-i);
            {
                i=(10-i)-1;
                _i2:for(;;i--) {
                    mant[i]=-((num%10) as int);
                    num=div(num,10);
                    if (num==0) {
                        break _i2;
                    }
                }
            }/*i*/
            return;
        }
        private static function createStatic(num:int):BigDecimal {
            var mun:int;
            var i:int=0;
            var returnValue:BigDecimal = new BigDecimal(null);
            // Not really worth fastpathing commoners in this constructor [also,
            // we use this to construct the static constants].
            // This is much faster than: this(String.valueOf(num).toCharArray())
            /* We work on negative num so we handle the most negative number */
        
            if (num>0) {
                returnValue.ind=ispos;
                num=-num;
            } else if (num==0) {
                returnValue.ind=iszero;
            } else {
                returnValue.ind=isneg;/* negative */
            }
        
            mun=num;
            {
                i=18;
                _i:for(;;i--){
                    mun=div(mun,10);
                    if (mun==0) {
                        break _i;
                    }
                }
            }/*i*/
            // i is the position of the leftmost digit placed
            returnValue.mant=new Array(19-i);
            {
                i=(19-i)-1;
                _i2:for(;;i--){
                    returnValue.mant[i]=-((num%10));
                    num=div(num,10);
                    if (num==0) {
                        break _i2;
                    }
                }
            }/*i*/
            return returnValue;
        }

        public function abs(context:MathContext = null):BigDecimal {

            if(context == null) {
                context = MathContext.PLAIN;
            }

            if (this.ind==isneg) {
                return this.negate(context);
            }
            return this.plus(context);
        }

        public function add(rhs:BigDecimal, context:MathContext = null):BigDecimal {
            var lhs:BigDecimal;
            var reqdig:int;
            var res:BigDecimal;
            var usel:Array;
            var usellen:int;
            var user:Array;
            var userlen:int;
            var newlen:int=0;
            var tlen:int=0;
            var mult:int=0;
            var t:Array=null;
            var ia:int=0;
            var ib:int=0;
            var ea:int=0;
            var eb:int=0;
            var ca:int=0;
            var cb:int=0;

            if(context == null) {
                context = MathContext.PLAIN;
            }

            /* determine requested digits and form */
            if (context.lostDigits) {
                checkdigits(rhs,context.digits);
            }

            lhs = this; // name for clarity and proxy

            /* Quick exit for add floating 0 */
            // plus() will optimize to return same object if possible
            if (lhs.ind==0) {
                if (context.form!=MathContext.NOTATION_PLAIN) {
                    return rhs.plus(context);
                }
                if (rhs.ind==0) {
                    if (context.form!=MathContext.NOTATION_PLAIN) {
                        return lhs.plus(context);
                    }
                }
            }

            /* Prepare numbers (round, unless unlimited precision) */
            reqdig=context.digits; // local copy (heavily used)

            if (reqdig>0) {
                if (lhs.mant.length>reqdig) {
                    lhs=clone(lhs).roundContext(context);
                }
                if (rhs.mant.length>reqdig) {
                    rhs=clone(rhs).roundContext(context);
                    // [we could reuse the new LHS for result in this case]
                }
            }

            res = new BigDecimal(); // build result here

            /* Now see how much we have to pad or truncate lhs or rhs in order
            to align the numbers. If one number is much larger than the
            other, then the smaller cannot affect the answer [but we may
            still need to pad with up to DIGITS trailing zeros]. */
            // Note sign may be 0 if digits (reqdig) is 0
            // usel and user will be the byte arrays passed to the adder; we'll
            // use them on all paths except quick exits
            usel=lhs.mant;
            usellen=lhs.mant.length;
            user=rhs.mant;
            userlen=rhs.mant.length;

            {
                padder:do {/*select*/
                    if (lhs.exp==rhs.exp) {/* no padding needed */
                        // This is the most common, and fastest, path
                        res.exp=lhs.exp;
                    } else if (lhs.exp>rhs.exp) { // need to pad lhs and/or truncate rhs
                        newlen=(usellen+lhs.exp)-rhs.exp;
                        /* If, after pad, lhs would be longer than rhs by digits+1 or
                        more (and digits>0) then rhs cannot affect answer, so we only
                        need to pad up to a length of DIGITS+1. */
                        if (newlen>=((userlen+reqdig)+1)) {
                            if (reqdig>0) {
                                // LHS is sufficient
                                res.mant=usel;
                                res.exp=lhs.exp;
                                res.ind=lhs.ind;

                                if (usellen<reqdig) { // need 0 padding
                                    res.mant=extend(lhs.mant,reqdig);
                                    res.exp=res.exp-((reqdig-usellen));
                                }

                                return res.finish(context,false);
                            }
                        }
                            
                        // RHS may affect result
                        res.exp=rhs.exp; // expected final exponent
                        if (newlen>(reqdig+1)) {
                            if (reqdig>0) {
                                // LHS will be max; RHS truncated
                                tlen=(newlen-reqdig)-1; // truncation length
                                userlen=userlen-tlen;
                                res.exp=res.exp+tlen;
                                newlen=reqdig+1;
                            }
                        }
                        if (newlen>usellen) {
                            usellen=newlen; // need to pad LHS
                        }
                    } else { // need to pad rhs and/or truncate lhs
                        newlen=(userlen+rhs.exp)-lhs.exp;
                        if (newlen>=((usellen+reqdig)+1)) {
                            if (reqdig>0) {
                                // RHS is sufficient
                                res.mant=user;
                                res.exp=rhs.exp;
                                res.ind=rhs.ind;
                                if (userlen<reqdig) { // need 0 padding
                                    res.mant=extend(rhs.mant,reqdig);
                                    res.exp=res.exp-((reqdig-userlen));
                                }
                                return res.finish(context,false);
                            }
                        }
                        // LHS may affect result
                        res.exp=lhs.exp; // expected final exponent
                        if (newlen>(reqdig+1)) {
                            if (reqdig>0) {
                                // RHS will be max; LHS truncated
                                tlen=(newlen-reqdig)-1; // truncation length
                                usellen=usellen-tlen;
                                res.exp=res.exp+tlen;
                                newlen=reqdig+1;
                            }
                        }
                        if (newlen>userlen) {
                            userlen=newlen; // need to pad RHS
                        }
                    }
                } while(false);
            }/*padder*/

            /* OK, we have aligned mantissas. Now add or subtract. */
            // 1998.06.27 Sign may now be 0 [e.g., 0.000] .. treat as positive
            // 1999.05.27 Allow for 00 on lhs [is not larger than 2 on rhs]
            // 1999.07.10 Allow for 00 on rhs [is not larger than 2 on rhs]
            if (lhs.ind==iszero) {
                res.ind=ispos;
            } else {
                res.ind=lhs.ind; // likely sign, all paths
            }
            if (( (lhs.ind==isneg)?1:0)==((rhs.ind==isneg)?1:0)) {// same sign, 0 non-negative
                mult=1;
            } else {
                signdiff:do { // different signs, so subtraction is needed
                    mult=-1; // will cause subtract
                    /* Before we can subtract we must determine which is the larger,
                    as our add/subtract routine only handles non-negative results
                    so we may need to swap the operands. */
                    {
                        swaptest:do {/*select*/
                            if (rhs.ind==iszero) {
                                // original A bigger
                            } else if ((usellen<userlen)||(lhs.ind==iszero)) { // original B bigger
                                t=usel;
                                usel=user;
                                user=t; // swap
                                tlen=usellen;
                                usellen=userlen;
                                userlen=tlen; // ..
                                res.ind=-res.ind; // and set sign
                            } else if (usellen>userlen) {
                                // original A bigger
                            } else {
                                {/* logical lengths the same */ // need compare
                                    /* may still need to swap: compare the strings */
                                    ia=0;
                                    ib=0;
                                    ea=usel.length-1;
                                    eb=user.length-1;
                                    {
                                        compare:for(;;) {
                                            if (ia<=ea) {
                                                ca=usel[ia];
                                            } else {
                                                if (ib>eb) {/* identical */
                                                    if (context.form!=MathContext.NOTATION_PLAIN) {
                                                        return ZERO;
                                                    }
                                                    // [if PLAIN we must do the subtract, in case of 0.000 results]
                                                    break compare;
                                                }
                                                ca=0;
                                            }

                                            if (ib<=eb) {
                                                cb=user[ib];
                                            } else {
                                                cb=0;
                                            }
                                            if (ca!=cb) {
                                                if (ca<cb) {/* swap needed */
                                                    t=usel;
                                                    usel=user;
                                                    user=t; // swap
                                                    tlen=usellen;
                                                    usellen=userlen;
                                                    userlen=tlen; // ..
                                                    res.ind=-res.ind;
                                                }
                                                break compare;
                                            }
                                            /* mantissas the same, so far */
                                            ia++;
                                            ib++;
                                        }
                                    }/*compare*/
                                } // lengths the same
                            }
                        } while(false);
                    }/*swaptest*/
                } while(false);
            }/*signdiff*/

            /* here, A is > B if subtracting */
            // add [A+B*1] or subtract [A+(B*-1)]
            res.mant=byteaddsub(usel,usellen,user,userlen,mult,false);
            // [reuse possible only after chop; accounting makes not worthwhile]

            // Finish() rounds before stripping leading 0's, then sets form, etc.
            return res.finish(context,false);
        }

        public function compareTo(rhs:BigDecimal, context:MathContext = null):int {
            var thislength:int = 0;
            var i:int = 0;
            var newrhs:BigDecimal;
            
            if(context == null) {
                context = MathContext.PLAIN;
            }

            // rhs=null will raise NullPointerException, as per Comparable interface
            if (context.lostDigits) {
                checkdigits(rhs,context.digits);
            }

            // [add will recheck in slowpath cases .. but would report -rhs]
            if ((this.ind == rhs.ind)&&(this.exp == rhs.exp)) {
                /* sign & exponent the same [very common] */
                thislength=this.mant.length;
                if (thislength < rhs.mant.length) {
                    return -this.ind;
                }
                if (thislength > rhs.mant.length) {
                    return this.ind;
                }
                /* lengths are the same; we can do a straight mantissa compare
                unless maybe rounding [rounding is very unusual] */
                if ((thislength<=context.digits)||(context.digits==0)) {
                    {
                        var $6:int = thislength;
                        i=0;
                        _i:for(;$6 > 0; $6--,i++) {
                            if (this.mant[i]<rhs.mant[i]) {
                                return -this.ind;
                            }
                            if (this.mant[i]>rhs.mant[i]) {
                                return this.ind;
                            }
                        }
                    }/*i*/
                    return 0; // identical
                }
            /* drop through for full comparison */
            } else {
                /* More fastpaths possible */
                if (this.ind<rhs.ind) {
                    return -1;
                }
                if (this.ind>rhs.ind) {
                    return 1;
                }
            }
            /* carry out a subtract to make the comparison */
            newrhs=clone(rhs); // safe copy
            newrhs.ind=-newrhs.ind; // prepare to subtract
            return this.add(newrhs,context).ind; // add, and return sign of result
        }

        public function divideRound(rhs:BigDecimal,round:int):BigDecimal {
            var context:MathContext;
            context= new MathContext(0,MathContext.NOTATION_PLAIN,false,round); // [checks round, too]
            return this.dodivide('D',rhs,context,-1); // take scale from LHS
        }

        public function divideScaleRound(rhs:BigDecimal,scale:int,round:int):BigDecimal {
            var context:MathContext;
            if (scale<0) {
                throw new Error("Negative scale:"+" "+scale);
            }
            context=new MathContext(0,MathContext.NOTATION_PLAIN,false,round); // [checks round]
            return this.dodivide('D',rhs,context,scale);
        }

        public function divide(rhs:BigDecimal,context:MathContext = null):BigDecimal {

            if(context == null) {
                context = MathContext.PLAIN;
            }

            return this.dodivide('D',rhs,context,-1);
        }

        public function divideInteger(rhs:BigDecimal,context:MathContext = null):BigDecimal {

            if(context == null) {
                context = MathContext.PLAIN;
            }

            // scale 0 to drop .000 when plain
            return this.dodivide('I',rhs,context,0);
        }

        public function max(rhs:BigDecimal,context:MathContext = null):BigDecimal {

            if(context == null) {
                context = MathContext.PLAIN;
            }

            if ((this.compareTo(rhs,context))>=0) {
                return this.plus(context);
            } else {
                return rhs.plus(context);
            }
        }

        public function min(rhs:BigDecimal,context:MathContext = null):BigDecimal {

            if(context == null) {
                context = MathContext.PLAIN;
            }

            if ((this.compareTo(rhs,context))<=0) {
                return this.plus(context);
            } else {
                return rhs.plus(context);
            }
        }

        public function multiply(rhs:BigDecimal,context:MathContext = null):BigDecimal {
            var lhs:BigDecimal;
            var padding:int;
            var reqdig:int;
            var multer:Array=null;
            var multand:Array=null;
            var multandlen:int;
            var acclen:int = 0;
            var res:BigDecimal;
            var acc:Array;
            var n:int = 0;
            var mult:int = 0;

            if(context == null) {
                context = MathContext.PLAIN;
            }

            if (context.lostDigits) {
                checkdigits(rhs,context.digits);
            }
            lhs=this; // name for clarity and proxy

            /* Prepare numbers (truncate, unless unlimited precision) */
            padding=0; // trailing 0's to add
            reqdig=context.digits; // local copy

            if (reqdig>0) {
                if (lhs.mant.length>reqdig) {
                    lhs=clone(lhs).roundContext(context);
                }
                if (rhs.mant.length>reqdig) {
                    rhs=clone(rhs).roundContext(context);
                }
            // [we could reuse the new LHS for result in this case]
            } else {/* unlimited */
                // fixed point arithmetic will want every trailing 0; we add these
                // after the calculation rather than before, for speed.
                if (lhs.exp>0) {
                    padding=padding+lhs.exp;
                }
                if (rhs.exp>0) {
                    padding=padding+rhs.exp;
                }
            }

            // For best speed, as in DMSRCN, we use the shorter number as the
            // multiplier and the longer as the multiplicand.
            // 1999.12.22: We used to special case when the result would fit in
            // a long, but with Java 1.3 this gave no advantage.
            if (lhs.mant.length<rhs.mant.length) {
                multer=lhs.mant;
                multand=rhs.mant;
            } else {
                multer=rhs.mant;
                multand=lhs.mant;
            }

            /* Calculate how long result byte array will be */
            multandlen=(multer.length+multand.length)-1; // effective length
            // optimize for 75% of the cases where a carry is expected...
            if ((multer[0]*multand[0])>9) {
                acclen=multandlen+1;
            } else {
                acclen=multandlen;
            }

            /* Now the main long multiplication loop */
            res=new BigDecimal(); // where we'll build result
            acc=createArrayWithZeros(acclen); // accumulator, all zeros
            // 1998.07.01: calculate from left to right so that accumulator goes
            // to likely final length on first addition; this avoids a one-digit
            // extension (and object allocation) each time around the loop.
            // Initial number therefore has virtual zeros added to right.
            {
                var $7:int = multer.length;
                n=0;
                n:for(;$7 > 0; $7--,n++) {
                    mult=multer[n];
                    if (mult!=0) { // [optimization]
                        // accumulate [accumulator is reusable array]
                        acc=byteaddsub(acc,acc.length,multand,multandlen,mult,true);
                    }
                    // divide multiplicand by 10 for next digit to right
                    multandlen--; // 'virtual length'
                }
            }/*n*/

            res.ind=(lhs.ind*rhs.ind); // final sign
            res.exp=(lhs.exp+rhs.exp)-padding; // final exponent
            // [overflow is checked by finish]

            /* add trailing zeros to the result, if necessary */
            if (padding==0) {
                res.mant=acc;
            } else {
                res.mant=extend(acc,acc.length+padding); // add trailing 0s
            }

            return res.finish(context,false);
        }

        public function negate(context:MathContext = null):BigDecimal{

            if(context == null) {
                context = MathContext.PLAIN;
            }

            var res:BigDecimal;
            // Originally called minus(), changed to matched Java precedents
            // This simply clones, flips the sign, and possibly rounds
            if (context.lostDigits) {
                checkdigits(null as BigDecimal,context.digits);
            }
            res=clone(this); // safe copy
            res.ind=-res.ind;

            return res.finish(context,false);
        }

        public function plus(context:MathContext = null):BigDecimal {

            if(context == null) {
                context = MathContext.PLAIN;
            }

            // This clones and forces the result to the new settings
            // May return same object
            if (context.lostDigits) {
                checkdigits(null as BigDecimal,context.digits);
            }
            // Optimization: returns same object for some common cases
            if (context.form==MathContext.NOTATION_PLAIN) {
                if (this.form==MathContext.NOTATION_PLAIN) {
                    if (this.mant.length<=context.digits) {
                        return this;
                    }
                    if (context.digits==0) {
                        return this;
                    }
                }
            }
            return clone(this).finish(context,false);
        }

        public function pow(rhs:BigDecimal,context:MathContext = null):BigDecimal {
            var n:int;
            var lhs:BigDecimal;
            var reqdig:int;
            var workdigits:int = 0;
            var L:int = 0;
            var workset:MathContext;
            var res:BigDecimal;
            var seenbit:Boolean;
            var i:int = 0;

            if(context == null) {
                context = MathContext.PLAIN;
            }

            if (context.lostDigits) {
                checkdigits(rhs,context.digits);
            }
            
            n=rhs.intcheck(MinArg,MaxArg); // check RHS by the rules
            lhs=this; // clarified name

            reqdig=context.digits; // local copy (heavily used)

            if (reqdig==0) {
                if (rhs.ind==isneg) {
                    throw new Error("Negative power:"+" "+rhs.toString());
                }
                workdigits=0;
            } else {/* non-0 digits */
                if ((rhs.mant.length+rhs.exp)>reqdig) {
                    throw Error("Too many digits:"+" "+rhs.toString());
                }

                /* Round the lhs to DIGITS if need be */
                if (lhs.mant.length>reqdig) {
                    lhs=clone(lhs).roundContext(context);
                }

                /* L for precision calculation [see ANSI X3.274-1996] */
                L=rhs.mant.length+rhs.exp; // length without decimal zeros/exp
                workdigits=(reqdig+L)+1; // calculate the working DIGITS
            }

            /* Create a copy of context for working settings */
            // Note: no need to check for lostDigits again.
            // 1999.07.17 Note: this construction must follow RHS check
            workset=new MathContext(workdigits,context.form,false,context.roundingMode);

            res=ONE; // accumulator

            if (n==0) {
                return res; // x**0 == 1
            }
            if (n<0) {
                n=-n; // [rhs.ind records the sign]
            }
            seenbit=false; // set once we've seen a 1-bit

            {
                i=1;
                _i:for(;;i++) { // for each bit [top bit ignored]
                    n=n+n; // shift left 1 bit
                    if (n<0) { // top bit is set
                        seenbit=true; // OK, we're off
                        res=res.multiply(lhs,workset); // acc=acc*x
                    }
                    if (i==31) {
                        break _i; // that was the last bit
                    }
                    if ((!seenbit)) {
                        continue _i; // we don't have to square 1
                    }
                    res=res.multiply(res,workset); // acc=acc*acc [square]
                }
            }/*i*/ // 32 bits
            if (rhs.ind<0) {// was a **-n [hence digits>0]
                res=ONE.divide(res,workset); // .. so acc=1/acc
            }
            return res.finish(context,true); // round and strip [original digits]
        }

        public function remainder(rhs:BigDecimal,context:MathContext = null):BigDecimal {

            if(context == null) {
                context = MathContext.PLAIN;
            }

            return this.dodivide('R',rhs,context,-1);
        }

        public function subtract(rhs:BigDecimal,context:MathContext = null):BigDecimal {
            var newrhs:BigDecimal;

            if(context == null) {
                context = MathContext.PLAIN;
            }

            if (context.lostDigits) {
                checkdigits(rhs,context.digits);
            }
            // [add will recheck .. but would report -rhs]
            /* carry out the subtraction */
            // we could fastpath -0, but it is too rare.
            newrhs=clone(rhs); // safe copy
            newrhs.ind=-newrhs.ind; // prepare to subtract

            return this.add(newrhs,context); // arithmetic
        }

        public function numberValue():Number {
            // We go via a String [as does BigDecimal in JDK 1.2]
            // Next line could possibly raise NumberFormatException
            return new Number(this.toString());
        }

        public function equals(obj:Object):Boolean {
            var rhs:BigDecimal;
            var i:int = 0;
            var lca:Array = null;
            var rca:Array = null;

            // We are equal iff toString of both are exactly the same
            if (obj==null) {
                return false; // not equal
            }

            if (!(obj is BigDecimal)) {
                return false; // not a decimal
            }

            rhs=obj as BigDecimal; // cast; we know it will work
            if (this.ind!=rhs.ind) {
                return false; // different signs never match
            }

            if (((this.mant.length==rhs.mant.length)&&(this.exp==rhs.exp))&&(this.form==rhs.form)) { 
                // mantissas say all
                // here with equal-length byte arrays to compare
                {
                    var $8:int=this.mant.length;
                    i=0;
                    _i:for(; $8 > 0; $8--,i++) {
                        if (this.mant[i]!=rhs.mant[i]) {
                            return false;
                        }
                    }
                }/*i*/
            } else { // need proper layout
                lca=this.layout(); // layout to character array
                rca=rhs.layout();
                if (lca.length!=rca.length) {
                    return false; // mismatch
                }
                // here with equal-length character arrays to compare
                {
                    var $9:int=lca.length;
                    i=0;
                    _i2:for(; $9 > 0; $9--,i++) {
                        if (lca[i]!=rca[i]) {
                            return false;
                        }
                    }
                }/*i*/
            }
            return true; // arrays have identical content
        }

        public function format(before:int,after:int,explaces:int = -1,exdigits:int = -1,exformint:int = 1 /*MathContext.SCIENTIFIC*/,exround:int = 4 /*ROUND_HALF_UP*/):String {
            var num:BigDecimal;
            var mag:int = 0;
            var thisafter:int = 0;
            var lead:int = 0;
            var newmant:Array=null;
            var chop:int = 0;
            var need:int = 0;
            var oldexp:int = 0;
            var a:Array;
            var p:int = 0;
            var newa:Array=null;
            var i:int = 0;
            var places:int = 0;


            /* Check arguments */
            if ((before<(-1))||(before==0)) {
                badarg("format",1,new String(before));
            }
            if (after<(-1)) {
                badarg("format",2,new String(after));
            }
            if ((explaces<(-1))||(explaces==0)) {
                badarg("format",3,new String(explaces));
            }
            if (exdigits<(-1)) {
                badarg("format",4,new String(explaces));
            }

            {/*select*/
                if (exformint==MathContext.NOTATION_SCIENTIFIC) {
                } else if (exformint==MathContext.NOTATION_ENGINEERING) {
                } else if (exformint==(-1)) {
                    exformint=MathContext.NOTATION_SCIENTIFIC;
                } else{ // note PLAIN isn't allowed
                    badarg("format",5,new String(exformint));
                }
            }

            // checking the rounding mode is done by trying to construct a
            // MathContext object with that mode; it will fail if bad
            if (exround!=MathContext.ROUND_HALF_UP) {
                try { // if non-default...
                    if (exround==(-1)) {
                        exround=MathContext.ROUND_HALF_UP;
                    } else {
                        new MathContext(9,MathContext.NOTATION_SCIENTIFIC,false,exround);
                    }
                } catch ($10:Error) {
                    badarg("format",6,new String(exround));
                }
            }

            num=clone(this); // make private copy

            /* Here:
            num is BigDecimal to format
            before is places before point [>0]
            after is places after point [>=0]
            explaces is exponent places [>0]
            exdigits is exponent digits [>=0]
            exformint is exponent form [one of two]
            exround is rounding mode [one of eight]
            'before' through 'exdigits' are -1 if not specified
            */

            /* determine form */
            {
                setform:do {/*select*/
                    if (exdigits==(-1)) {
                        num.form=MathContext.NOTATION_PLAIN;
                    } else if (num.ind==iszero) {
                        num.form=MathContext.NOTATION_PLAIN;
                    } else {
                        // determine whether triggers
                        mag=num.exp+num.mant.length;
                        if (mag>exdigits) {
                            num.form=exformint;
                        } else if (mag<(-5)) {
                            num.form=exformint;
                        } else {
                            num.form=MathContext.NOTATION_PLAIN;
                        }
                    }
                } while(false);
            }/*setform*/

            /* If 'after' was specified then we may need to adjust the
            mantissa. This is a little tricky, as we must conform to the
            rules of exponential layout if necessary (e.g., we cannot end up
            with 10.0 if scientific). */
            if (after>=0) {
                setafter:for(;;) {
                    // calculate the current after-length
                    {/*select*/
                        if (num.form==MathContext.NOTATION_PLAIN) {
                            thisafter=-num.exp; // has decimal part
                        } else if (num.form==MathContext.NOTATION_SCIENTIFIC) {
                            thisafter=num.mant.length-1;
                        } else { // engineering
                            lead=(((num.exp+num.mant.length)-1))%3; // exponent to use
                            if (lead<0) {
                                lead=3+lead; // negative exponent case
                            }
                            lead++; // number of leading digits
                            if (lead>=num.mant.length) {
                                thisafter=0;
                            } else {
                                thisafter=num.mant.length-lead;
                            }
                        }
                    }

                    if (thisafter==after) {
                        break setafter; // we're in luck
                    }
                    if (thisafter<after) { // need added trailing zeros
                        // [thisafter can be negative]
                        newmant=extend(num.mant,(num.mant.length+after)-thisafter);
                        num.mant=newmant;
                        num.exp=num.exp-((after-thisafter)); // adjust exponent
                        if (num.exp<MinExp) {
                            throw new Error("Exponent Overflow:"+" "+num.exp);
                        }
                        break setafter;
                    }

                    // We have too many digits after the decimal point; this could
                    // cause a carry, which could change the mantissa...
                    // Watch out for implied leading zeros in PLAIN case
                    chop=thisafter-after; // digits to lop [is >0]
                    if (chop>num.mant.length) { // all digits go, no chance of carry
                        // carry on with zero
                        num.mant=ZERO.mant;
                        num.ind=iszero;
                        num.exp=0;
                        continue setafter; // recheck: we may need trailing zeros
                    }

                    // we have a digit to inspect from existing mantissa
                    // round the number as required
                    need=num.mant.length-chop; // digits to end up with [may be 0]
                    oldexp=num.exp; // save old exponent
                    num.round(need,exround);
                    // if the exponent grew by more than the digits we chopped, then
                    // we must have had a carry, so will need to recheck the layout
                    if ((num.exp-oldexp)==chop) {
                        break setafter; // number did not have carry
                    }
                    // mantissa got extended .. so go around and check again
                }
            }/*setafter*/

            a=num.layout(); // lay out, with exponent if required, etc.

            /* Here we have laid-out number in 'a' */
            // now apply 'before' and 'explaces' as needed
            if (before>0) {
                // look for '.' or 'E'
                {
                    var $11:int = a.length;
                    p=0;
                    _p:for(; $11 > 0; $11--,p++) {
                        if (a[p]==VALUE_DOT) {
                            break _p;
                        }
                        if (a[p]==VALUE_EUPPER) {
                            break _p;
                        }
                    }
                }/*p*/

                // p is now offset of '.', 'E', or character after end of array
                // that is, the current length of before part
                if (p>before) {
                    badarg("format",1,new String(before)); // won't fit
                }
                if (p<before) { // need leading blanks
                    newa=new Array((a.length+before)-p);
                    {
                        var $12:int = before-p;
                        i = 0;
                        _i:for(; $12 > 0; $12--,i++) {
                            newa[i]=' ';
                        }
                    }/*i*/

                    arraycopy(a,0,newa,i,a.length);
                    a=newa;
                }
                // [if p=before then it's just the right length]
            }

            if (explaces>0) {
                // look for 'E' [cannot be at offset 0]
                {
                    var $13:int = a.length-1;
                    p=a.length-1;
                    _p2:for(; $13 > 0; $13--,p--) {
                        if (a[p]==VALUE_EUPPER) {
                            break _p2;
                        }
                    }
                }/*p*/

                // p is now offset of 'E', or 0
                if (p==0) { // no E part; add trailing blanks
                    newa=new Array((a.length+explaces)+2);
                    arraycopy(a,0,newa,0,a.length);
                    {
                        var $14:int = explaces+2;
                        i=a.length;
                        _i2:for(; $14 > 0; $14--,i++) {
                            newa[i]=' ';
                        }
                    }/*i*/
                    a=newa;
                } else {/* found E */ // may need to insert zeros
                    places=(a.length-p)-2; // number so far
                    if (places>explaces) {
                        badarg("format",3,new String(explaces));
                    }
                    if (places<explaces) { // need to insert zeros
                        newa=new Array((a.length+explaces)-places);
                        arraycopy(a,0,newa,0,p+2); // through E and sign
                        {
                            var $15:int = explaces-places;
                            i=p+2;
                            _i3:for(; $15 > 0; $15--,i++) {
                                newa[i]='0';
                            }
                        }/*i*/
                        arraycopy(a,p+2,newa,i,places); // remainder of exponent
                        a=newa;
                    }
                    // [if places=explaces then it's just the right length]
                }
            }

            return new String(a);
        }
        public function intValueExact():int {
            var lodigit:int;
            var useexp:int = 0;
            var result:int;
            var i:int = 0;
            var topdig:int = 0;
            // This does not use longValueExact() as the latter can be much
            // slower.
            // intcheck (from pow) relies on this to check decimal part
            if (ind==iszero) {
               return 0; // easy, and quite common
            }
            /* test and drop any trailing decimal part */
            
            lodigit=mant.length-1;
            if (exp<0) {
                lodigit=lodigit+exp; // reduces by -(-exp)
               /* all decimal places must be 0 */
            
                if ((!(allzero(mant,lodigit+1)))) {
                   throw new Error("Decimal part non-zero:"+" "+this.toString());
                }
               if (lodigit<0) {
                   return 0; // -1<this<1
               }
               useexp=0;
            } else {/* >=0 */
            
               if ((exp+lodigit)>9) { // early exit
                   throw new Error("Conversion overflow:"+" "+this.toString());
               }
               useexp=exp;
            }
            /* convert the mantissa to binary, inline for speed */
            
            result=0;
            {
               var $16:int = lodigit+useexp;
               i=0;
               _i:for(; i <= $16; i++) {
                   result=result*10;
                   if (i<=lodigit) {
                       result=result+mant[i];
                   }
               }
            }/*i*/
    
            /* Now, if the risky length, check for overflow */
            
            if ((lodigit+useexp)==9) {
                // note we cannot just test for -ve result, as overflow can move a
               // zero into the top bit [consider 5555555555]
                topdig=div(result, 1000000000); // get top digit, preserving sign
                if (topdig!=mant[0]) { // digit must match and be positive
                   // except in the special case ...
                   if (result==int.MIN_VALUE) { // looks like the special
                       if (ind==isneg) { // really was negative
                           if (mant[0]==2) {
                               return result; // really had top digit 2
                           }
                       }
                   }
                   
                   throw new Error("Conversion overflow:"+" "+this.toString());
               }
            }
    
            /* Looks good */
            
            if (ind==ispos) {
               return result;
            }
            
            return -result;
        }

        public function movePointLeft(n:int):BigDecimal {
            var res:BigDecimal;
            // very little point in optimizing for shift of 0
            res=clone(this);
            res.exp=res.exp-n;

            return res.finish(MathContext.PLAIN,false); // finish sets form and checks exponent
        }

        public function movePointRight(n:int):BigDecimal {
            var res:BigDecimal;
            res=clone(this);
            res.exp=res.exp+n;

            return res.finish(MathContext.PLAIN,false);
        }

        public function scale():int {
            if (exp>=0) {
                return 0; // scale can never be negative
            }

            return -exp;
        }

        public function setScale(scale:int,round:int = -1):BigDecimal {
            var ourscale:int;
            var res:BigDecimal;
            var padding:int = 0;
            var newlen:int = 0;
            
            //ActionScript 3
            //Correct the default parameter patch because of 
            //Compiler bug for the compile time constants
            if(round == -1) {
                round = MathContext.ROUND_UNNECESSARY;
            }
            
            // at present this naughtily only checks the round value if it is
            // needed (used), for speed
            ourscale=this.scale();

            if (ourscale==scale) { // already correct scale
                if (this.form==MathContext.NOTATION_PLAIN) {// .. and form
                    return this;
                }
            }
            res=clone(this); // need copy
            if (ourscale<=scale) { // simply zero-padding/changing form
                // if ourscale is 0 we may have lots of 0s to add
                if (ourscale==0) {
                    padding=res.exp+scale;
                } else {
                    padding=scale-ourscale;
                }
                res.mant=extend(res.mant,res.mant.length+padding);
                res.exp=-scale; // as requested
            } else {/* ourscale>scale: shortening, probably */
                if (scale<0) {
                    throw new Error("Negative scale:"+" "+scale);
                }
                // [round() will raise exception if invalid round]
                newlen=res.mant.length-((ourscale-scale)); // [<=0 is OK]
                res=res.round(newlen,round); // round to required length
                // This could have shifted left if round (say) 0.9->1[.0]
                // Repair if so by adding a zero and reducing exponent
                if (res.exp!=(-scale)) {
                    res.mant=extend(res.mant,res.mant.length+1);
                    res.exp=res.exp-1;
                }
            }
            res.form=MathContext.NOTATION_PLAIN; // by definition
            return res;
        }

        public function signum():int {
            return this.ind; // [note this assumes values for ind.]
        }

        public function toCharArray():Array {
            return layout();
        }

        public function toString():String {
            var charArray:Array = layout();
            var returnValue:String = "";
            for(var i:int = 0; i < charArray.length; ++i) {
                returnValue += charArray[i];
            }
            return returnValue;
        }

        private function layout():Array {
            var cmant:Array;
            var i:int = 0;
            var sb:String = null;
            var euse:int = 0;
            var sig:int = 0; 
            var csign:String = "";
            var rec:Array = null;
            var needsign:int;
            var mag:int;
            var len:int = 0;

            cmant=new Array(mant.length); // copy byte[] to a char[]

            {
                var $18:int = mant.length;
                i=0;
                _i:for(; $18 > 0; $18--,i++) {
                    cmant[i]=new String(mant[i]); //+VALUE_ZERO);
                }
            }/*i*/

            if (form!=MathContext.NOTATION_PLAIN) {/* exponential notation needed */
                //sb=new java.lang.StringBuffer JavaDoc(cmant.length+15); // -x.xxxE+999999999
                sb="";
                if (ind==isneg) {
                    sb += "-";
                }
                euse=(exp+cmant.length)-1; // exponent to use
                /* setup sig=significant digits and copy to result */
                if (form==MathContext.NOTATION_SCIENTIFIC) { // [default]
                    sb += cmant[0]; // significant character
                    if (cmant.length>1) {// have decimal part
                        //sb.append('.').append(cmant,1,cmant.length-1);
                        sb += ".";
                        sb += cmant.slice(1).join("");
                    }
                } else {
                    engineering:do {
                        sig=euse%3; // common
                        if (sig<0) {
                            sig=3+sig; // negative exponent
                        }
                        euse=euse-sig;
                        sig++;
                        if (sig>=cmant.length) { // zero padding may be needed
                            //sb.append(cmant,0,cmant.length);
                            sb += cmant.join("");
                            {
                                var $19:int = sig-cmant.length;
                                for(; $19 > 0;$19--) {
                                    sb += "0";
                                }
                            }
                        } else { // decimal point needed
                            //sb.append(cmant,0,sig).append('.').append(cmant,sig,cmant.length-sig);
                            sb += cmant.slice(0,sig).join("");
                            sb += ".";
                            sb += cmant.slice(sig).join("");
                        }
                    } while(false);
                }/*engineering*/

                if (euse!=0) {
                    if (euse<0) {
                        csign="-";
                        euse=-euse;
                    } else {
                        csign="+";
                    }
                    //sb.append('E').append(csign).append(euse);
                    sb += "E";
                    sb += csign;
                    sb += euse;
                }

                //rec=new Array(sb.length());
                //getChars(sb, 0,sb.length(),rec,0);
                return sb.split("");
            }

            /* Here for non-exponential (plain) notation */
            if (exp==0) {/* easy */
                if (ind>=0) {
                    return cmant; // non-negative integer
                }
                rec=new Array(cmant.length+1);
                rec[0]="-";
                arraycopy(cmant,0,rec,1,cmant.length);

                return rec;
            }

            /* Need a '.' and/or some zeros */
            needsign=((ind==isneg)?1:0); // space for sign? 0 or 1

            /* MAG is the position of the point in the mantissa (index of the
            character it follows) */
            mag=exp+cmant.length;

            if (mag<1) {/* 0.00xxxx form */
                len=(needsign+2)-exp; // needsign+2+(-mag)+cmant.length
                rec=new Array(len);
                if (needsign!=0) {
                    rec[0]="-";
                }
                rec[needsign]="0";
                rec[needsign+1]=".";
                {
                    var $20:int = -mag;
                    i=needsign+2;
                    _i2:for(; $20 > 0; $20--,i++) { // maybe none
                        rec[i]="0";
                    }
                }/*i*/
                arraycopy(cmant,0,rec,(needsign+2)-mag,cmant.length);
                return rec;
            }

            if (mag>cmant.length) {/* xxxx0000 form */
                len=needsign+mag;
                rec=new Array(len);
                if (needsign!=0) {
                    rec[0]="-";
                }

                arraycopy(cmant,0,rec,needsign,cmant.length);

                {
                    var $21:int = mag-cmant.length;
                    i=needsign+cmant.length;
                    _i3:for(; $21 > 0; $21--,i++) { // never 0
                        rec[i]="0";
                    }
                }/*i*/
                return rec;
            }

            /* decimal point is in the middle of the mantissa */
            len=(needsign+1)+cmant.length;
            rec=new Array(len);

            if (needsign!=0) {
                rec[0]='-';
            }

            arraycopy(cmant,0,rec,needsign,mag);
            rec[needsign+mag]=".";
            arraycopy(cmant,mag,rec,(needsign+mag)+1,cmant.length-mag);

            return rec;
        }

        private function intcheck(min:int,max:int):int {
            var i:int;
            i=this.intValueExact(); // [checks for non-0 decimal part]
            // Use same message as though intValueExact failed due to size
            if ((i<min)||(i>max)) {
                throw new Error("Conversion overflow:"+" "+i);
            }

            return i;
        }

        private function dodivide(code:String,rhs:BigDecimal,context:MathContext,scale:int):BigDecimal {
            var lhs:BigDecimal;
            var reqdig:int;
            var newexp:int;
            var res:BigDecimal;
            var newlen:int;
            var var1:Array;
            var var1len:int;
            var var2:Array;
            var var2len:int;
            var b2b:int;
            var have:int;
            var thisdigit:int = 0;
            var i:int = 0;
            var v2:int = 0;
            var ba:int = 0;
            var mult:int = 0;
            var start:int = 0;
            var padding:int = 0;
            var d:int = 0;
            var newvar1:Array=null;
            var lasthave:int = 0;
            var actdig:int = 0;
            var newmant:Array=null;

            if (context.lostDigits) {
                checkdigits(rhs,context.digits);
            }

            lhs=this; // name for clarity

            // [note we must have checked lostDigits before the following checks]
            if (rhs.ind==0) {
                throw new Error("Divide by 0"); // includes 0/0
            }

            if (lhs.ind==0) { // 0/x => 0 [possibly with .0s]
                if (context.form!=MathContext.NOTATION_PLAIN) {
                    return ZERO;
                }
                if (scale==(-1)) {
                    return lhs;
                }
                return lhs.setScale(scale);
            }

            /* Prepare numbers according to BigDecimal rules */
            reqdig=context.digits; // local copy (heavily used)

            if (reqdig>0) {
                if (lhs.mant.length>reqdig) {
                    lhs=clone(lhs).roundContext(context);
                }
                if (rhs.mant.length>reqdig) {
                    rhs=clone(rhs).roundContext(context);
                }
            } else {/* scaled divide */
                if (scale==(-1)) {
                    scale=lhs.scale();
                }
                // set reqdig to be at least large enough for the computation
                reqdig=lhs.mant.length; // base length
                // next line handles both positive lhs.exp and also scale mismatch
                if (scale!=(-lhs.exp)) {
                    reqdig=(reqdig+scale)+lhs.exp;
                }
                reqdig=(reqdig-((rhs.mant.length-1)))-rhs.exp; // reduce by RHS effect
                if (reqdig<lhs.mant.length) {
                    reqdig=lhs.mant.length; // clamp
                }
                if (reqdig<rhs.mant.length) {
                    reqdig=rhs.mant.length; // ..
                }
            }

            /* precalculate exponent */
            newexp=((lhs.exp-rhs.exp)+lhs.mant.length)-rhs.mant.length;
            /* If new exponent -ve, then some quick exits are possible */
            if (newexp<0) {
                if (code!="D") {
                    if (code=="I") {
                        return ZERO; // easy - no integer part
                    }
                    /* Must be 'R'; remainder is [finished clone of] input value */
                    return clone(lhs).finish(context,false);
                }
            }

            /* We need slow division */
            res=new BigDecimal(); // where we'll build result
            res.ind=(lhs.ind*rhs.ind); // final sign (for D/I)
            res.exp=newexp; // initial exponent (for D/I)
            res.mant=createArrayWithZeros(reqdig+1); // where build the result

            /* Now [virtually pad the mantissae with trailing zeros */
            // Also copy the LHS, which will be our working array
            newlen=(reqdig+reqdig)+1;
            var1=extend(lhs.mant,newlen); // always makes longer, so new safe array
            var1len=newlen; // [remaining digits are 0]

            var2=rhs.mant;
            var2len=newlen;

            /* Calculate first two digits of rhs (var2), +1 for later estimations */
            b2b=(var2[0]*10)+1;
            if (var2.length>1) {
                b2b=b2b+var2[1];
            }

            /* start the long-division loops */
            have=0;

            {
                outer:for(;;) {
                    thisdigit=0;
                    /* find the next digit */
                    {
                        inner:for(;;) {
                            if (var1len<var2len) {
                                break inner; // V1 too low
                            }
                            if (var1len==var2len) { // compare needed
                                {
                                    compare:do { // comparison
                                        {
                                            var $22:int = var1len;
                                            i = 0;
                                            _i:for(; $22 > 0; $22--,i++) {
                                                // var1len is always <= var1.length
                                                if (i<var2.length) {
                                                    v2=var2[i];
                                                } else {
                                                    v2=0;
                                                }
                                                if (var1[i]<v2) {
                                                    break inner; // V1 too low
                                                }
                                                if (var1[i]>v2) {
                                                    break compare; // OK to subtract
                                                }
                                            }
                                        }/*i*/

                                        /* reach here if lhs and rhs are identical; subtraction will
                                        increase digit by one, and the residue will be 0 so we
                                        are done; leave the loop with residue set to 0 (in case
                                        code is 'R' or ROUND_UNNECESSARY or a ROUND_HALF_xxxx is
                                        being checked) */
                                        thisdigit++;
                                        res.mant[have]=thisdigit;
                                        have++;
                                        var1[0]=0; // residue to 0 [this is all we'll test]
                                        // var1len=1 -- [optimized out]
                                        break outer;
                                    } while(false);
                                }/*compare*/

                                /* prepare for subtraction. Estimate BA (lengths the same) */
                                ba=var1[0]; // use only first digit
                            } /* lengths the same */ else {/* lhs longer than rhs */
                                /* use first two digits for estimate */
                                ba=var1[0]*10;
                                if (var1len>1) {
                                    ba=ba+var1[1];
                                }
                            }

                            /* subtraction needed; V1>=V2 */
                            mult=div((ba*10),b2b);
                            if (mult==0) {
                                mult=1;
                            }
                            thisdigit=thisdigit+mult;
                            // subtract; var1 reusable
                            var1=byteaddsub(var1,var1len,var2,var2len,-mult,true);

                            if (var1[0]!=0) {
                                continue inner; // maybe another subtract needed
                            }
                            /* V1 now probably has leading zeros, remove leading 0's and try
                            again. (It could be longer than V2) */
                            {
                                var $23:int = var1len-2;
                                start=0;
                                start:for(; start <= $23; start++) {
                                    if (var1[start]!=0) {
                                        break start;
                                    }
                                    var1len--;
                                }
                            }/*start*/

                            if (start==0) {
                                continue inner;
                            }
                            // shift left
                            arraycopy(var1,start,var1,0,var1len);
                        }
                    }/*inner*/

                    /* We have the next digit */
                    if ((have!=0)||(thisdigit!=0)) { // put the digit we got
                        res.mant[have]=thisdigit;
                        have++;
                        if (have==(reqdig+1)) {
                            break outer; // we have all we need
                        }
                        if (var1[0]==0) {
                            break outer; // residue now 0
                        }
                    }
                    /* can leave now if a scaled divide and exponent is small enough */
                    if (scale>=0) {
                        if ((-res.exp)>scale) {
                            break outer;
                        }
                    }

                    /* can leave now if not Divide and no integer part left */
                    if (code!="D") {
                        if (res.exp<=0) {
                            break outer;
                        }
                    }
                    res.exp=res.exp-1; // reduce the exponent
                    /* to get here, V1 is less than V2, so divide V2 by 10 and go for
                    the next digit */
                    var2len--;
                }
            }/*outer*/

            /* here when we have finished dividing, for some reason */
            // have is the number of digits we collected in res.mant
            if (have==0) {
                have=1; // res.mant[0] is 0; we always want a digit
            }

            if ((code=="I")||(code=="R")) {/* check for integer overflow needed */
                if ((have+res.exp)>reqdig) {
                    throw new Error("Integer overflow");
                }

                if (code=="R") {
                    remainder:do {
                        /* We were doing Remainder -- return the residue */
                        if (res.mant[0]==0) {// no integer part was found
                            return clone(lhs).finish(context,false); // .. so return lhs, canonical
                        }
                        if (var1[0]==0) {
                            return ZERO; // simple 0 residue
                        }
                        res.ind=lhs.ind; // sign is always as LHS
                        /* Calculate the exponent by subtracting the number of padding zeros
                        we added and adding the original exponent */
                        padding=((reqdig+reqdig)+1)-lhs.mant.length;
                        res.exp=(res.exp-padding)+lhs.exp;

                        /* strip insignificant padding zeros from residue, and create/copy
                        the resulting mantissa if need be */
                        d=var1len;
                        {
                            i = d-1;
                            _i2:for(;i >= 1; i--) {
                                if(!((res.exp<lhs.exp)&&(res.exp<rhs.exp))) {
                                    break;
                                }
                                if (var1[i]!=0) {
                                    break _i2;
                                }
                                d--;
                                res.exp=res.exp+1;
                            }
                        }/*i*/

                        if (d<var1.length) {/* need to reduce */
                            newvar1=new Array(d);
                            arraycopy(var1,0,newvar1,0,d); // shorten
                            var1=newvar1;
                        }
                        res.mant=var1;
                        return res.finish(context,false);
                    } while(false);
                }/*remainder*/
            } else {/* 'D' -- no overflow check needed */
                // If there was a residue then bump the final digit (iff 0 or 5)
                // so that the residue is visible for ROUND_UP, ROUND_HALF_xxx and
                // ROUND_UNNECESSARY checks (etc.) later.
                // [if we finished early, the residue will be 0]
                if (var1[0]!=0) { // residue not 0
                    lasthave=res.mant[have-1];
                    if (((lasthave%5))==0) {
                        res.mant[have-1]=(lasthave+1);
                    }
                }
            }

            /* Here for Divide or Integer Divide */
            // handle scaled results first ['I' always scale 0, optional for 'D']
            if (scale>=0) {
                scaled:do {
                    // say 'scale have res.exp len' scale have res.exp res.mant.length
                    if (have!=res.mant.length) {
                        // already padded with 0's, so just adjust exponent
                        res.exp=res.exp-((res.mant.length-have));
                    }
                    // calculate number of digits we really want [may be 0]
                    actdig=res.mant.length-(((-res.exp)-scale));
                    res.round(actdig,context.roundingMode); // round to desired length
                    // This could have shifted left if round (say) 0.9->1[.0]
                    // Repair if so by adding a zero and reducing exponent
                    if (res.exp!=(-scale)) {
                        res.mant=extend(res.mant,res.mant.length+1);
                        res.exp=res.exp-1;
                    }
                    return res.finish(context,true); // [strip if not PLAIN]
                } while(false);
            }/*scaled*/

            // reach here only if a non-scaled
            if (have==res.mant.length) { // got digits+1 digits
                res.roundContext(context);
                have=reqdig;
            } else {/* have<=reqdig */
                if (res.mant[0]==0) {
                    return ZERO; // fastpath
                }
                // make the mantissa truly just 'have' long
                // [we could let finish do this, during strip, if we adjusted
                // the exponent; however, truncation avoids the strip loop]
                newmant=new Array(have); // shorten
                arraycopy(res.mant,0,newmant,0,have);
                res.mant=newmant;
            }

            return res.finish(context,true);
        }

        private function bad(s:String):void {
            throw new Error("Not a number:"+" "+s);
        }

        private function badarg(name:String,pos:int,value:String):void {
            throw new Error("Bad argument"+" "+pos+" "+"to"+" "+name+":"+" "+value);
        }

        private static function extend(inarr:Array,newlen:int):Array{
            var newarr:Array;
            if(inarr.length==newlen) { 
                return inarr;
            }
            newarr=createArrayWithZeros(newlen);
            //--java.lang.System.arraycopy((java.lang.Object)inarr,0,(java.lang.Object)newarr,0,inarr.length);
            arraycopy(inarr,0,newarr,0,inarr.length);
            // 0 padding is carried out by the JVM on allocation initialization
            return newarr;
        }

        private static function byteaddsub(a:Array,avlen:int,b:Array,bvlen:int,m:int,reuse:Boolean):Array {
            var alength:int;
            var blength:int;
            var ap:int;
            var bp:int;
            var maxarr:int;
            var reb:Array;
            var quickm:Boolean;
            var digit:int;
            var op:int = 0;
            var dp90:int = 0;
            var newarr:Array;
            var i:int = 0;

            // We'll usually be right if we assume no carry
            alength=a.length; // physical lengths
            blength=b.length; // ..
            ap=avlen-1; // -> final (rightmost) digit
            bp=bvlen-1; // ..
            maxarr=bp;

            if (maxarr<ap) {
                maxarr=ap;
            }

            reb=null; // result byte array

            if (reuse) {
                if ((maxarr+1)==alength) {
                    reb=a; // OK to reuse A
                }
            }
            if (reb==null) {
                reb=createArrayWithZeros(maxarr+1); // need new array
            }

            quickm=false; // 1 if no multiply needed

            if (m==1) {
                quickm=true; // most common
            } else if (m==(-1)) {
                quickm=true; // also common
            }

            digit=0; // digit, with carry or borrow

            {
                op=maxarr;
                op:for(; op >= 0; op--) {
                    if (ap>=0) {
                        if (ap<alength) {
                            digit=digit+a[ap]; // within A
                        }
                        ap--;
                    }
                    if (bp>=0) {
                        if (bp<blength) { // within B
                            if (quickm) {
                                if (m>0) {
                                    digit=digit+b[bp]; // most common
                                } else {
                                    digit=digit-b[bp]; // also common
                                }
                            } else {
                                digit=digit+(b[bp]*m);
                            }
                        }
                        bp--;
                    }

                    /* result so far (digit) could be -90 through 99 */
                    if (digit<10) {
                        if (digit>=0) {
                            quick:do { // 0-9
                                reb[op]=digit;
                                digit=0; // no carry
                                continue op;
                            } while(false);
                        }/*quick*/
                    }

                    dp90=digit+90;
                    reb[op]=bytedig[dp90]; // this digit
                    digit=bytecar[dp90]; // carry or borrow
                }
            }/*op*/

            if (digit==0) {
                return reb; // no carry
            }
            // following line will become an Assert, later
            // if digit<0 then signal ArithmeticException("internal.error ["digit"]")

            /* We have carry -- need to make space for the extra digit */
            newarr=null;
            if (reuse) {
                if ((maxarr+2)==a.length) {
                    newarr=a; // OK to reuse A
                }
            }
            if (newarr==null) {
                newarr=new Array(maxarr+2);
            }
            newarr[0]=digit; // the carried digit ..
            // .. and all the rest [use local loop for short numbers]
            if (maxarr<10) {
                var $24:int = maxarr+1;
                i = 0;
                _i:for(; $24 > 0; $24--,i++) {
                    newarr[i+1]=reb[i];
                }
            }/*i*/ else {
                arraycopy(reb,0,newarr,1,maxarr+1);
            }

            return newarr;
        }

        private static function diginit():Array {
            var work:Array;
            var op:int = 0;
            var digit:int = 0;

            work=new Array((90+99)+1);
            {
                op=0;
                op:for(; op <= (90+99);op++) {
                    digit=op-90;
                    if (digit>=0) {
                        work[op]=(digit%10);
                        bytecar[op]=div(digit, 10); // calculate carry
                        continue op;
                    }

                    // borrowing...
                    digit=digit+100; // yes, this is right [consider -50]
                    work[op]=(digit%10);
                    bytecar[op]=(div(digit,10)-10); // calculate borrow [NB: - after %]
                }
            }/*op*/
            return work;
        }

        private static function clone(dec:BigDecimal):BigDecimal {
            var copy:BigDecimal;
            copy = new BigDecimal(null);
            copy.ind=dec.ind;
            copy.exp=dec.exp;
            copy.form=dec.form;
            copy.mant=dec.mant;
            return copy;
        }

        private function checkdigits(rhs:BigDecimal, dig:int):void {
            if (dig==0) {
                return; // don't check if digits=0
            }
            // first check lhs...
            if (this.mant.length>dig) {
                if ((!(allzero(this.mant,dig)))) {
                    throw new Error("Too many digits:"+" "+this.toString());
                }
            }
            if (rhs==null) {
                return; // monadic
            }
            if (rhs.mant.length>dig) {
                if ((!(allzero(rhs.mant,dig)))) {
                    throw new Error("Too many digits:"+" "+rhs.toString());
                }
            }
        }

        private function roundContext(context:MathContext):BigDecimal {
            return round(context.digits,context.roundingMode);
        }

        private function round(len:int,mode:int):BigDecimal {
            var adjust:int;
            var sign:int;
            var oldmant:Array;
            var reuse:Boolean = false;
            var first:int = 0;
            var increment:int;
            var newmant:Array = null;

            adjust=mant.length-len;
            if (adjust<=0) {
                return this; // nowt to do
            }

            exp=exp+adjust; // exponent of result
            sign=ind; // save [assumes -1, 0, 1]
            oldmant=mant; // save

            if (len>0) {
                // remove the unwanted digits
                mant=new Array(len);
                arraycopy(oldmant,0,mant,0,len);
                reuse=true; // can reuse mantissa
                first=oldmant[len]; // first of discarded digits
            } else  {/* len<=0 */
                mant=ZERO.mant;
                ind=iszero;
                reuse=false; // cannot reuse mantissa
                if (len==0)
                first=oldmant[0];
                else
                first=0; // [virtual digit]
            }

            // decide rounding adjustment depending on mode, sign, and discarded digits
            increment=0; // bumper

            {
                modes:do {/*select*/
                    if (mode==MathContext.ROUND_HALF_UP) { // default first [most common]
                        if (first>=5) {
                            increment=sign;
                        }
                    } else if (mode==MathContext.ROUND_UNNECESSARY) { // default for setScale()
                        // discarding any non-zero digits is an error
                        if ((!(allzero(oldmant,len)))) {
                            throw new Error("Rounding necessary");
                        }
                    } else if (mode==MathContext.ROUND_HALF_DOWN) { // 0.5000 goes down
                        if (first>5) {
                            increment=sign;
                        } else if (first==5) {
                            if ((!(allzero(oldmant,len+1)))) {
                                increment=sign;
                            }
                        }
                    } else if (mode==MathContext.ROUND_HALF_EVEN) { // 0.5000 goes down if left digit even
                        if (first>5) {
                            increment=sign;
                        } else if (first==5) {
                            if ((!(allzero(oldmant,len+1)))) {
                                increment=sign;
                            } else /* 0.5000 */ if ((((mant[mant.length-1])%2))==1) {
                                increment=sign;
                            }
                        }
                    } else if (mode==MathContext.ROUND_DOWN) {
                        // never increment
                    } else if (mode==MathContext.ROUND_UP) { // increment if discarded non-zero
                        if ((!(allzero(oldmant,len)))) {
                            increment=sign;
                        }
                    } else if (mode==MathContext.ROUND_CEILING) { // more positive
                        if (sign>0) {
                            if ((!(allzero(oldmant,len)))) {
                                increment=sign;
                            }
                        }
                    } else if (mode==MathContext.ROUND_FLOOR) { // more negative
                        if (sign<0) {
                            if ((!(allzero(oldmant,len)))) {
                                increment=sign;
                            }
                        }
                    } else {
                        throw new Error("Bad round value:"+" "+mode);
                    }
                } while(false);
            }/*modes*/

            if (increment!=0) {
                bump:do {
                    if (ind==iszero) {
                        // we must not subtract from 0, but result is trivial anyway
                        mant=ONE.mant;
                        ind=increment;
                    } else {
                        // mantissa is non-0; we can safely add or subtract 1
                        if (ind==isneg) {
                            increment=-increment;
                        }
                        newmant=byteaddsub(mant,mant.length,ONE.mant,1,increment,reuse);
                        if (newmant.length>mant.length) { // had a carry
                            // drop rightmost digit and raise exponent
                            exp++;
                            // mant is already the correct length
                            arraycopy(newmant,0,mant,0,mant.length);
                        } else {
                            mant=newmant;
                        }
                    }
                }while(false);
            }/*bump*/
            // rounding can increase exponent significantly
            if (exp>MaxExp) {
                throw new Error("Exponent Overflow:"+" "+exp);
            }
            return this;
        }

        private static function allzero(array:Array,start:int):Boolean {
            var i:int=0;

            if (start<0) {
                start=0;
            }
            {
                var $25:int = array.length-1;
                i=start;
                _i:for(; i <= $25; i++) {
                    if (array[i]!=0) {
                        return false;
                    }
                }
            }/*i*/
            return true;
        }

        private function finish(context:MathContext,strip:Boolean):BigDecimal {
            var d:int = 0;
            var i:int = 0;
            var newmant:Array = null;
            var mag:int = 0;
            var sig:int = 0;

            /* Round if mantissa too long and digits requested */
            if (context.digits!=0) {
                if (this.mant.length>context.digits) {
                    this.roundContext(context);
                }
            }

            /* If strip requested (and standard formatting), remove
            insignificant trailing zeros. */
            if (strip)
                if (context.form!=MathContext.NOTATION_PLAIN) {
                    d=this.mant.length;
                    /* see if we need to drop any trailing zeros */
                    {
                        i=d-1;
                        _i:for(; i>= 1; i--) {
                            if (this.mant[i]!=0) {
                                break _i;
                            }
                            d--;
                            exp++;
                        }
                    }/*i*/

                    if (d<this.mant.length) {/* need to reduce */
                        newmant=new Array(d);
                        arraycopy(this.mant,0,newmant,0,d);
                        this.mant=newmant;
                    }
                }

                form=MathContext.NOTATION_PLAIN; // preset

                /* Now check for leading- and all- zeros in mantissa */
                {
                    var $26:int = this.mant.length;
                    i=0;
                    _i2:for(; $26 > 0; $26--,i++) {
                        if (this.mant[i] != 0) {
                            // non-0 result; ind will be correct
                            // remove leading zeros [e.g., after subtract]
                            if (i > 0) {
                                delead:do {
                                    newmant=new Array(this.mant.length-i);
                                    arraycopy(this.mant,i,newmant,0,this.mant.length-i);
                                    this.mant=newmant;
                                } while(false);
                            }/*delead*/

                            // now determine form if not PLAIN
                            mag = exp+mant.length;
                            if (mag > 0) { // most common path
                                if (mag > context.digits) {
                                    if (context.digits != 0) {
                                        form=context.form;
                                    }
                                }
                                if ((mag-1) <= MaxExp) {
                                    return this; // no overflow; quick return
                                }
                            } else if (mag < (-5)) {
                                form=context.form;
                            }
                            /* check for overflow */
                            mag--;
                            if ((mag<MinExp)||(mag>MaxExp)) {
                                overflow:do {
                                    // possible reprieve if form is engineering
                                    if (form==MathContext.NOTATION_ENGINEERING) {
                                        sig = mag%3; // leftover
                                        if (sig < 0) {
                                            sig = 3+sig; // negative exponent
                                        }
                                        mag = mag - sig; // exponent to use
                                        // 1999.06.29: second test here must be MaxExp
                                        if (mag >= MinExp) {
                                            if (mag <= MaxExp) {
                                                break overflow;
                                            }
                                        }
                                    }
                                    throw new Error("Exponent Overflow:"+" "+mag);

                                } while(false);
                            }/*overflow*/

                            return this;
                        }
                    }
                }/*i*/

            // Drop through to here only if mantissa is all zeros
            ind = iszero;

            {/*select*/
                if (context.form != MathContext.NOTATION_PLAIN) {
                    exp=0; // standard result; go to '0'
                } else if (exp > 0) {
                    exp=0; // +ve exponent also goes to '0'
                } else {
                    // a plain number with -ve exponent; preserve and check exponent
                    if (exp < MinExp) {
                        throw new ("Exponent Overflow:"+" "+exp);
                    }
                }
            }

            mant = ZERO.mant; // canonical mantissa
            return this;
        }
    }
}