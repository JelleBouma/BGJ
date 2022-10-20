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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities_parseInt_EncodedGlobalVariables_java_DOT_lang_DOT_String ----------
(declare-const globals@0@01 $Ref)
(declare-const str@1@01 $Ref)
(declare-const sys__result@2@01 Int)
(declare-const globals@3@01 $Ref)
(declare-const str@4@01 $Ref)
(declare-const sys__result@5@01 Int)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; var ucv_1__8: Ref
(declare-const ucv_1__8@6@01 $Ref)
; [exec]
; var sys__exc__5: Ref
(declare-const sys__exc__5@7@01 $Ref)
; [exec]
; var __flatten_2__6: Ref
(declare-const __flatten_2__6@8@01 $Ref)
; [exec]
; var old__sys_exc_9__7: Ref
(declare-const old__sys_exc_9__7@9@01 $Ref)
; [exec]
; sys__exc__5 := null
; [exec]
; old__sys_exc_9__7 := sys__exc__5
; [exec]
; __flatten_2__6 := __return_parseInt_1_ex___return_parseInt_1_ex_Integer(0)
(declare-const sys__result@10@01 $Ref)
(declare-const $t@11@01 $Snap)
(assert (= $t@11@01 ($Snap.combine ($Snap.first $t@11@01) ($Snap.second $t@11@01))))
(assert (= ($Snap.first $t@11@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@10@01 $Ref.null)))
(assert (=
  ($Snap.second $t@11@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@11@01))
    ($Snap.second ($Snap.second $t@11@01)))))
(assert (= ($Snap.first ($Snap.second $t@11@01)) $Snap.unit))
; [eval] type_of(sys__result) == class___return_parseInt_1_ex()
; [eval] type_of(sys__result)
; [eval] class___return_parseInt_1_ex()
(assert (=
  (type_of<TYPE> sys__result@10@01)
  (as class___return_parseInt_1_ex<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@11@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@11@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@11@01))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@11@01))) $Snap.unit))
; [eval] sys__result.__return_parseInt_1_ex_value == returnValue
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@11@01))))
  0))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; sys__exc__5 := __flatten_2__6
; [exec]
; label catch_7
; [eval] !instanceof_TYPE_TYPE(type_of(sys__exc__5), class___return_parseInt_1_ex())
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc__5), class___return_parseInt_1_ex())
; [eval] type_of(sys__exc__5)
; [eval] class___return_parseInt_1_ex()
(push) ; 3
(pop) ; 3
; Joined path conditions
(set-option :timeout 10)
(push) ; 3
(assert (not (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@10@01) (as class___return_parseInt_1_ex<TYPE>  TYPE))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36
;  :binary-propagations     79
;  :conflicts               1
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   2
;  :datatype-splits         1
;  :decisions               1
;  :del-clause              2
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.29
;  :mk-bool-var             138
;  :mk-clause               3
;  :num-allocs              47823
;  :num-checks              3
;  :propagations            80
;  :quant-instantiations    4
;  :rlimit-count            10536)
; [then-branch: 0 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@10@01), class___return_parseInt_1_ex[TYPE])) | dead]
; [else-branch: 0 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@10@01), class___return_parseInt_1_ex[TYPE]) | live]
(push) ; 3
; [else-branch: 0 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@10@01), class___return_parseInt_1_ex[TYPE])]
(assert (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@10@01) (as class___return_parseInt_1_ex<TYPE>  TYPE)))
(pop) ; 3
; [eval] !!instanceof_TYPE_TYPE(type_of(sys__exc__5), class___return_parseInt_1_ex())
; [eval] !instanceof_TYPE_TYPE(type_of(sys__exc__5), class___return_parseInt_1_ex())
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc__5), class___return_parseInt_1_ex())
; [eval] type_of(sys__exc__5)
; [eval] class___return_parseInt_1_ex()
(push) ; 3
(pop) ; 3
; Joined path conditions
(push) ; 3
(assert (not (not
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@10@01) (as class___return_parseInt_1_ex<TYPE>  TYPE)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38
;  :binary-propagations     79
;  :conflicts               1
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   3
;  :datatype-splits         1
;  :decisions               2
;  :del-clause              4
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.30
;  :mk-bool-var             142
;  :mk-clause               5
;  :num-allocs              48474
;  :num-checks              4
;  :propagations            81
;  :quant-instantiations    6
;  :rlimit-count            10708)
(push) ; 3
(assert (not (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@10@01) (as class___return_parseInt_1_ex<TYPE>  TYPE))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   3
;  :datatype-splits         1
;  :decisions               2
;  :del-clause              6
;  :final-checks            4
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.29
;  :mk-bool-var             146
;  :mk-clause               7
;  :num-allocs              48546
;  :num-checks              5
;  :propagations            82
;  :quant-instantiations    9
;  :rlimit-count            10812)
; [then-branch: 1 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@10@01), class___return_parseInt_1_ex[TYPE]) | live]
; [else-branch: 1 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@10@01), class___return_parseInt_1_ex[TYPE])) | dead]
(push) ; 3
; [then-branch: 1 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@10@01), class___return_parseInt_1_ex[TYPE])]
(assert (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@10@01) (as class___return_parseInt_1_ex<TYPE>  TYPE)))
; [exec]
; inhale ucv_1__8 == sys__exc__5
(declare-const $t@12@01 $Snap)
(assert (= $t@12@01 $Snap.unit))
; [eval] ucv_1__8 == sys__exc__5
(assert (= ucv_1__8@6@01 sys__result@10@01))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; sys__exc__5 := null
; [exec]
; sys__result := ucv_1__8.__return_parseInt_1_ex_value
(set-option :timeout 10)
(push) ; 4
(assert (not (= sys__result@10@01 ucv_1__8@6@01)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               42
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   4
;  :datatype-splits         1
;  :decisions               3
;  :del-clause              8
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.30
;  :mk-bool-var             152
;  :mk-clause               9
;  :num-allocs              49213
;  :num-checks              7
;  :propagations            83
;  :quant-instantiations    11
;  :rlimit-count            11040)
(declare-const sys__result@13@01 Int)
(assert (=
  sys__result@13@01
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@11@01))))))
; [exec]
; inhale false
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_byeFromC_java_DOT_lang_DOT_Object_EncodedGlobalVariables ----------
(declare-const diz@14@01 $Ref)
(declare-const globals@15@01 $Ref)
(declare-const sys__exc@16@01 $Ref)
(declare-const diz@17@01 $Ref)
(declare-const globals@18@01 $Ref)
(declare-const sys__exc@19@01 $Ref)
(push) ; 1
(declare-const $t@20@01 $Snap)
(assert (= $t@20@01 ($Snap.combine ($Snap.first $t@20@01) ($Snap.second $t@20@01))))
(assert (= ($Snap.first $t@20@01) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@17@01 $Ref.null)))
(assert (=
  ($Snap.second $t@20@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@20@01))
    ($Snap.second ($Snap.second $t@20@01)))))
(assert (=
  ($Snap.second ($Snap.second $t@20@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@20@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@20@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@20@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@20@01))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@20@01))) 14))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@20@01))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == 1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@20@01))))
  1))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@21@01 $Snap)
(assert (= $t@21@01 ($Snap.combine ($Snap.first $t@21@01) ($Snap.second $t@21@01))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@19@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               107
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   10
;  :datatype-splits         9
;  :decisions               12
;  :del-clause              8
;  :final-checks            10
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.31
;  :mk-bool-var             176
;  :mk-clause               10
;  :num-allocs              50852
;  :num-checks              9
;  :propagations            84
;  :quant-instantiations    13
;  :rlimit-count            12187
;  :time                    0.00)
(push) ; 3
(assert (not (= sys__exc@19@01 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               124
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   13
;  :datatype-splits         13
;  :decisions               17
;  :del-clause              8
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.31
;  :mk-bool-var             182
;  :mk-clause               10
;  :num-allocs              51469
;  :num-checks              10
;  :propagations            85
;  :quant-instantiations    13
;  :rlimit-count            12404)
; [then-branch: 2 | sys__exc@19@01 == Null | live]
; [else-branch: 2 | sys__exc@19@01 != Null | live]
(push) ; 3
; [then-branch: 2 | sys__exc@19@01 == Null]
(assert (= sys__exc@19@01 $Ref.null))
(assert (=
  ($Snap.first $t@21@01)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@21@01))
    ($Snap.second ($Snap.first $t@21@01)))))
(assert (=
  ($Snap.second ($Snap.first $t@21@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.first $t@21@01)))
    ($Snap.second ($Snap.second ($Snap.first $t@21@01))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.first $t@21@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.first $t@21@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@21@01)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.first $t@21@01)))) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 15
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@21@01))) 15))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@21@01))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1
; [eval] -1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.first $t@21@01))))
  (- 0 1)))
(assert (=
  ($Snap.second $t@21@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@21@01))
    ($Snap.second ($Snap.second $t@21@01)))))
(assert (= ($Snap.first ($Snap.second $t@21@01)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 3 | sys__exc@19@01 != Null | live]
; [else-branch: 3 | sys__exc@19@01 == Null | live]
(push) ; 5
; [then-branch: 3 | sys__exc@19@01 != Null]
(assert (not (= sys__exc@19@01 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 3 | sys__exc@19@01 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@19@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@19@01 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               150
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   13
;  :datatype-splits         13
;  :decisions               17
;  :del-clause              8
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.33
;  :mk-bool-var             194
;  :mk-clause               10
;  :num-allocs              51806
;  :num-checks              11
;  :propagations            85
;  :quant-instantiations    15
;  :rlimit-count            13126)
; [then-branch: 4 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@19@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@19@01 != Null | dead]
; [else-branch: 4 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@19@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@19@01 != Null) | live]
(push) ; 5
; [else-branch: 4 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@19@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@19@01 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@19@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@19@01 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@21@01)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 5 | sys__exc@19@01 != Null | dead]
; [else-branch: 5 | sys__exc@19@01 == Null | live]
(push) ; 5
; [else-branch: 5 | sys__exc@19@01 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 2 | sys__exc@19@01 != Null]
(assert (not (= sys__exc@19@01 $Ref.null)))
(assert (= ($Snap.first $t@21@01) $Snap.unit))
(assert (=
  ($Snap.second $t@21@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@21@01))
    ($Snap.second ($Snap.second $t@21@01)))))
(assert (= ($Snap.first ($Snap.second $t@21@01)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 6 | sys__exc@19@01 != Null | live]
; [else-branch: 6 | sys__exc@19@01 == Null | live]
(push) ; 5
; [then-branch: 6 | sys__exc@19@01 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 6 | sys__exc@19@01 == Null]
(assert (= sys__exc@19@01 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@19@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@19@01 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               177
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   17
;  :datatype-splits         16
;  :decisions               22
;  :del-clause              15
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             211
;  :mk-clause               17
;  :num-allocs              52702
;  :num-checks              12
;  :propagations            88
;  :quant-instantiations    18
;  :rlimit-count            13765)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@19@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@19@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               192
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 30
;  :datatype-occurs-check   21
;  :datatype-splits         19
;  :decisions               26
;  :del-clause              22
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             223
;  :mk-clause               24
;  :num-allocs              53372
;  :num-checks              13
;  :propagations            93
;  :quant-instantiations    21
;  :rlimit-count            14048)
; [then-branch: 7 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@19@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@19@01 != Null | live]
; [else-branch: 7 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@19@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@19@01 != Null) | live]
(push) ; 5
; [then-branch: 7 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@19@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@19@01 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@19@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@19@01 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 7 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@19@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@19@01 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@19@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@19@01 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@21@01)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@19@01 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               206
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              22
;  :final-checks            18
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             227
;  :mk-clause               24
;  :num-allocs              54015
;  :num-checks              14
;  :propagations            94
;  :quant-instantiations    21
;  :rlimit-count            14285)
(push) ; 5
(assert (not (not (= sys__exc@19@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               206
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   25
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              22
;  :final-checks            18
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             227
;  :mk-clause               24
;  :num-allocs              54029
;  :num-checks              15
;  :propagations            94
;  :quant-instantiations    21
;  :rlimit-count            14296)
; [then-branch: 8 | sys__exc@19@01 != Null | live]
; [else-branch: 8 | sys__exc@19@01 == Null | dead]
(push) ; 5
; [then-branch: 8 | sys__exc@19@01 != Null]
(assert (not (= sys__exc@19@01 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 9 | sys__exc@19@01 != Null | live]
; [else-branch: 9 | sys__exc@19@01 == Null | live]
(push) ; 7
; [then-branch: 9 | sys__exc@19@01 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 9 | sys__exc@19@01 == Null]
(assert (= sys__exc@19@01 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@19@01 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@19@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@19@01 $Ref.null)))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- java_DOT_lang_DOT_Throwable_internal_Throwable_EncodedGlobalVariables ----------
(declare-const globals@22@01 $Ref)
(declare-const sys__result@23@01 $Ref)
(declare-const globals@24@01 $Ref)
(declare-const sys__result@25@01 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@26@01 $Snap)
(assert (= $t@26@01 ($Snap.combine ($Snap.first $t@26@01) ($Snap.second $t@26@01))))
(assert (= ($Snap.first $t@26@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@25@01 $Ref.null)))
(assert (= ($Snap.second $t@26@01) $Snap.unit))
; [eval] type_of(sys__result) == class_java_DOT_lang_DOT_Throwable()
; [eval] type_of(sys__result)
; [eval] class_java_DOT_lang_DOT_Throwable()
(assert (=
  (type_of<TYPE> sys__result@25@01)
  (as class_java_DOT_lang_DOT_Throwable<TYPE>  TYPE)))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- java_DOT_lang_DOT_Throwable_getMessage_EncodedGlobalVariables ----------
(declare-const diz@27@01 $Ref)
(declare-const globals@28@01 $Ref)
(declare-const sys__result@29@01 $Ref)
(declare-const diz@30@01 $Ref)
(declare-const globals@31@01 $Ref)
(declare-const sys__result@32@01 $Ref)
(push) ; 1
(declare-const $t@33@01 $Snap)
(assert (= $t@33@01 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@30@01 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- java_DOT_lang_DOT_Exception_Exception_EncodedGlobalVariables ----------
(declare-const globals@34@01 $Ref)
(declare-const sys__result@35@01 $Ref)
(declare-const globals@36@01 $Ref)
(declare-const sys__result@37@01 $Ref)
(push) ; 1
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@38@01 $Snap)
(assert (= $t@38@01 ($Snap.combine ($Snap.first $t@38@01) ($Snap.second $t@38@01))))
(assert (= ($Snap.first $t@38@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@37@01 $Ref.null)))
(assert (= ($Snap.second $t@38@01) $Snap.unit))
; [eval] type_of(sys__result) == class_java_DOT_lang_DOT_Exception()
; [eval] type_of(sys__result)
; [eval] class_java_DOT_lang_DOT_Exception()
(assert (=
  (type_of<TYPE> sys__result@37@01)
  (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE)))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- java_DOT_lang_DOT_Exception_printStackTrace_EncodedGlobalVariables ----------
(declare-const diz@39@01 $Ref)
(declare-const globals@40@01 $Ref)
(declare-const diz@41@01 $Ref)
(declare-const globals@42@01 $Ref)
(push) ; 1
(declare-const $t@43@01 $Snap)
(assert (= $t@43@01 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@41@01 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- java_DOT_lang_DOT_Exception_internal_getMessage_EncodedGlobalVariables ----------
(declare-const diz@44@01 $Ref)
(declare-const globals@45@01 $Ref)
(declare-const sys__result@46@01 $Ref)
(declare-const diz@47@01 $Ref)
(declare-const globals@48@01 $Ref)
(declare-const sys__result@49@01 $Ref)
(push) ; 1
(declare-const $t@50@01 $Snap)
(assert (= $t@50@01 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@47@01 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
