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
; ---------- __return_random_0_ex___return_random_0_ex_Integer ----------
(declare-const returnValue@0@06 Int)
(declare-const sys__result@1@06 $Ref)
(declare-const returnValue@2@06 Int)
(declare-const sys__result@3@06 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@4@06 $Snap)
(assert (= $t@4@06 ($Snap.combine ($Snap.first $t@4@06) ($Snap.second $t@4@06))))
(assert (= ($Snap.first $t@4@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@3@06 $Ref.null)))
(assert (=
  ($Snap.second $t@4@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@4@06))
    ($Snap.second ($Snap.second $t@4@06)))))
(assert (= ($Snap.first ($Snap.second $t@4@06)) $Snap.unit))
; [eval] type_of(sys__result) == class___return_random_0_ex()
; [eval] type_of(sys__result)
; [eval] class___return_random_0_ex()
(assert (= (type_of<TYPE> sys__result@3@06) (as class___return_random_0_ex<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@4@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@4@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@4@06))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@4@06))) $Snap.unit))
; [eval] sys__result.__return_random_0_ex_value == returnValue
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@4@06))))
  returnValue@2@06))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS___contract_unsatisfiable__internal_receiveExternalChoice_EncodedGlobalVariables ----------
(declare-const diz@5@06 $Ref)
(declare-const globals@6@06 $Ref)
(declare-const sys__result@7@06 Int)
(declare-const diz@8@06 $Ref)
(declare-const globals@9@06 $Ref)
(declare-const sys__result@10@06 Int)
(push) ; 1
(declare-const $t@11@06 $Snap)
(assert (= $t@11@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@8@06 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state, write) && acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice, write) && (diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1 && (diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 || diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14)))
(declare-const $t@12@06 $Snap)
(assert (= $t@12@06 ($Snap.combine ($Snap.first $t@12@06) ($Snap.second $t@12@06))))
(assert (= ($Snap.first $t@12@06) $Snap.unit))
(assert (=
  ($Snap.second $t@12@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@12@06))
    ($Snap.second ($Snap.second $t@12@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@12@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@12@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@12@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@12@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@06))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1
; [eval] -1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@12@06))))
  (- 0 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@06))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 || diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(push) ; 3
; [then-branch: 0 | First:(Second:($t@12@06)) == 14 | live]
; [else-branch: 0 | First:(Second:($t@12@06)) != 14 | live]
(push) ; 4
; [then-branch: 0 | First:(Second:($t@12@06)) == 14]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@12@06))) 14))
(pop) ; 4
(push) ; 4
; [else-branch: 0 | First:(Second:($t@12@06)) != 14]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@12@06))) 14)))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@12@06))) 14))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; // assert
; assert false
(set-option :timeout 10)
(check-sat)
; unknown
; [state consolidation]
; State saturation: before repetition
(check-sat)
; unknown
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_internal_addFromC_java_DOT_lang_DOT_Object_EncodedGlobalVariables ----------
(declare-const diz@13@06 $Ref)
(declare-const globals@14@06 $Ref)
(declare-const sys__result@15@06 $Ref)
(declare-const sys__exc@16@06 $Ref)
(declare-const diz@17@06 $Ref)
(declare-const globals@18@06 $Ref)
(declare-const sys__result@19@06 $Ref)
(declare-const sys__exc@20@06 $Ref)
(push) ; 1
(declare-const $t@21@06 $Snap)
(assert (= $t@21@06 ($Snap.combine ($Snap.first $t@21@06) ($Snap.second $t@21@06))))
(assert (= ($Snap.first $t@21@06) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@17@06 $Ref.null)))
(assert (=
  ($Snap.second $t@21@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@21@06))
    ($Snap.second ($Snap.second $t@21@06)))))
(assert (=
  ($Snap.second ($Snap.second $t@21@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@21@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@21@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@21@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@21@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@21@06))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@21@06))) 14))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@06))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@21@06))))
  0))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@22@06 $Snap)
(assert (= $t@22@06 ($Snap.combine ($Snap.first $t@22@06) ($Snap.second $t@22@06))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@20@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               157
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   25
;  :datatype-splits         18
;  :decisions               22
;  :del-clause              1
;  :final-checks            16
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.31
;  :mk-bool-var             174
;  :mk-clause               3
;  :num-allocs              51746
;  :num-checks              8
;  :propagations            83
;  :quant-instantiations    4
;  :rlimit-count            12361)
(push) ; 3
(assert (not (= sys__exc@20@06 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               174
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   28
;  :datatype-splits         22
;  :decisions               27
;  :del-clause              1
;  :final-checks            18
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.31
;  :mk-bool-var             180
;  :mk-clause               3
;  :num-allocs              52363
;  :num-checks              9
;  :propagations            84
;  :quant-instantiations    4
;  :rlimit-count            12578)
; [then-branch: 1 | sys__exc@20@06 == Null | live]
; [else-branch: 1 | sys__exc@20@06 != Null | live]
(push) ; 3
; [then-branch: 1 | sys__exc@20@06 == Null]
(assert (= sys__exc@20@06 $Ref.null))
(assert (=
  ($Snap.first $t@22@06)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@22@06))
    ($Snap.second ($Snap.first $t@22@06)))))
(assert (=
  ($Snap.second ($Snap.first $t@22@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.first $t@22@06)))
    ($Snap.second ($Snap.second ($Snap.first $t@22@06))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.first $t@22@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.first $t@22@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@22@06)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.first $t@22@06)))) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 16
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@22@06))) 16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@22@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@22@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@22@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@22@06)))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1
; [eval] -1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.first $t@22@06))))
  (- 0 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@22@06)))))
  $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@19@06 $Ref.null)))
(assert (=
  ($Snap.second $t@22@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@22@06))
    ($Snap.second ($Snap.second $t@22@06)))))
(assert (= ($Snap.first ($Snap.second $t@22@06)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 2 | sys__exc@20@06 != Null | live]
; [else-branch: 2 | sys__exc@20@06 == Null | live]
(push) ; 5
; [then-branch: 2 | sys__exc@20@06 != Null]
(assert (not (= sys__exc@20@06 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 2 | sys__exc@20@06 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@20@06) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@20@06 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               206
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   28
;  :datatype-splits         22
;  :decisions               27
;  :del-clause              1
;  :final-checks            18
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.33
;  :mk-bool-var             195
;  :mk-clause               3
;  :num-allocs              52743
;  :num-checks              10
;  :propagations            84
;  :quant-instantiations    6
;  :rlimit-count            13471)
; [then-branch: 3 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@20@06), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@20@06 != Null | dead]
; [else-branch: 3 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@20@06), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@20@06 != Null) | live]
(push) ; 5
; [else-branch: 3 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@20@06), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@20@06 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@20@06) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@20@06 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@22@06)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 4 | sys__exc@20@06 != Null | dead]
; [else-branch: 4 | sys__exc@20@06 == Null | live]
(push) ; 5
; [else-branch: 4 | sys__exc@20@06 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 1 | sys__exc@20@06 != Null]
(assert (not (= sys__exc@20@06 $Ref.null)))
(assert (= ($Snap.first $t@22@06) $Snap.unit))
(assert (=
  ($Snap.second $t@22@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@22@06))
    ($Snap.second ($Snap.second $t@22@06)))))
(assert (= ($Snap.first ($Snap.second $t@22@06)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 5 | sys__exc@20@06 != Null | live]
; [else-branch: 5 | sys__exc@20@06 == Null | live]
(push) ; 5
; [then-branch: 5 | sys__exc@20@06 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 5 | sys__exc@20@06 == Null]
(assert (= sys__exc@20@06 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@20@06) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@20@06 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               233
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   32
;  :datatype-splits         25
;  :decisions               32
;  :del-clause              8
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             212
;  :mk-clause               10
;  :num-allocs              53667
;  :num-checks              11
;  :propagations            87
;  :quant-instantiations    9
;  :rlimit-count            14110)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@20@06) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@20@06 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               248
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 44
;  :datatype-occurs-check   36
;  :datatype-splits         28
;  :decisions               36
;  :del-clause              15
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.35
;  :mk-bool-var             224
;  :mk-clause               17
;  :num-allocs              54340
;  :num-checks              12
;  :propagations            92
;  :quant-instantiations    12
;  :rlimit-count            14393)
; [then-branch: 6 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@20@06), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@20@06 != Null | live]
; [else-branch: 6 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@20@06), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@20@06 != Null) | live]
(push) ; 5
; [then-branch: 6 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@20@06), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@20@06 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@20@06) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@20@06 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 6 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@20@06), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@20@06 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@20@06) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@20@06 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@22@06)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@20@06 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               262
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 48
;  :datatype-occurs-check   40
;  :datatype-splits         30
;  :decisions               39
;  :del-clause              15
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.35
;  :mk-bool-var             228
;  :mk-clause               17
;  :num-allocs              54983
;  :num-checks              13
;  :propagations            93
;  :quant-instantiations    12
;  :rlimit-count            14630)
(push) ; 5
(assert (not (not (= sys__exc@20@06 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               262
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 48
;  :datatype-occurs-check   40
;  :datatype-splits         30
;  :decisions               39
;  :del-clause              15
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.35
;  :mk-bool-var             228
;  :mk-clause               17
;  :num-allocs              54997
;  :num-checks              14
;  :propagations            93
;  :quant-instantiations    12
;  :rlimit-count            14641)
; [then-branch: 7 | sys__exc@20@06 != Null | live]
; [else-branch: 7 | sys__exc@20@06 == Null | dead]
(push) ; 5
; [then-branch: 7 | sys__exc@20@06 != Null]
(assert (not (= sys__exc@20@06 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 8 | sys__exc@20@06 != Null | live]
; [else-branch: 8 | sys__exc@20@06 == Null | live]
(push) ; 7
; [then-branch: 8 | sys__exc@20@06 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 8 | sys__exc@20@06 == Null]
(assert (= sys__exc@20@06 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@20@06 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@20@06) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@20@06 $Ref.null)))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var ucv_3__19: Ref
(declare-const ucv_3__19@23@06 $Ref)
; [exec]
; var __flatten_6__15: Int
(declare-const __flatten_6__15@24@06 Int)
; [exec]
; var __flatten_7__16: Ref
(declare-const __flatten_7__16@25@06 $Ref)
; [exec]
; var __flatten_8__17: Ref
(declare-const __flatten_8__17@26@06 $Ref)
; [exec]
; var old__sys_exc_21__18: Ref
(declare-const old__sys_exc_21__18@27@06 $Ref)
; [exec]
; sys__exc := null
; [exec]
; old__sys_exc_21__18 := sys__exc
; [exec]
; diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state := 16
; [exec]
; __flatten_6__15 := -1
; [eval] -1
; [exec]
; diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice := __flatten_6__15
; [exec]
; __flatten_7__16 := AddPayload_AddPayload_EncodedGlobalVariables_Integer_Integer(globals, 0, 0)
(declare-const sys__result@28@06 $Ref)
(declare-const $t@29@06 $Snap)
(assert (= $t@29@06 ($Snap.combine ($Snap.first $t@29@06) ($Snap.second $t@29@06))))
(assert (= ($Snap.first $t@29@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@28@06 $Ref.null)))
(assert (= ($Snap.second $t@29@06) $Snap.unit))
; [eval] type_of(sys__result) == class_AddPayload()
; [eval] type_of(sys__result)
; [eval] class_AddPayload()
(assert (= (type_of<TYPE> sys__result@28@06) (as class_AddPayload<TYPE>  TYPE)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; __flatten_8__17 := __return_internal_addFromC_3_ex___return_internal_addFromC_3_ex_AddPayload(__flatten_7__16)
(declare-const sys__result@30@06 $Ref)
(declare-const $t@31@06 $Snap)
(assert (= $t@31@06 ($Snap.combine ($Snap.first $t@31@06) ($Snap.second $t@31@06))))
(assert (= ($Snap.first $t@31@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@30@06 $Ref.null)))
(assert (=
  ($Snap.second $t@31@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@31@06))
    ($Snap.second ($Snap.second $t@31@06)))))
(assert (= ($Snap.first ($Snap.second $t@31@06)) $Snap.unit))
; [eval] type_of(sys__result) == class___return_internal_addFromC_3_ex()
; [eval] type_of(sys__result)
; [eval] class___return_internal_addFromC_3_ex()
(assert (=
  (type_of<TYPE> sys__result@30@06)
  (as class___return_internal_addFromC_3_ex<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@31@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@31@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@31@06))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@31@06))) $Snap.unit))
; [eval] sys__result.__return_internal_addFromC_3_ex_value == returnValue
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@31@06))))
  sys__result@28@06))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; sys__exc := __flatten_8__17
; [exec]
; label catch_19
; [eval] !instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_addFromC_3_ex())
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_addFromC_3_ex())
; [eval] type_of(sys__exc)
; [eval] class___return_internal_addFromC_3_ex()
(push) ; 3
(pop) ; 3
; Joined path conditions
(set-option :timeout 10)
(push) ; 3
(assert (not (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@30@06) (as class___return_internal_addFromC_3_ex<TYPE>  TYPE))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               316
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   46
;  :datatype-splits         35
;  :decisions               46
;  :del-clause              17
;  :final-checks            28
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.35
;  :mk-bool-var             254
;  :mk-clause               19
;  :num-allocs              56571
;  :num-checks              17
;  :propagations            96
;  :quant-instantiations    16
;  :rlimit-count            15922)
; [then-branch: 9 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@30@06), class___return_internal_addFromC_3_ex[TYPE])) | dead]
; [else-branch: 9 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@30@06), class___return_internal_addFromC_3_ex[TYPE]) | live]
(push) ; 3
; [else-branch: 9 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@30@06), class___return_internal_addFromC_3_ex[TYPE])]
(assert (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@30@06) (as class___return_internal_addFromC_3_ex<TYPE>  TYPE)))
(pop) ; 3
; [eval] !!instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_addFromC_3_ex())
; [eval] !instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_addFromC_3_ex())
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_addFromC_3_ex())
; [eval] type_of(sys__exc)
; [eval] class___return_internal_addFromC_3_ex()
(push) ; 3
(pop) ; 3
; Joined path conditions
(push) ; 3
(assert (not (not
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@30@06) (as class___return_internal_addFromC_3_ex<TYPE>  TYPE)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               331
;  :binary-propagations     79
;  :conflicts               4
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   50
;  :datatype-splits         38
;  :decisions               50
;  :del-clause              19
;  :final-checks            30
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             262
;  :mk-clause               21
;  :num-allocs              57255
;  :num-checks              18
;  :propagations            98
;  :quant-instantiations    18
;  :rlimit-count            16171)
(push) ; 3
(assert (not (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@30@06) (as class___return_internal_addFromC_3_ex<TYPE>  TYPE))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               331
;  :binary-propagations     79
;  :conflicts               5
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   50
;  :datatype-splits         38
;  :decisions               50
;  :del-clause              21
;  :final-checks            30
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.35
;  :mk-bool-var             266
;  :mk-clause               23
;  :num-allocs              57327
;  :num-checks              19
;  :propagations            99
;  :quant-instantiations    21
;  :rlimit-count            16277)
; [then-branch: 10 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@30@06), class___return_internal_addFromC_3_ex[TYPE]) | live]
; [else-branch: 10 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@30@06), class___return_internal_addFromC_3_ex[TYPE])) | dead]
(push) ; 3
; [then-branch: 10 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@30@06), class___return_internal_addFromC_3_ex[TYPE])]
(assert (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@30@06) (as class___return_internal_addFromC_3_ex<TYPE>  TYPE)))
; [exec]
; inhale ucv_3__19 == sys__exc
(declare-const $t@32@06 $Snap)
(assert (= $t@32@06 $Snap.unit))
; [eval] ucv_3__19 == sys__exc
(assert (= ucv_3__19@23@06 sys__result@30@06))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; sys__exc := null
; [exec]
; sys__result := ucv_3__19.__return_internal_addFromC_3_ex_value
(set-option :timeout 10)
(push) ; 4
(assert (not (= sys__result@30@06 ucv_3__19@23@06)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               348
;  :binary-propagations     79
;  :conflicts               5
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 67
;  :datatype-occurs-check   54
;  :datatype-splits         41
;  :decisions               54
;  :del-clause              23
;  :final-checks            32
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             276
;  :mk-clause               25
;  :num-allocs              58059
;  :num-checks              21
;  :propagations            101
;  :quant-instantiations    23
;  :rlimit-count            16582)
(declare-const sys__result@33@06 $Ref)
(assert (=
  sys__result@33@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@31@06))))))
; [exec]
; // assert
; assert (sys__exc == null ==> acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state, write) && acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice, write) && (diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 16 && diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1 && sys__result != null)) && (sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true) && (sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()))
; [eval] sys__exc == null
(push) ; 4
(assert (not false))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               364
;  :binary-propagations     79
;  :conflicts               5
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 72
;  :datatype-occurs-check   58
;  :datatype-splits         44
;  :decisions               58
;  :del-clause              23
;  :final-checks            34
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             281
;  :mk-clause               25
;  :num-allocs              58749
;  :num-checks              22
;  :propagations            102
;  :quant-instantiations    23
;  :rlimit-count            16788)
; [then-branch: 11 | True | live]
; [else-branch: 11 | False | dead]
(push) ; 4
; [then-branch: 11 | True]
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 16
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1
; [eval] -1
; [eval] sys__result != null
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= sys__result@33@06 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               364
;  :binary-propagations     79
;  :conflicts               5
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 72
;  :datatype-occurs-check   58
;  :datatype-splits         44
;  :decisions               58
;  :del-clause              23
;  :final-checks            34
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             281
;  :mk-clause               25
;  :num-allocs              58770
;  :num-checks              23
;  :propagations            102
;  :quant-instantiations    23
;  :rlimit-count            16811)
(assert (not (= sys__result@33@06 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 5
; [then-branch: 12 | False | dead]
; [else-branch: 12 | True | live]
(push) ; 6
; [else-branch: 12 | True]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 5
; [then-branch: 13 | False | dead]
; [else-branch: 13 | True | live]
(push) ; 6
; [else-branch: 13 | True]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [exec]
; inhale false
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
