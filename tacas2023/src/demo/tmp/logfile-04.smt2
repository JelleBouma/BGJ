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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities___contract_unsatisfiable__random_EncodedGlobalVariables_Integer ----------
(declare-const globals@0@04 $Ref)
(declare-const bound@1@04 Int)
(declare-const sys__result@2@04 Int)
(declare-const globals@3@04 $Ref)
(declare-const bound@4@04 Int)
(declare-const sys__result@5@04 Int)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && 0 < bound
(declare-const $t@6@04 $Snap)
(assert (= $t@6@04 ($Snap.combine ($Snap.first $t@6@04) ($Snap.second $t@6@04))))
(assert (= ($Snap.first $t@6@04) $Snap.unit))
(assert (= ($Snap.second $t@6@04) $Snap.unit))
; [eval] 0 < bound
(assert (< 0 bound@4@04))
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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_AdderS_EncodedGlobalVariables_Integer ----------
(declare-const globals@7@04 $Ref)
(declare-const port@8@04 Int)
(declare-const sys__result@9@04 $Ref)
(declare-const globals@10@04 $Ref)
(declare-const port@11@04 Int)
(declare-const sys__result@12@04 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@13@04 $Snap)
(assert (= $t@13@04 ($Snap.combine ($Snap.first $t@13@04) ($Snap.second $t@13@04))))
(assert (= ($Snap.first $t@13@04) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@12@04 $Ref.null)))
(assert (=
  ($Snap.second $t@13@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@13@04))
    ($Snap.second ($Snap.second $t@13@04)))))
(assert (= ($Snap.first ($Snap.second $t@13@04)) $Snap.unit))
; [eval] type_of(sys__result) == class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS()
; [eval] type_of(sys__result)
; [eval] class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS()
(assert (=
  (type_of<TYPE> sys__result@12@04)
  (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@13@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@13@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@13@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))
  $Snap.unit))
; [eval] sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@13@04))))
  14))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
  $Snap.unit))
; [eval] sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == -1
; [eval] -1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))
  (- 0 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))
  $Snap.unit))
; [eval] sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_EXTERNAL_CHOICE_ADD == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))
  0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))
  $Snap.unit))
; [eval] sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_EXTERNAL_CHOICE_BYE == 1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))
  1))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS___contract_unsatisfiable__internal_addFromC_EncodedGlobalVariables ----------
(declare-const diz@14@04 $Ref)
(declare-const globals@15@04 $Ref)
(declare-const sys__result@16@04 $Ref)
(declare-const diz@17@04 $Ref)
(declare-const globals@18@04 $Ref)
(declare-const sys__result@19@04 $Ref)
(push) ; 1
(declare-const $t@20@04 $Snap)
(assert (= $t@20@04 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@17@04 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state, write) && acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice, write) && (diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == 0))
(declare-const $t@21@04 $Snap)
(assert (= $t@21@04 ($Snap.combine ($Snap.first $t@21@04) ($Snap.second $t@21@04))))
(assert (= ($Snap.first $t@21@04) $Snap.unit))
(assert (=
  ($Snap.second $t@21@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@21@04))
    ($Snap.second ($Snap.second $t@21@04)))))
(assert (=
  ($Snap.second ($Snap.second $t@21@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@21@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@21@04))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@21@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@21@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@04)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@21@04))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@21@04))) 14))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@04))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@21@04))))
  0))
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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS___contract_unsatisfiable__internal_byeFromC_EncodedGlobalVariables ----------
(declare-const diz@22@04 $Ref)
(declare-const globals@23@04 $Ref)
(declare-const diz@24@04 $Ref)
(declare-const globals@25@04 $Ref)
(push) ; 1
(declare-const $t@26@04 $Snap)
(assert (= $t@26@04 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@24@04 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state, write) && acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice, write) && (diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14 && diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == 1))
(declare-const $t@27@04 $Snap)
(assert (= $t@27@04 ($Snap.combine ($Snap.first $t@27@04) ($Snap.second $t@27@04))))
(assert (= ($Snap.first $t@27@04) $Snap.unit))
(assert (=
  ($Snap.second $t@27@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@27@04))
    ($Snap.second ($Snap.second $t@27@04)))))
(assert (=
  ($Snap.second ($Snap.second $t@27@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@27@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@27@04))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@27@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@04))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@27@04))) 14))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04))))
  $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_choice == 1
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@27@04))))
  1))
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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS___contract_unsatisfiable__internal_resToC_EncodedGlobalVariables_Integer ----------
(declare-const diz@28@04 $Ref)
(declare-const globals@29@04 $Ref)
(declare-const arg0@30@04 Int)
(declare-const diz@31@04 $Ref)
(declare-const globals@32@04 $Ref)
(declare-const arg0@33@04 Int)
(push) ; 1
(declare-const $t@34@04 $Snap)
(assert (= $t@34@04 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@31@04 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state, write) && diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 16)
(declare-const $t@35@04 $Snap)
(assert (= $t@35@04 ($Snap.combine ($Snap.first $t@35@04) ($Snap.second $t@35@04))))
(assert (= ($Snap.first $t@35@04) $Snap.unit))
(assert (=
  ($Snap.second $t@35@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@35@04))
    ($Snap.second ($Snap.second $t@35@04)))))
(assert (= ($Snap.second ($Snap.second $t@35@04)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 16
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@35@04))) 16))
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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_internal_resToC_java_DOT_lang_DOT_Object_EncodedGlobalVariables_Integer ----------
(declare-const diz@36@04 $Ref)
(declare-const globals@37@04 $Ref)
(declare-const arg0@38@04 Int)
(declare-const sys__exc@39@04 $Ref)
(declare-const diz@40@04 $Ref)
(declare-const globals@41@04 $Ref)
(declare-const arg0@42@04 Int)
(declare-const sys__exc@43@04 $Ref)
(push) ; 1
(declare-const $t@44@04 $Snap)
(assert (= $t@44@04 ($Snap.combine ($Snap.first $t@44@04) ($Snap.second $t@44@04))))
(assert (= ($Snap.first $t@44@04) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@40@04 $Ref.null)))
(assert (=
  ($Snap.second $t@44@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@44@04))
    ($Snap.second ($Snap.second $t@44@04)))))
(assert (= ($Snap.second ($Snap.second $t@44@04)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 16
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@44@04))) 16))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@45@04 $Snap)
(assert (= $t@45@04 ($Snap.combine ($Snap.first $t@45@04) ($Snap.second $t@45@04))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@43@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               230
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   58
;  :datatype-splits         24
;  :decisions               34
;  :del-clause              2
;  :final-checks            36
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.31
;  :mk-bool-var             202
;  :mk-clause               3
;  :num-allocs              59803
;  :num-checks              23
;  :propagations            85
;  :quant-instantiations    6
;  :rlimit-count            14710)
(push) ; 3
(assert (not (= sys__exc@43@04 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               237
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               2
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   61
;  :datatype-splits         26
;  :decisions               37
;  :del-clause              2
;  :final-checks            38
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.31
;  :mk-bool-var             205
;  :mk-clause               3
;  :num-allocs              60391
;  :num-checks              24
;  :propagations            85
;  :quant-instantiations    6
;  :rlimit-count            14887)
; [then-branch: 0 | sys__exc@43@04 == Null | live]
; [else-branch: 0 | sys__exc@43@04 != Null | live]
(push) ; 3
; [then-branch: 0 | sys__exc@43@04 == Null]
(assert (= sys__exc@43@04 $Ref.null))
(assert (=
  ($Snap.first $t@45@04)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@45@04))
    ($Snap.second ($Snap.first $t@45@04)))))
(assert (= ($Snap.second ($Snap.first $t@45@04)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@45@04))) 14))
(assert (=
  ($Snap.second $t@45@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@45@04))
    ($Snap.second ($Snap.second $t@45@04)))))
(assert (= ($Snap.first ($Snap.second $t@45@04)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 1 | sys__exc@43@04 != Null | live]
; [else-branch: 1 | sys__exc@43@04 == Null | live]
(push) ; 5
; [then-branch: 1 | sys__exc@43@04 != Null]
(assert (not (= sys__exc@43@04 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 1 | sys__exc@43@04 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@43@04) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@43@04 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               252
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   61
;  :datatype-splits         26
;  :decisions               37
;  :del-clause              2
;  :final-checks            38
;  :max-generation          1
;  :max-memory              3.54
;  :memory                  3.32
;  :mk-bool-var             212
;  :mk-clause               3
;  :num-allocs              60597
;  :num-checks              25
;  :propagations            85
;  :quant-instantiations    7
;  :rlimit-count            15331)
; [then-branch: 2 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@43@04), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@43@04 != Null | dead]
; [else-branch: 2 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@43@04), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@43@04 != Null) | live]
(push) ; 5
; [else-branch: 2 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@43@04), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@43@04 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@43@04) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@43@04 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@45@04)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 3 | sys__exc@43@04 != Null | dead]
; [else-branch: 3 | sys__exc@43@04 == Null | live]
(push) ; 5
; [else-branch: 3 | sys__exc@43@04 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 0 | sys__exc@43@04 != Null]
(assert (not (= sys__exc@43@04 $Ref.null)))
(assert (= ($Snap.first $t@45@04) $Snap.unit))
(assert (=
  ($Snap.second $t@45@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@45@04))
    ($Snap.second ($Snap.second $t@45@04)))))
(assert (= ($Snap.first ($Snap.second $t@45@04)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 4 | sys__exc@43@04 != Null | live]
; [else-branch: 4 | sys__exc@43@04 == Null | live]
(push) ; 5
; [then-branch: 4 | sys__exc@43@04 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 4 | sys__exc@43@04 == Null]
(assert (= sys__exc@43@04 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@43@04) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@43@04 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               269
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   65
;  :datatype-splits         27
;  :decisions               40
;  :del-clause              9
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.33
;  :mk-bool-var             226
;  :mk-clause               10
;  :num-allocs              61446
;  :num-checks              26
;  :propagations            87
;  :quant-instantiations    10
;  :rlimit-count            15930)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@43@04) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@43@04 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               275
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   69
;  :datatype-splits         28
;  :decisions               42
;  :del-clause              16
;  :final-checks            42
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             235
;  :mk-clause               17
;  :num-allocs              62084
;  :num-checks              27
;  :propagations            91
;  :quant-instantiations    13
;  :rlimit-count            16174)
; [then-branch: 5 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@43@04), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@43@04 != Null | live]
; [else-branch: 5 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@43@04), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@43@04 != Null) | live]
(push) ; 5
; [then-branch: 5 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@43@04), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@43@04 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@43@04) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@43@04 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 5 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@43@04), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@43@04 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@43@04) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@43@04 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@45@04)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@43@04 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               280
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   70
;  :datatype-splits         28
;  :decisions               43
;  :del-clause              16
;  :final-checks            43
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             236
;  :mk-clause               17
;  :num-allocs              62695
;  :num-checks              28
;  :propagations            91
;  :quant-instantiations    13
;  :rlimit-count            16359)
(push) ; 5
(assert (not (not (= sys__exc@43@04 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               280
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   70
;  :datatype-splits         28
;  :decisions               43
;  :del-clause              16
;  :final-checks            43
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             236
;  :mk-clause               17
;  :num-allocs              62710
;  :num-checks              29
;  :propagations            91
;  :quant-instantiations    13
;  :rlimit-count            16370)
; [then-branch: 6 | sys__exc@43@04 != Null | live]
; [else-branch: 6 | sys__exc@43@04 == Null | dead]
(push) ; 5
; [then-branch: 6 | sys__exc@43@04 != Null]
(assert (not (= sys__exc@43@04 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 7 | sys__exc@43@04 != Null | live]
; [else-branch: 7 | sys__exc@43@04 == Null | live]
(push) ; 7
; [then-branch: 7 | sys__exc@43@04 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 7 | sys__exc@43@04 == Null]
(assert (= sys__exc@43@04 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@43@04 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@43@04) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@43@04 $Ref.null)))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; sys__exc := null
; [exec]
; diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state := 14
; [exec]
; label method_end_internal_resToC_25
; [eval] sys__exc == null
(push) ; 3
(assert (not false))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               282
;  :arith-assert-lower      1
;  :binary-propagations     79
;  :conflicts               3
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 51
;  :datatype-occurs-check   71
;  :datatype-splits         28
;  :decisions               44
;  :del-clause              16
;  :final-checks            44
;  :max-generation          2
;  :max-memory              3.54
;  :memory                  3.34
;  :mk-bool-var             236
;  :mk-clause               17
;  :num-allocs              63235
;  :num-checks              30
;  :propagations            91
;  :quant-instantiations    13
;  :rlimit-count            16501)
; [then-branch: 8 | True | live]
; [else-branch: 8 | False | dead]
(push) ; 3
; [then-branch: 8 | True]
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderS_state == 14
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 9 | False | dead]
; [else-branch: 9 | True | live]
(push) ; 5
; [else-branch: 9 | True]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 10 | False | dead]
; [else-branch: 10 | True | live]
(push) ; 5
; [else-branch: 10 | True]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(pop) ; 2
(pop) ; 1
