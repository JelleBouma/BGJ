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
; ---------- java_DOT_lang_DOT_Object_Object_EncodedGlobalVariables ----------
(declare-const globals@0@08 $Ref)
(declare-const sys__result@1@08 $Ref)
(declare-const globals@2@08 $Ref)
(declare-const sys__result@3@08 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@4@08 $Snap)
(assert (= $t@4@08 ($Snap.combine ($Snap.first $t@4@08) ($Snap.second $t@4@08))))
(assert (= ($Snap.first $t@4@08) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@3@08 $Ref.null)))
(assert (= ($Snap.second $t@4@08) $Snap.unit))
; [eval] type_of(sys__result) == class_java_DOT_lang_DOT_Object()
; [eval] type_of(sys__result)
; [eval] class_java_DOT_lang_DOT_Object()
(assert (=
  (type_of<TYPE> sys__result@3@08)
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- __return_internal_addFromC_3_ex___return_internal_addFromC_3_ex_AddPayload ----------
(declare-const returnValue@5@08 $Ref)
(declare-const sys__result@6@08 $Ref)
(declare-const returnValue@7@08 $Ref)
(declare-const sys__result@8@08 $Ref)
(push) ; 1
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@9@08 $Snap)
(assert (= $t@9@08 ($Snap.combine ($Snap.first $t@9@08) ($Snap.second $t@9@08))))
(assert (= ($Snap.first $t@9@08) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@8@08 $Ref.null)))
(assert (=
  ($Snap.second $t@9@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@9@08))
    ($Snap.second ($Snap.second $t@9@08)))))
(assert (= ($Snap.first ($Snap.second $t@9@08)) $Snap.unit))
; [eval] type_of(sys__result) == class___return_internal_addFromC_3_ex()
; [eval] type_of(sys__result)
; [eval] class___return_internal_addFromC_3_ex()
(assert (=
  (type_of<TYPE> sys__result@8@08)
  (as class___return_internal_addFromC_3_ex<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@9@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@9@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@9@08))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@9@08))) $Snap.unit))
; [eval] sys__result.__return_internal_addFromC_3_ex_value == returnValue
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@9@08))))
  returnValue@7@08))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_internal_receiveExternalChoice_java_DOT_lang_DOT_Object_EncodedGlobalVariables ----------
(declare-const diz@10@08 $Ref)
(declare-const globals@11@08 $Ref)
(declare-const sys__result@12@08 Int)
(declare-const sys__exc@13@08 $Ref)
(declare-const diz@14@08 $Ref)
(declare-const globals@15@08 $Ref)
(declare-const sys__result@16@08 Int)
(declare-const sys__exc@17@08 $Ref)
(push) ; 1
(declare-const $t@18@08 $Snap)
(assert (= $t@18@08 ($Snap.combine ($Snap.first $t@18@08) ($Snap.second $t@18@08))))
(assert (= ($Snap.first $t@18@08) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@14@08 $Ref.null)))
(assert (=
  ($Snap.second $t@18@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@18@08))
    ($Snap.second ($Snap.second $t@18@08)))))
(assert (=
  ($Snap.second ($Snap.second $t@18@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@18@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@18@08))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@18@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@08)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@08))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1
; [eval] -1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@18@08))))
  (- 0 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@08))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 || diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(push) ; 2
; [then-branch: 0 | First:(Second:($t@18@08)) == 14 | live]
; [else-branch: 0 | First:(Second:($t@18@08)) != 14 | live]
(push) ; 3
; [then-branch: 0 | First:(Second:($t@18@08)) == 14]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))
(pop) ; 3
(push) ; 3
; [else-branch: 0 | First:(Second:($t@18@08)) != 14]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14)))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@19@08 $Snap)
(assert (= $t@19@08 ($Snap.combine ($Snap.first $t@19@08) ($Snap.second $t@19@08))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@17@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               78
;  :binary-propagations     79
;  :conflicts               1
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   6
;  :datatype-splits         8
;  :decisions               9
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.30
;  :mk-bool-var             147
;  :mk-clause               2
;  :num-allocs              49197
;  :num-checks              4
;  :propagations            80
;  :quant-instantiations    2
;  :rlimit-count            11132)
(push) ; 3
(assert (not (= sys__exc@17@08 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               95
;  :binary-propagations     79
;  :conflicts               1
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   9
;  :datatype-splits         12
;  :decisions               14
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.30
;  :mk-bool-var             153
;  :mk-clause               2
;  :num-allocs              49817
;  :num-checks              5
;  :propagations            81
;  :quant-instantiations    2
;  :rlimit-count            11349)
; [then-branch: 1 | sys__exc@17@08 == Null | live]
; [else-branch: 1 | sys__exc@17@08 != Null | live]
(push) ; 3
; [then-branch: 1 | sys__exc@17@08 == Null]
(assert (= sys__exc@17@08 $Ref.null))
(assert (=
  ($Snap.first $t@19@08)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@19@08))
    ($Snap.second ($Snap.first $t@19@08)))))
(assert (=
  ($Snap.second ($Snap.first $t@19@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.first $t@19@08)))
    ($Snap.second ($Snap.second ($Snap.first $t@19@08))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.first $t@19@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.first $t@19@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@19@08)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.first $t@19@08)))) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 0 || diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 1
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 0
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(push) ; 4
; [then-branch: 2 | First:(First:($t@19@08)) == 14 | live]
; [else-branch: 2 | First:(First:($t@19@08)) != 14 | live]
(push) ; 5
; [then-branch: 2 | First:(First:($t@19@08)) == 14]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08))) 14))
; [eval] sys__result == 0
(pop) ; 5
(push) ; 5
; [else-branch: 2 | First:(First:($t@19@08)) != 14]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08))) 14)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 3 | sys__result@16@08 == 0 && First:(First:($t@19@08)) == 14 | live]
; [else-branch: 3 | !(sys__result@16@08 == 0 && First:(First:($t@19@08)) == 14) | live]
(push) ; 5
; [then-branch: 3 | sys__result@16@08 == 0 && First:(First:($t@19@08)) == 14]
(assert (and
  (= sys__result@16@08 0)
  (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08))) 14)))
(pop) ; 5
(push) ; 5
; [else-branch: 3 | !(sys__result@16@08 == 0 && First:(First:($t@19@08)) == 14)]
(assert (not
  (and
    (= sys__result@16@08 0)
    (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08))) 14))))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 1
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(push) ; 6
; [then-branch: 4 | First:(First:($t@19@08)) == 14 | live]
; [else-branch: 4 | First:(First:($t@19@08)) != 14 | live]
(push) ; 7
; [then-branch: 4 | First:(First:($t@19@08)) == 14]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08))) 14))
; [eval] sys__result == 1
(pop) ; 7
(push) ; 7
; [else-branch: 4 | First:(First:($t@19@08)) != 14]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08))) 14)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (or
  (and
    (= sys__result@16@08 0)
    (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08))) 14))
  (and
    (= sys__result@16@08 1)
    (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08))) 14))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@19@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@19@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@19@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@19@08)))))
  $Snap.unit))
; [eval] old(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state) == diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state
; [eval] old(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08)))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@19@08)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.first $t@19@08)))))
  $Snap.unit))
; [eval] sys__result == diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice
(assert (=
  sys__result@16@08
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.first $t@19@08))))))
(assert (=
  ($Snap.second $t@19@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@19@08))
    ($Snap.second ($Snap.second $t@19@08)))))
(assert (= ($Snap.first ($Snap.second $t@19@08)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 5 | sys__exc@17@08 != Null | live]
; [else-branch: 5 | sys__exc@17@08 == Null | live]
(push) ; 5
; [then-branch: 5 | sys__exc@17@08 != Null]
(assert (not (= sys__exc@17@08 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 5 | sys__exc@17@08 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@17@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@17@08 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               128
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   9
;  :datatype-splits         12
;  :decisions               14
;  :del-clause              1
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             171
;  :mk-clause               4
;  :num-allocs              50380
;  :num-checks              6
;  :propagations            81
;  :quant-instantiations    4
;  :rlimit-count            12571)
; [then-branch: 6 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@17@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@17@08 != Null | dead]
; [else-branch: 6 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@17@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@17@08 != Null) | live]
(push) ; 5
; [else-branch: 6 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@17@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@17@08 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@17@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@17@08 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@19@08)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 7 | sys__exc@17@08 != Null | dead]
; [else-branch: 7 | sys__exc@17@08 == Null | live]
(push) ; 5
; [else-branch: 7 | sys__exc@17@08 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 1 | sys__exc@17@08 != Null]
(assert (not (= sys__exc@17@08 $Ref.null)))
(assert (= ($Snap.first $t@19@08) $Snap.unit))
(assert (=
  ($Snap.second $t@19@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@19@08))
    ($Snap.second ($Snap.second $t@19@08)))))
(assert (= ($Snap.first ($Snap.second $t@19@08)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 8 | sys__exc@17@08 != Null | live]
; [else-branch: 8 | sys__exc@17@08 == Null | live]
(push) ; 5
; [then-branch: 8 | sys__exc@17@08 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 8 | sys__exc@17@08 == Null]
(assert (= sys__exc@17@08 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@17@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@17@08 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               155
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   13
;  :datatype-splits         15
;  :decisions               19
;  :del-clause              9
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             188
;  :mk-clause               11
;  :num-allocs              51308
;  :num-checks              7
;  :propagations            84
;  :quant-instantiations    7
;  :rlimit-count            13210)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@17@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@17@08 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               170
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 27
;  :datatype-occurs-check   17
;  :datatype-splits         18
;  :decisions               23
;  :del-clause              16
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             200
;  :mk-clause               18
;  :num-allocs              51982
;  :num-checks              8
;  :propagations            89
;  :quant-instantiations    10
;  :rlimit-count            13493)
; [then-branch: 9 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@17@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@17@08 != Null | live]
; [else-branch: 9 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@17@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@17@08 != Null) | live]
(push) ; 5
; [then-branch: 9 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@17@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@17@08 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@17@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@17@08 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 9 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@17@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@17@08 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@17@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@17@08 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@19@08)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@17@08 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               184
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   21
;  :datatype-splits         20
;  :decisions               26
;  :del-clause              16
;  :final-checks            15
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             204
;  :mk-clause               18
;  :num-allocs              52628
;  :num-checks              9
;  :propagations            90
;  :quant-instantiations    10
;  :rlimit-count            13730)
(push) ; 5
(assert (not (not (= sys__exc@17@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               184
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   21
;  :datatype-splits         20
;  :decisions               26
;  :del-clause              16
;  :final-checks            15
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             204
;  :mk-clause               18
;  :num-allocs              52642
;  :num-checks              10
;  :propagations            90
;  :quant-instantiations    10
;  :rlimit-count            13741)
; [then-branch: 10 | sys__exc@17@08 != Null | live]
; [else-branch: 10 | sys__exc@17@08 == Null | dead]
(push) ; 5
; [then-branch: 10 | sys__exc@17@08 != Null]
(assert (not (= sys__exc@17@08 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 11 | sys__exc@17@08 != Null | live]
; [else-branch: 11 | sys__exc@17@08 == Null | live]
(push) ; 7
; [then-branch: 11 | sys__exc@17@08 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 11 | sys__exc@17@08 == Null]
(assert (= sys__exc@17@08 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@17@08 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@17@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@17@08 $Ref.null)))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var ucv_2__14: Ref
(declare-const ucv_2__14@20@08 $Ref)
; [exec]
; var __flatten_4__11: Ref
(declare-const __flatten_4__11@21@08 $Ref)
; [exec]
; var __flatten_5__12: Ref
(declare-const __flatten_5__12@22@08 $Ref)
; [exec]
; var old__sys_exc_16__13: Ref
(declare-const old__sys_exc_16__13@23@08 $Ref)
; [exec]
; sys__exc := null
; [exec]
; old__sys_exc_16__13 := sys__exc
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               196
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 35
;  :datatype-occurs-check   23
;  :datatype-splits         22
;  :decisions               29
;  :del-clause              16
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             207
;  :mk-clause               18
;  :num-allocs              53200
;  :num-checks              11
;  :propagations            91
;  :quant-instantiations    10
;  :rlimit-count            13929)
; [then-branch: 12 | First:(Second:($t@18@08)) == 14 | live]
; [else-branch: 12 | First:(Second:($t@18@08)) != 14 | dead]
(push) ; 3
; [then-branch: 12 | First:(Second:($t@18@08)) == 14]
; [exec]
; diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice := 0
; [exec]
; __flatten_4__11 := __return_internal_receiveExternalChoice_2_ex___return_internal_receiveExternalChoice_2_ex_Integer(0)
(declare-const sys__result@24@08 $Ref)
(declare-const $t@25@08 $Snap)
(assert (= $t@25@08 ($Snap.combine ($Snap.first $t@25@08) ($Snap.second $t@25@08))))
(assert (= ($Snap.first $t@25@08) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@24@08 $Ref.null)))
(assert (=
  ($Snap.second $t@25@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@25@08))
    ($Snap.second ($Snap.second $t@25@08)))))
(assert (= ($Snap.first ($Snap.second $t@25@08)) $Snap.unit))
; [eval] type_of(sys__result) == class___return_internal_receiveExternalChoice_2_ex()
; [eval] type_of(sys__result)
; [eval] class___return_internal_receiveExternalChoice_2_ex()
(assert (=
  (type_of<TYPE> sys__result@24@08)
  (as class___return_internal_receiveExternalChoice_2_ex<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@25@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@25@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@25@08))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@25@08))) $Snap.unit))
; [eval] sys__result.__return_internal_receiveExternalChoice_2_ex_value == returnValue
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@25@08))))
  0))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; sys__exc := __flatten_4__11
; [exec]
; label catch_14
; [eval] !instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_receiveExternalChoice_2_ex())
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_receiveExternalChoice_2_ex())
; [eval] type_of(sys__exc)
; [eval] class___return_internal_receiveExternalChoice_2_ex()
(push) ; 4
(pop) ; 4
; Joined path conditions
(set-option :timeout 10)
(push) ; 4
(assert (not (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@24@08) (as class___return_internal_receiveExternalChoice_2_ex<TYPE>  TYPE))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               254
;  :binary-propagations     79
;  :conflicts               5
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 46
;  :datatype-occurs-check   31
;  :datatype-splits         29
;  :decisions               37
;  :del-clause              18
;  :final-checks            21
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.35
;  :mk-bool-var             238
;  :mk-clause               22
;  :num-allocs              54174
;  :num-checks              13
;  :propagations            93
;  :quant-instantiations    14
;  :rlimit-count            14879)
; [then-branch: 13 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@24@08), class___return_internal_receiveExternalChoice_2_ex[TYPE])) | dead]
; [else-branch: 13 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@24@08), class___return_internal_receiveExternalChoice_2_ex[TYPE]) | live]
(push) ; 4
; [else-branch: 13 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@24@08), class___return_internal_receiveExternalChoice_2_ex[TYPE])]
(assert (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@24@08) (as class___return_internal_receiveExternalChoice_2_ex<TYPE>  TYPE)))
(pop) ; 4
; [eval] !!instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_receiveExternalChoice_2_ex())
; [eval] !instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_receiveExternalChoice_2_ex())
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class___return_internal_receiveExternalChoice_2_ex())
; [eval] type_of(sys__exc)
; [eval] class___return_internal_receiveExternalChoice_2_ex()
(push) ; 4
(pop) ; 4
; Joined path conditions
(push) ; 4
(assert (not (not
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@24@08) (as class___return_internal_receiveExternalChoice_2_ex<TYPE>  TYPE)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               283
;  :binary-propagations     79
;  :conflicts               5
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 55
;  :datatype-occurs-check   39
;  :datatype-splits         36
;  :decisions               43
;  :del-clause              20
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             245
;  :mk-clause               24
;  :num-allocs              54884
;  :num-checks              14
;  :propagations            97
;  :quant-instantiations    16
;  :rlimit-count            15178)
(push) ; 4
(assert (not (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@24@08) (as class___return_internal_receiveExternalChoice_2_ex<TYPE>  TYPE))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               283
;  :binary-propagations     79
;  :conflicts               6
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 55
;  :datatype-occurs-check   39
;  :datatype-splits         36
;  :decisions               43
;  :del-clause              22
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.35
;  :mk-bool-var             249
;  :mk-clause               26
;  :num-allocs              54956
;  :num-checks              15
;  :propagations            98
;  :quant-instantiations    19
;  :rlimit-count            15284)
; [then-branch: 14 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@24@08), class___return_internal_receiveExternalChoice_2_ex[TYPE]) | live]
; [else-branch: 14 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@24@08), class___return_internal_receiveExternalChoice_2_ex[TYPE])) | dead]
(push) ; 4
; [then-branch: 14 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__result@24@08), class___return_internal_receiveExternalChoice_2_ex[TYPE])]
(assert (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__result@24@08) (as class___return_internal_receiveExternalChoice_2_ex<TYPE>  TYPE)))
; [exec]
; inhale ucv_2__14 == sys__exc
(declare-const $t@26@08 $Snap)
(assert (= $t@26@08 $Snap.unit))
; [eval] ucv_2__14 == sys__exc
(assert (= ucv_2__14@20@08 sys__result@24@08))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; sys__exc := null
; [exec]
; sys__result := ucv_2__14.__return_internal_receiveExternalChoice_2_ex_value
(set-option :timeout 10)
(push) ; 5
(assert (not (= sys__result@24@08 ucv_2__14@20@08)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               314
;  :binary-propagations     79
;  :conflicts               6
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   47
;  :datatype-splits         43
;  :decisions               49
;  :del-clause              24
;  :final-checks            27
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             258
;  :mk-clause               28
;  :num-allocs              55706
;  :num-checks              17
;  :propagations            102
;  :quant-instantiations    21
;  :rlimit-count            15639)
(declare-const sys__result@27@08 Int)
(assert (=
  sys__result@27@08
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@25@08))))))
; [exec]
; // assert
; assert (sys__exc == null ==> acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state, write) && acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice, write) && ((diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 0 || diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 1) && old(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state) == diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state && sys__result == diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice)) && (sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true) && (sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()))
; [eval] sys__exc == null
(push) ; 5
(assert (not false))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               344
;  :binary-propagations     79
;  :conflicts               6
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   55
;  :datatype-splits         50
;  :decisions               55
;  :del-clause              24
;  :final-checks            30
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             262
;  :mk-clause               28
;  :num-allocs              56417
;  :num-checks              18
;  :propagations            105
;  :quant-instantiations    21
;  :rlimit-count            15895)
; [then-branch: 15 | True | live]
; [else-branch: 15 | False | dead]
(push) ; 5
; [then-branch: 15 | True]
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 0 || diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 1
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 0
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(push) ; 6
; [then-branch: 16 | First:(Second:($t@18@08)) == 14 | live]
; [else-branch: 16 | First:(Second:($t@18@08)) != 14 | live]
(push) ; 7
; [then-branch: 16 | First:(Second:($t@18@08)) == 14]
; [eval] sys__result == 0
(pop) ; 7
(push) ; 7
; [else-branch: 16 | First:(Second:($t@18@08)) != 14]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 17 | sys__result@27@08 == 0 && First:(Second:($t@18@08)) == 14 | live]
; [else-branch: 17 | !(sys__result@27@08 == 0 && First:(Second:($t@18@08)) == 14) | live]
(push) ; 7
; [then-branch: 17 | sys__result@27@08 == 0 && First:(Second:($t@18@08)) == 14]
(assert (and
  (= sys__result@27@08 0)
  (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14)))
(pop) ; 7
(push) ; 7
; [else-branch: 17 | !(sys__result@27@08 == 0 && First:(Second:($t@18@08)) == 14)]
(assert (not
  (and
    (= sys__result@27@08 0)
    (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && sys__result == 1
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(push) ; 8
; [then-branch: 18 | First:(Second:($t@18@08)) == 14 | live]
; [else-branch: 18 | First:(Second:($t@18@08)) != 14 | live]
(push) ; 9
; [then-branch: 18 | First:(Second:($t@18@08)) == 14]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))
; [eval] sys__result == 1
(pop) ; 9
(push) ; 9
; [else-branch: 18 | First:(Second:($t@18@08)) != 14]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 6
(assert (not (or
  (and
    (= sys__result@27@08 0)
    (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))
  (and
    (= sys__result@27@08 1)
    (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               344
;  :binary-propagations     79
;  :conflicts               7
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   55
;  :datatype-splits         50
;  :decisions               55
;  :del-clause              24
;  :final-checks            30
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             262
;  :mk-clause               28
;  :num-allocs              56448
;  :num-checks              19
;  :propagations            105
;  :quant-instantiations    21
;  :rlimit-count            15977)
(assert (or
  (and
    (= sys__result@27@08 0)
    (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))
  (and
    (= sys__result@27@08 1)
    (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))))
; [eval] old(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state) == diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state
; [eval] old(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state)
; [eval] sys__result == diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice
(push) ; 6
(assert (not (= sys__result@27@08 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               344
;  :binary-propagations     79
;  :conflicts               7
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   55
;  :datatype-splits         50
;  :decisions               55
;  :del-clause              24
;  :final-checks            30
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             262
;  :mk-clause               28
;  :num-allocs              56461
;  :num-checks              20
;  :propagations            105
;  :quant-instantiations    21
;  :rlimit-count            15999)
(assert (= sys__result@27@08 0))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 19 | False | dead]
; [else-branch: 19 | True | live]
(push) ; 7
; [else-branch: 19 | True]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 20 | False | dead]
; [else-branch: 20 | True | live]
(push) ; 7
; [else-branch: 20 | True]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [exec]
; inhale false
(pop) ; 5
(pop) ; 4
(pop) ; 3
; [eval] !(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14)
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               344
;  :binary-propagations     79
;  :conflicts               7
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   55
;  :datatype-splits         50
;  :decisions               55
;  :del-clause              26
;  :final-checks            30
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.36
;  :mk-bool-var             262
;  :mk-clause               28
;  :num-allocs              56477
;  :num-checks              21
;  :propagations            105
;  :quant-instantiations    21
;  :rlimit-count            16033)
; [then-branch: 21 | First:(Second:($t@18@08)) != 14 | dead]
; [else-branch: 21 | First:(Second:($t@18@08)) == 14 | live]
(push) ; 3
; [else-branch: 21 | First:(Second:($t@18@08)) == 14]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@18@08))) 14))
(pop) ; 3
(pop) ; 2
(pop) ; 1
