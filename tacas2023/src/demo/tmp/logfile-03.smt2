(get-info :version)
; (:version "4.8.6")
; Started: 2022-10-18 14:13:39
; Silicon.version: 1.1-SNAPSHOT (4dbb81fc@(detached))
; Input file: -
; Verifier id: 00
; ------------------------------------------------------------
; Begin preamble
; ////////// Static preamble
; 
; ; /z3config.smt2
(set-option :print-success true) ; Boogie: false
(set-option :global-decls true) ; Boogie: default
(set-option :auto_config false) ; Usually a good idea
(set-option :smt.restart_strategy 0)
(set-option :smt.restart_factor |1.5|)
(set-option :smt.case_split 3)
(set-option :smt.delay_units true)
(set-option :smt.delay_units_threshold 16)
(set-option :nnf.sk_hack true)
(set-option :type_check true)
(set-option :smt.bv.reflect true)
(set-option :smt.mbqi false)
(set-option :smt.qi.eager_threshold 100)
(set-option :smt.qi.cost "(+ weight generation)")
(set-option :smt.qi.max_multi_patterns 1000)
(set-option :smt.phase_selection 0) ; default: 3, Boogie: 0
(set-option :sat.phase caching)
(set-option :sat.random_seed 0)
(set-option :nlsat.randomize true)
(set-option :nlsat.seed 0)
(set-option :nlsat.shuffle_vars false)
(set-option :fp.spacer.order_children 0) ; Not available with Z3 4.5
(set-option :fp.spacer.random_seed 0) ; Not available with Z3 4.5
(set-option :smt.arith.random_initial_value true) ; Boogie: true
(set-option :smt.random_seed 0)
(set-option :sls.random_offset true)
(set-option :sls.random_seed 0)
(set-option :sls.restart_init false)
(set-option :sls.walksat_ucb true)
(set-option :model.v2 true)
; 
; ; /preamble.smt2
(declare-datatypes () ((
    $Snap ($Snap.unit)
    ($Snap.combine ($Snap.first $Snap) ($Snap.second $Snap)))))
(declare-sort $Ref 0)
(declare-const $Ref.null $Ref)
(declare-sort $FPM)
(declare-sort $PPM)
(define-sort $Perm () Real)
(define-const $Perm.Write $Perm 1.0)
(define-const $Perm.No $Perm 0.0)
(define-fun $Perm.isValidVar ((p $Perm)) Bool
	(<= $Perm.No p))
(define-fun $Perm.isReadVar ((p $Perm) (ub $Perm)) Bool
    (and ($Perm.isValidVar p)
         (not (= p $Perm.No))
         (< p $Perm.Write)))
(define-fun $Perm.min ((p1 $Perm) (p2 $Perm)) Real
    (ite (<= p1 p2) p1 p2))
(define-fun $Math.min ((a Int) (b Int)) Int
    (ite (<= a b) a b))
(define-fun $Math.clip ((a Int)) Int
    (ite (< a 0) 0 a))
; ////////// Sorts
(declare-sort frac)
(declare-sort TYPE)
(declare-sort zfrac)
(declare-sort $FVF<$Ref>)
; ////////// Sort wrappers
; Declaring additional sort wrappers
(declare-fun $SortWrappers.IntTo$Snap (Int) $Snap)
(declare-fun $SortWrappers.$SnapToInt ($Snap) Int)
(assert (forall ((x Int)) (!
    (= x ($SortWrappers.$SnapToInt($SortWrappers.IntTo$Snap x)))
    :pattern (($SortWrappers.IntTo$Snap x))
    :qid |$Snap.$SnapToIntTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.IntTo$Snap($SortWrappers.$SnapToInt x)))
    :pattern (($SortWrappers.$SnapToInt x))
    :qid |$Snap.IntTo$SnapToInt|
    )))
(declare-fun $SortWrappers.BoolTo$Snap (Bool) $Snap)
(declare-fun $SortWrappers.$SnapToBool ($Snap) Bool)
(assert (forall ((x Bool)) (!
    (= x ($SortWrappers.$SnapToBool($SortWrappers.BoolTo$Snap x)))
    :pattern (($SortWrappers.BoolTo$Snap x))
    :qid |$Snap.$SnapToBoolTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.BoolTo$Snap($SortWrappers.$SnapToBool x)))
    :pattern (($SortWrappers.$SnapToBool x))
    :qid |$Snap.BoolTo$SnapToBool|
    )))
(declare-fun $SortWrappers.$RefTo$Snap ($Ref) $Snap)
(declare-fun $SortWrappers.$SnapTo$Ref ($Snap) $Ref)
(assert (forall ((x $Ref)) (!
    (= x ($SortWrappers.$SnapTo$Ref($SortWrappers.$RefTo$Snap x)))
    :pattern (($SortWrappers.$RefTo$Snap x))
    :qid |$Snap.$SnapTo$RefTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$RefTo$Snap($SortWrappers.$SnapTo$Ref x)))
    :pattern (($SortWrappers.$SnapTo$Ref x))
    :qid |$Snap.$RefTo$SnapTo$Ref|
    )))
(declare-fun $SortWrappers.$PermTo$Snap ($Perm) $Snap)
(declare-fun $SortWrappers.$SnapTo$Perm ($Snap) $Perm)
(assert (forall ((x $Perm)) (!
    (= x ($SortWrappers.$SnapTo$Perm($SortWrappers.$PermTo$Snap x)))
    :pattern (($SortWrappers.$PermTo$Snap x))
    :qid |$Snap.$SnapTo$PermTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$PermTo$Snap($SortWrappers.$SnapTo$Perm x)))
    :pattern (($SortWrappers.$SnapTo$Perm x))
    :qid |$Snap.$PermTo$SnapTo$Perm|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.fracTo$Snap (frac) $Snap)
(declare-fun $SortWrappers.$SnapTofrac ($Snap) frac)
(assert (forall ((x frac)) (!
    (= x ($SortWrappers.$SnapTofrac($SortWrappers.fracTo$Snap x)))
    :pattern (($SortWrappers.fracTo$Snap x))
    :qid |$Snap.$SnapTofracTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.fracTo$Snap($SortWrappers.$SnapTofrac x)))
    :pattern (($SortWrappers.$SnapTofrac x))
    :qid |$Snap.fracTo$SnapTofrac|
    )))
(declare-fun $SortWrappers.TYPETo$Snap (TYPE) $Snap)
(declare-fun $SortWrappers.$SnapToTYPE ($Snap) TYPE)
(assert (forall ((x TYPE)) (!
    (= x ($SortWrappers.$SnapToTYPE($SortWrappers.TYPETo$Snap x)))
    :pattern (($SortWrappers.TYPETo$Snap x))
    :qid |$Snap.$SnapToTYPETo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.TYPETo$Snap($SortWrappers.$SnapToTYPE x)))
    :pattern (($SortWrappers.$SnapToTYPE x))
    :qid |$Snap.TYPETo$SnapToTYPE|
    )))
(declare-fun $SortWrappers.zfracTo$Snap (zfrac) $Snap)
(declare-fun $SortWrappers.$SnapTozfrac ($Snap) zfrac)
(assert (forall ((x zfrac)) (!
    (= x ($SortWrappers.$SnapTozfrac($SortWrappers.zfracTo$Snap x)))
    :pattern (($SortWrappers.zfracTo$Snap x))
    :qid |$Snap.$SnapTozfracTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.zfracTo$Snap($SortWrappers.$SnapTozfrac x)))
    :pattern (($SortWrappers.$SnapTozfrac x))
    :qid |$Snap.zfracTo$SnapTozfrac|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.$FVF<$Ref>To$Snap ($FVF<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<$Ref> ($Snap) $FVF<$Ref>)
(assert (forall ((x $FVF<$Ref>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<$Ref>($SortWrappers.$FVF<$Ref>To$Snap x)))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<$Ref>To$Snap($SortWrappers.$SnapTo$FVF<$Ref> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<$Ref> x))
    :qid |$Snap.$FVF<$Ref>To$SnapTo$FVF<$Ref>|
    )))
; ////////// Symbols
(declare-fun frac_val<Perm> (frac) $Perm)
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class___return_random_0_ex<TYPE> TYPE)
(declare-const class___return_parseInt_1_ex<TYPE> TYPE)
(declare-const class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities<TYPE> TYPE)
(declare-const class___return_internal_receiveExternalChoice_2_ex<TYPE> TYPE)
(declare-const class___return_internal_addFromC_3_ex<TYPE> TYPE)
(declare-const class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_String<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Throwable<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Exception<TYPE> TYPE)
(declare-const class_AddPayload<TYPE> TYPE)
(declare-const class_java_DOT_util_DOT_Comparator<TYPE> TYPE)
(declare-const class_EncodedGlobalVariables<TYPE> TYPE)
(declare-fun directSuperclass<TYPE> (TYPE) TYPE)
(declare-fun type_of<TYPE> ($Ref) TYPE)
; Declaring symbols related to program functions (from program analysis)
(declare-fun instanceof_TYPE_TYPE ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%limited ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%stateless (TYPE TYPE) Bool)
(declare-fun new_frac ($Snap $Perm) frac)
(declare-fun new_frac%limited ($Snap $Perm) frac)
(declare-fun new_frac%stateless ($Perm) Bool)
(declare-fun new_zfrac ($Snap $Perm) zfrac)
(declare-fun new_zfrac%limited ($Snap $Perm) zfrac)
(declare-fun new_zfrac%stateless ($Perm) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
; ////////// Uniqueness assumptions from domains
(assert (distinct class_java_DOT_lang_DOT_Object<TYPE> class___return_random_0_ex<TYPE> class___return_parseInt_1_ex<TYPE> class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities<TYPE> class___return_internal_receiveExternalChoice_2_ex<TYPE> class___return_internal_addFromC_3_ex<TYPE> class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS<TYPE> class_java_DOT_lang_DOT_String<TYPE> class_java_DOT_lang_DOT_Throwable<TYPE> class_java_DOT_lang_DOT_Exception<TYPE> class_AddPayload<TYPE> class_java_DOT_util_DOT_Comparator<TYPE> class_EncodedGlobalVariables<TYPE>))
; ////////// Axioms
(assert (forall ((a frac) (b frac)) (!
  (= (= (frac_val<Perm> a) (frac_val<Perm> b)) (= a b))
  :pattern ((frac_val<Perm> a) (frac_val<Perm> b))
  :qid |prog.frac_eq|)))
(assert (forall ((a frac)) (!
  (and (< $Perm.No (frac_val<Perm> a)) (<= (frac_val<Perm> a) $Perm.Write))
  :pattern ((frac_val<Perm> a))
  :qid |prog.frac_bound|)))
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
(assert (=
  (directSuperclass<TYPE> (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class___return_random_0_ex<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class___return_parseInt_1_ex<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class___return_internal_receiveExternalChoice_2_ex<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class___return_internal_addFromC_3_ex<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_java_DOT_lang_DOT_String<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_java_DOT_lang_DOT_Throwable<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Throwable<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_AddPayload<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_java_DOT_util_DOT_Comparator<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_EncodedGlobalVariables<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (=
    (instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00)
    (instanceof_TYPE_TYPE s@$ t@0@00 u@1@00))
  :pattern ((instanceof_TYPE_TYPE s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (instanceof_TYPE_TYPE%stateless t@0@00 u@1@00)
  :pattern ((instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (let ((result@2@00 (instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))) (=
    result@2@00
    (or (= t@0@00 u@1@00) (= (directSuperclass<TYPE> t@0@00) u@1@00))))
  :pattern ((instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (= (new_frac%limited s@$ x@3@00) (new_frac s@$ x@3@00))
  :pattern ((new_frac s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (new_frac%stateless x@3@00)
  :pattern ((new_frac%limited s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (let ((result@4@00 (new_frac%limited s@$ x@3@00))) (implies
    (and (< $Perm.No x@3@00) (<= x@3@00 $Perm.Write))
    (= (frac_val<Perm> result@4@00) x@3@00)))
  :pattern ((new_frac%limited s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (= (new_zfrac%limited s@$ x@5@00) (new_zfrac s@$ x@5@00))
  :pattern ((new_zfrac s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (new_zfrac%stateless x@5@00)
  :pattern ((new_zfrac%limited s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (let ((result@6@00 (new_zfrac%limited s@$ x@5@00))) (implies
    (and (<= $Perm.No x@5@00) (<= x@5@00 $Perm.Write))
    (= (zfrac_val<Perm> result@6@00) x@5@00)))
  :pattern ((new_zfrac%limited s@$ x@5@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities_random_EncodedGlobalVariables_Integer ----------
(declare-const globals@0@03 $Ref)
(declare-const bound@1@03 Int)
(declare-const sys__result@2@03 Int)
(declare-const globals@3@03 $Ref)
(declare-const bound@4@03 Int)
(declare-const sys__result@5@03 Int)
(push) ; 1
(declare-const $t@6@03 $Snap)
(assert (= $t@6@03 $Snap.unit))
; [eval] 0 < bound
(assert (< 0 bound@4@03))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@7@03 $Snap)
(assert (= $t@7@03 ($Snap.combine ($Snap.first $t@7@03) ($Snap.second $t@7@03))))
(assert (= ($Snap.first $t@7@03) $Snap.unit))
; [eval] 0 <= sys__result
(assert (<= 0 sys__result@5@03))
(assert (= ($Snap.second $t@7@03) $Snap.unit))
; [eval] sys__result < bound
(assert (< sys__result@5@03 bound@4@03))
(pop) ; 2
(push) ; 2
; [exec]
; var ucv_0__4: Ref
(declare-const ucv_0__4@8@03 $Ref)
; [exec]
; var sys__exc__1: Ref
(declare-const sys__exc__1@9@03 $Ref)
; [exec]
; var __flatten_1__2: Ref
(declare-const __flatten_1__2@10@03 $Ref)
; [exec]
; var old__sys_exc_4__3: Ref
(declare-const old__sys_exc_4__3@11@03 $Ref)
; [exec]
; sys__exc__1 := null
; [exec]
; old__sys_exc_4__3 := sys__exc__1
; [exec]
; __flatten_1__2 := __return_random_0_ex___return_random_0_ex_Integer(0)
(declare-const sys__result@12@03 $Ref)
(declare-const $t@13@03 $Snap)
(assert (= $t@13@03 ($Snap.combine ($Snap.first $t@13@03) ($Snap.second $t@13@03))))
(assert (= ($Snap.first $t@13@03) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@12@03 $Ref.null)))
(assert (=
  ($Snap.second $t@13@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@13@03))
    ($Snap.second ($Snap.second $t@13@03)))))
(assert (= ($Snap.first ($Snap.second $t@13@03)) $Snap.unit))
; [eval] type_of(sys__result) == class___return_random_0_ex()
; [eval] type_of(sys__result)
; [eval] class___return_random_0_ex()
(assert (= (type_of<TYPE> sys__result@12@03) (as class___return_random_0_ex<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@13@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@13@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@13@03))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@13@03))) $Snap.unit))
; [eval] sys__result.__return_random_0_ex_value == returnValue
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@13@03))))
  0))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; sys__exc__1 := __flatten_1__2
; [exec]
; label catch_2
; [eval] !instanceof_TYPE_TYPE(type_of(sys__exc__1), class___return_random_0_ex())
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc__1), class___return_random_0_ex())
; [eval] type_of(sys__exc__1)
; [eval] class___return_random_0_ex()
(push) ; 3
(pop) ; 3
; Joined path conditions
(set-option :timeout 10)
(push) ; 3
(assert (not (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@12@03) (as class___return_random_0_ex<TYPE>  TYPE))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               37
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               1
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   5
;  :datatype-splits         1
;  :decisions               1
;  :del-clause              2
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.29
;  :mk-bool-var             140
;  :mk-clause               3
;  :num-allocs              47956
;  :num-checks              3
;  :propagations            80
;  :quant-instantiations    4
;  :rlimit-count            10657)
; [then-branch: 0 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@12@03), class___return_random_0_ex[TYPE])) | dead]
; [else-branch: 0 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@12@03), class___return_random_0_ex[TYPE]) | live]
(push) ; 3
; [else-branch: 0 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@12@03), class___return_random_0_ex[TYPE])]
(assert (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@12@03) (as class___return_random_0_ex<TYPE>  TYPE)))
(pop) ; 3
; [eval] !!instanceof_TYPE_TYPE(type_of(sys__exc__1), class___return_random_0_ex())
; [eval] !instanceof_TYPE_TYPE(type_of(sys__exc__1), class___return_random_0_ex())
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc__1), class___return_random_0_ex())
; [eval] type_of(sys__exc__1)
; [eval] class___return_random_0_ex()
(push) ; 3
(pop) ; 3
; Joined path conditions
(push) ; 3
(assert (not (not
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@12@03) (as class___return_random_0_ex<TYPE>  TYPE)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               1
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   7
;  :datatype-splits         1
;  :decisions               2
;  :del-clause              4
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.30
;  :mk-bool-var             144
;  :mk-clause               5
;  :num-allocs              48610
;  :num-checks              4
;  :propagations            81
;  :quant-instantiations    6
;  :rlimit-count            10831)
(push) ; 3
(assert (not (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@12@03) (as class___return_random_0_ex<TYPE>  TYPE))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   7
;  :datatype-splits         1
;  :decisions               2
;  :del-clause              6
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.29
;  :mk-bool-var             148
;  :mk-clause               7
;  :num-allocs              48683
;  :num-checks              5
;  :propagations            82
;  :quant-instantiations    9
;  :rlimit-count            10935)
; [then-branch: 1 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@12@03), class___return_random_0_ex[TYPE]) | live]
; [else-branch: 1 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@12@03), class___return_random_0_ex[TYPE])) | dead]
(push) ; 3
; [then-branch: 1 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@12@03), class___return_random_0_ex[TYPE])]
(assert (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@12@03) (as class___return_random_0_ex<TYPE>  TYPE)))
; [exec]
; inhale ucv_0__4 == sys__exc__1
(declare-const $t@14@03 $Snap)
(assert (= $t@14@03 $Snap.unit))
; [eval] ucv_0__4 == sys__exc__1
(assert (= ucv_0__4@8@03 sys__result@12@03))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; sys__exc__1 := null
; [exec]
; sys__result := ucv_0__4.__return_random_0_ex_value
(set-option :timeout 10)
(push) ; 4
(assert (not (= sys__result@12@03 ucv_0__4@8@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               43
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   9
;  :datatype-splits         1
;  :decisions               3
;  :del-clause              8
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.30
;  :mk-bool-var             154
;  :mk-clause               9
;  :num-allocs              49355
;  :num-checks              7
;  :propagations            83
;  :quant-instantiations    11
;  :rlimit-count            11165)
(declare-const sys__result@15@03 Int)
(assert (=
  sys__result@15@03
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@13@03))))))
; [exec]
; // assert
; assert 0 <= sys__result && sys__result < bound
; [eval] 0 <= sys__result
(set-option :timeout 0)
(push) ; 4
(assert (not (<= 0 sys__result@15@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               44
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   9
;  :datatype-splits         1
;  :decisions               3
;  :del-clause              8
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.30
;  :mk-bool-var             155
;  :mk-clause               9
;  :num-allocs              49432
;  :num-checks              8
;  :propagations            83
;  :quant-instantiations    11
;  :rlimit-count            11213)
(assert (<= 0 sys__result@15@03))
; [eval] sys__result < bound
(push) ; 4
(assert (not (< sys__result@15@03 bound@4@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               44
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   9
;  :datatype-splits         1
;  :decisions               3
;  :del-clause              8
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.30
;  :mk-bool-var             155
;  :mk-clause               9
;  :num-allocs              49446
;  :num-checks              9
;  :propagations            83
;  :quant-instantiations    11
;  :rlimit-count            11229)
(assert (< sys__result@15@03 bound@4@03))
; [exec]
; inhale false
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_internal_byeFromC_java_DOT_lang_DOT_Object_EncodedGlobalVariables ----------
(declare-const diz@16@03 $Ref)
(declare-const globals@17@03 $Ref)
(declare-const sys__exc@18@03 $Ref)
(declare-const diz@19@03 $Ref)
(declare-const globals@20@03 $Ref)
(declare-const sys__exc@21@03 $Ref)
(push) ; 1
(declare-const $t@22@03 $Snap)
(assert (= $t@22@03 ($Snap.combine ($Snap.first $t@22@03) ($Snap.second $t@22@03))))
(assert (= ($Snap.first $t@22@03) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@19@03 $Ref.null)))
(assert (=
  ($Snap.second $t@22@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@22@03))
    ($Snap.second ($Snap.second $t@22@03)))))
(assert (=
  ($Snap.second ($Snap.second $t@22@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@22@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@22@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@22@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@22@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@03)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@22@03))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@22@03))) 14))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@03))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == 1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@22@03))))
  1))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@23@03 $Snap)
(assert (= $t@23@03 ($Snap.combine ($Snap.first $t@23@03) ($Snap.second $t@23@03))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@21@03 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               109
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   15
;  :datatype-splits         9
;  :decisions               12
;  :del-clause              8
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.31
;  :mk-bool-var             179
;  :mk-clause               10
;  :num-allocs              51069
;  :num-checks              11
;  :propagations            84
;  :quant-instantiations    13
;  :rlimit-count            12378)
(push) ; 3
(assert (not (= sys__exc@21@03 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               126
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   18
;  :datatype-splits         13
;  :decisions               17
;  :del-clause              8
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.31
;  :mk-bool-var             185
;  :mk-clause               10
;  :num-allocs              51687
;  :num-checks              12
;  :propagations            85
;  :quant-instantiations    13
;  :rlimit-count            12595)
; [then-branch: 2 | sys__exc@21@03 == Null | live]
; [else-branch: 2 | sys__exc@21@03 != Null | live]
(push) ; 3
; [then-branch: 2 | sys__exc@21@03 == Null]
(assert (= sys__exc@21@03 $Ref.null))
(assert (=
  ($Snap.first $t@23@03)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@23@03))
    ($Snap.second ($Snap.first $t@23@03)))))
(assert (=
  ($Snap.second ($Snap.first $t@23@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.first $t@23@03)))
    ($Snap.second ($Snap.second ($Snap.first $t@23@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.first $t@23@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.first $t@23@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@23@03)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.first $t@23@03)))) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 15
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@23@03))) 15))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@23@03))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1
; [eval] -1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.first $t@23@03))))
  (- 0 1)))
(assert (=
  ($Snap.second $t@23@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@23@03))
    ($Snap.second ($Snap.second $t@23@03)))))
(assert (= ($Snap.first ($Snap.second $t@23@03)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 3 | sys__exc@21@03 != Null | live]
; [else-branch: 3 | sys__exc@21@03 == Null | live]
(push) ; 5
; [then-branch: 3 | sys__exc@21@03 != Null]
(assert (not (= sys__exc@21@03 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 3 | sys__exc@21@03 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@21@03) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@21@03 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               152
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   18
;  :datatype-splits         13
;  :decisions               17
;  :del-clause              8
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.33
;  :mk-bool-var             197
;  :mk-clause               10
;  :num-allocs              52026
;  :num-checks              13
;  :propagations            85
;  :quant-instantiations    15
;  :rlimit-count            13317)
; [then-branch: 4 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@21@03), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@21@03 != Null | dead]
; [else-branch: 4 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@21@03), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@21@03 != Null) | live]
(push) ; 5
; [else-branch: 4 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@21@03), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@21@03 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@21@03) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@21@03 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@23@03)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 5 | sys__exc@21@03 != Null | dead]
; [else-branch: 5 | sys__exc@21@03 == Null | live]
(push) ; 5
; [else-branch: 5 | sys__exc@21@03 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 2 | sys__exc@21@03 != Null]
(assert (not (= sys__exc@21@03 $Ref.null)))
(assert (= ($Snap.first $t@23@03) $Snap.unit))
(assert (=
  ($Snap.second $t@23@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@23@03))
    ($Snap.second ($Snap.second $t@23@03)))))
(assert (= ($Snap.first ($Snap.second $t@23@03)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 6 | sys__exc@21@03 != Null | live]
; [else-branch: 6 | sys__exc@21@03 == Null | live]
(push) ; 5
; [then-branch: 6 | sys__exc@21@03 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 6 | sys__exc@21@03 == Null]
(assert (= sys__exc@21@03 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@21@03) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@21@03 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   22
;  :datatype-splits         16
;  :decisions               22
;  :del-clause              15
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             214
;  :mk-clause               17
;  :num-allocs              52919
;  :num-checks              14
;  :propagations            88
;  :quant-instantiations    18
;  :rlimit-count            13956)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@21@03) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@21@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 30
;  :datatype-occurs-check   26
;  :datatype-splits         19
;  :decisions               26
;  :del-clause              22
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             226
;  :mk-clause               24
;  :num-allocs              53590
;  :num-checks              15
;  :propagations            93
;  :quant-instantiations    21
;  :rlimit-count            14239)
; [then-branch: 7 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@21@03), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@21@03 != Null | live]
; [else-branch: 7 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@21@03), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@21@03 != Null) | live]
(push) ; 5
; [then-branch: 7 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@21@03), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@21@03 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@21@03) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@21@03 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 7 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@21@03), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@21@03 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@21@03) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@21@03 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@23@03)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@21@03 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               208
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   30
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              22
;  :final-checks            18
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             230
;  :mk-clause               24
;  :num-allocs              54234
;  :num-checks              16
;  :propagations            94
;  :quant-instantiations    21
;  :rlimit-count            14476)
(push) ; 5
(assert (not (not (= sys__exc@21@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               208
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   30
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              22
;  :final-checks            18
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             230
;  :mk-clause               24
;  :num-allocs              54249
;  :num-checks              17
;  :propagations            94
;  :quant-instantiations    21
;  :rlimit-count            14487)
; [then-branch: 8 | sys__exc@21@03 != Null | live]
; [else-branch: 8 | sys__exc@21@03 == Null | dead]
(push) ; 5
; [then-branch: 8 | sys__exc@21@03 != Null]
(assert (not (= sys__exc@21@03 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 9 | sys__exc@21@03 != Null | live]
; [else-branch: 9 | sys__exc@21@03 == Null | live]
(push) ; 7
; [then-branch: 9 | sys__exc@21@03 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 9 | sys__exc@21@03 == Null]
(assert (= sys__exc@21@03 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@21@03 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@21@03) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@21@03 $Ref.null)))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_9__20: Int
(declare-const __flatten_9__20@24@03 Int)
; [exec]
; sys__exc := null
; [exec]
; diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state := 15
; [exec]
; __flatten_9__20 := -1
; [eval] -1
; [exec]
; diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice := __flatten_9__20
; [exec]
; label method_end_internal_byeFromC_23
; [eval] sys__exc == null
(push) ; 3
(assert (not false))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               220
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 38
;  :datatype-occurs-check   32
;  :datatype-splits         23
;  :decisions               32
;  :del-clause              22
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             233
;  :mk-clause               24
;  :num-allocs              54804
;  :num-checks              18
;  :propagations            95
;  :quant-instantiations    21
;  :rlimit-count            14671)
; [then-branch: 10 | True | live]
; [else-branch: 10 | False | dead]
(push) ; 3
; [then-branch: 10 | True]
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 15
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1
; [eval] -1
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 11 | False | dead]
; [else-branch: 11 | True | live]
(push) ; 5
; [else-branch: 11 | True]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 12 | False | dead]
; [else-branch: 12 | True | live]
(push) ; 5
; [else-branch: 12 | True]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(pop) ; 2
(pop) ; 1
