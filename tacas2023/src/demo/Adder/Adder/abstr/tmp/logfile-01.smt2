(get-info :version)
; (:version "4.8.6")
; Started: 2022-10-12 23:40:37
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
(declare-sort VCTArray<Ref>)
(declare-sort frac)
(declare-sort TYPE)
(declare-sort zfrac)
(declare-sort VCTOption<VCTArray<Ref>>)
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
(declare-fun $SortWrappers.VCTArray<Ref>To$Snap (VCTArray<Ref>) $Snap)
(declare-fun $SortWrappers.$SnapToVCTArray<Ref> ($Snap) VCTArray<Ref>)
(assert (forall ((x VCTArray<Ref>)) (!
    (= x ($SortWrappers.$SnapToVCTArray<Ref>($SortWrappers.VCTArray<Ref>To$Snap x)))
    :pattern (($SortWrappers.VCTArray<Ref>To$Snap x))
    :qid |$Snap.$SnapToVCTArray<Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.VCTArray<Ref>To$Snap($SortWrappers.$SnapToVCTArray<Ref> x)))
    :pattern (($SortWrappers.$SnapToVCTArray<Ref> x))
    :qid |$Snap.VCTArray<Ref>To$SnapToVCTArray<Ref>|
    )))
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
(declare-fun $SortWrappers.VCTOption<VCTArray<Ref>>To$Snap (VCTOption<VCTArray<Ref>>) $Snap)
(declare-fun $SortWrappers.$SnapToVCTOption<VCTArray<Ref>> ($Snap) VCTOption<VCTArray<Ref>>)
(assert (forall ((x VCTOption<VCTArray<Ref>>)) (!
    (= x ($SortWrappers.$SnapToVCTOption<VCTArray<Ref>>($SortWrappers.VCTOption<VCTArray<Ref>>To$Snap x)))
    :pattern (($SortWrappers.VCTOption<VCTArray<Ref>>To$Snap x))
    :qid |$Snap.$SnapToVCTOption<VCTArray<Ref>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.VCTOption<VCTArray<Ref>>To$Snap($SortWrappers.$SnapToVCTOption<VCTArray<Ref>> x)))
    :pattern (($SortWrappers.$SnapToVCTOption<VCTArray<Ref>> x))
    :qid |$Snap.VCTOption<VCTArray<Ref>>To$SnapToVCTOption<VCTArray<Ref>>|
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
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities<TYPE> TYPE)
(declare-const class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC<TYPE> TYPE)
(declare-const class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Client<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_String<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Throwable<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Exception<TYPE> TYPE)
(declare-const class_java_DOT_util_DOT_Comparator<TYPE> TYPE)
(declare-const class_EncodedGlobalVariables<TYPE> TYPE)
(declare-fun directSuperclass<TYPE> (TYPE) TYPE)
(declare-fun type_of<TYPE> ($Ref) TYPE)
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
(declare-fun loc<Ref> (VCTArray<Ref> Int) $Ref)
(declare-fun alen<Int> (VCTArray<Ref>) Int)
(declare-fun first<VCTArray<Ref>> ($Ref) VCTArray<Ref>)
(declare-fun second<Int> ($Ref) Int)
(declare-const VCTNone<VCTOption<VCTArray<Ref>>> VCTOption<VCTArray<Ref>>)
(declare-fun VCTSome<VCTOption<VCTArray<Ref>>> (VCTArray<Ref>) VCTOption<VCTArray<Ref>>)
(declare-fun getVCTOption<VCTArray<Ref>> (VCTOption<VCTArray<Ref>>) VCTArray<Ref>)
(declare-fun getVCTOptionOrElse<VCTArray<Ref>> (VCTOption<VCTArray<Ref>> VCTArray<Ref>) VCTArray<Ref>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun instanceof_TYPE_TYPE ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%limited ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%stateless (TYPE TYPE) Bool)
(declare-fun new_frac ($Snap $Perm) frac)
(declare-fun new_frac%limited ($Snap $Perm) frac)
(declare-fun new_frac%stateless ($Perm) Bool)
(declare-fun getVCTOption1 ($Snap VCTOption<VCTArray<Ref>>) VCTArray<Ref>)
(declare-fun getVCTOption1%limited ($Snap VCTOption<VCTArray<Ref>>) VCTArray<Ref>)
(declare-fun getVCTOption1%stateless (VCTOption<VCTArray<Ref>>) Bool)
(declare-fun new_zfrac ($Snap $Perm) zfrac)
(declare-fun new_zfrac%limited ($Snap $Perm) zfrac)
(declare-fun new_zfrac%stateless ($Perm) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
; ////////// Uniqueness assumptions from domains
(assert (distinct class_java_DOT_lang_DOT_Object<TYPE> class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities<TYPE> class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC<TYPE> class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Client<TYPE> class_java_DOT_lang_DOT_String<TYPE> class_java_DOT_lang_DOT_Throwable<TYPE> class_java_DOT_lang_DOT_Exception<TYPE> class_java_DOT_util_DOT_Comparator<TYPE> class_EncodedGlobalVariables<TYPE>))
; ////////// Axioms
(assert (forall ((a frac) (b frac)) (!
  (= (= (frac_val<Perm> a) (frac_val<Perm> b)) (= a b))
  :pattern ((frac_val<Perm> a) (frac_val<Perm> b))
  :qid |prog.frac_eq|)))
(assert (forall ((a frac)) (!
  (and (< $Perm.No (frac_val<Perm> a)) (<= (frac_val<Perm> a) $Perm.Write))
  :pattern ((frac_val<Perm> a))
  :qid |prog.frac_bound|)))
(assert (=
  (directSuperclass<TYPE> (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Client<TYPE>  TYPE))
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
  (directSuperclass<TYPE> (as class_java_DOT_util_DOT_Comparator<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_EncodedGlobalVariables<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
(assert (forall ((a VCTArray<Ref>) (i Int)) (!
  (and
    (= (first<VCTArray<Ref>> (loc<Ref> a i)) a)
    (= (second<Int> (loc<Ref> a i)) i))
  :pattern ((loc<Ref> a i))
  :qid |prog.all_diff|)))
(assert (forall ((a VCTArray<Ref>)) (!
  (>= (alen<Int> a) 0)
  :pattern ((alen<Int> a))
  :qid |prog.len_nonneg|)))
(assert (forall ((x VCTArray<Ref>)) (!
  (not
    (=
      (as VCTNone<VCTOption<VCTArray<Ref>>>  VCTOption<VCTArray<Ref>>)
      (VCTSome<VCTOption<VCTArray<Ref>>> x)))
  :pattern ((VCTSome<VCTOption<VCTArray<Ref>>> x))
  :qid |prog.not_equal_vct|)))
(assert (forall ((x VCTArray<Ref>) (y VCTArray<Ref>)) (!
  (=
    (=
      (VCTSome<VCTOption<VCTArray<Ref>>> x)
      (VCTSome<VCTOption<VCTArray<Ref>>> y))
    (= x y))
  :pattern ((VCTSome<VCTOption<VCTArray<Ref>>> x) (VCTSome<VCTOption<VCTArray<Ref>>> y))
  :qid |prog.equal_vct|)))
(assert (forall ((x VCTArray<Ref>)) (!
  (= (getVCTOption<VCTArray<Ref>> (VCTSome<VCTOption<VCTArray<Ref>>> x)) x)
  :pattern ((getVCTOption<VCTArray<Ref>> (VCTSome<VCTOption<VCTArray<Ref>>> x)))
  :qid |prog.get_axiom_vct|)))
(assert (forall ((x VCTOption<VCTArray<Ref>>)) (!
  (= (VCTSome<VCTOption<VCTArray<Ref>>> (getVCTOption<VCTArray<Ref>> x)) x)
  :pattern ((VCTSome<VCTOption<VCTArray<Ref>>> (getVCTOption<VCTArray<Ref>> x)))
  :qid |prog.get_axiom_vct_2|)))
(assert (forall ((val VCTArray<Ref>) (default VCTArray<Ref>)) (!
  (=
    (getVCTOptionOrElse<VCTArray<Ref>> (VCTSome<VCTOption<VCTArray<Ref>>> val) default)
    val)
  :pattern ((getVCTOptionOrElse<VCTArray<Ref>> (VCTSome<VCTOption<VCTArray<Ref>>> val) default))
  :qid |prog.get_or_else_axiom_1|)))
(assert (forall ((default VCTArray<Ref>)) (!
  (=
    (getVCTOptionOrElse<VCTArray<Ref>> (as VCTNone<VCTOption<VCTArray<Ref>>>  VCTOption<VCTArray<Ref>>) default)
    default)
  :pattern ((getVCTOptionOrElse<VCTArray<Ref>> (as VCTNone<VCTOption<VCTArray<Ref>>>  VCTOption<VCTArray<Ref>>) default))
  :qid |prog.get_or_else_axiom_2|)))
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
(assert (forall ((s@$ $Snap) (x@5@00 VCTOption<VCTArray<Ref>>)) (!
  (= (getVCTOption1%limited s@$ x@5@00) (getVCTOption1 s@$ x@5@00))
  :pattern ((getVCTOption1 s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 VCTOption<VCTArray<Ref>>)) (!
  (getVCTOption1%stateless x@5@00)
  :pattern ((getVCTOption1%limited s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 VCTOption<VCTArray<Ref>>)) (!
  (implies
    (not
      (= x@5@00 (as VCTNone<VCTOption<VCTArray<Ref>>>  VCTOption<VCTArray<Ref>>)))
    (= (getVCTOption1 s@$ x@5@00) (getVCTOption<VCTArray<Ref>> x@5@00)))
  :pattern ((getVCTOption1 s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@7@00 $Perm)) (!
  (= (new_zfrac%limited s@$ x@7@00) (new_zfrac s@$ x@7@00))
  :pattern ((new_zfrac s@$ x@7@00))
  )))
(assert (forall ((s@$ $Snap) (x@7@00 $Perm)) (!
  (new_zfrac%stateless x@7@00)
  :pattern ((new_zfrac%limited s@$ x@7@00))
  )))
(assert (forall ((s@$ $Snap) (x@7@00 $Perm)) (!
  (let ((result@8@00 (new_zfrac%limited s@$ x@7@00))) (implies
    (and (<= $Perm.No x@7@00) (<= x@7@00 $Perm.Write))
    (= (zfrac_val<Perm> result@8@00) x@7@00)))
  :pattern ((new_zfrac%limited s@$ x@7@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC___contract_unsatisfiable__internal_AdderC_EncodedGlobalVariables_java_DOT_lang_DOT_String_Integer ----------
(declare-const diz@0@01 $Ref)
(declare-const globals@1@01 $Ref)
(declare-const hostS@2@01 $Ref)
(declare-const portS@3@01 Int)
(declare-const diz@4@01 $Ref)
(declare-const globals@5@01 $Ref)
(declare-const hostS@6@01 $Ref)
(declare-const portS@7@01 Int)
(push) ; 1
(declare-const $t@8@01 $Snap)
(assert (= $t@8@01 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@4@01 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@9@01 $Snap)
(assert (= $t@9@01 ($Snap.combine ($Snap.first $t@9@01) ($Snap.second $t@9@01))))
(assert (= ($Snap.first $t@9@01) $Snap.unit))
(assert (= ($Snap.second $t@9@01) $Snap.unit))
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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC___contract_unsatisfiable__internal_byeToS_EncodedGlobalVariables ----------
(declare-const diz@10@01 $Ref)
(declare-const globals@11@01 $Ref)
(declare-const diz@12@01 $Ref)
(declare-const globals@13@01 $Ref)
(push) ; 1
(declare-const $t@14@01 $Snap)
(assert (= $t@14@01 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@12@01 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state, write) && diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5)
(declare-const $t@15@01 $Snap)
(assert (= $t@15@01 ($Snap.combine ($Snap.first $t@15@01) ($Snap.second $t@15@01))))
(assert (= ($Snap.first $t@15@01) $Snap.unit))
(assert (=
  ($Snap.second $t@15@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@15@01))
    ($Snap.second ($Snap.second $t@15@01)))))
(assert (= ($Snap.second ($Snap.second $t@15@01)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@15@01))) 5))
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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_internal_resFromS_java_DOT_lang_DOT_Object_EncodedGlobalVariables ----------
(declare-const diz@16@01 $Ref)
(declare-const globals@17@01 $Ref)
(declare-const sys__result@18@01 Int)
(declare-const sys__exc@19@01 $Ref)
(declare-const diz@20@01 $Ref)
(declare-const globals@21@01 $Ref)
(declare-const sys__result@22@01 Int)
(declare-const sys__exc@23@01 $Ref)
(push) ; 1
(declare-const $t@24@01 $Snap)
(assert (= $t@24@01 ($Snap.combine ($Snap.first $t@24@01) ($Snap.second $t@24@01))))
(assert (= ($Snap.first $t@24@01) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@20@01 $Ref.null)))
(assert (=
  ($Snap.second $t@24@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@01))
    ($Snap.second ($Snap.second $t@24@01)))))
(assert (= ($Snap.second ($Snap.second $t@24@01)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 7
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@24@01))) 7))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@25@01 $Snap)
(assert (= $t@25@01 ($Snap.combine ($Snap.first $t@25@01) ($Snap.second $t@25@01))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@23@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               69
;  :binary-propagations     37
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   25
;  :datatype-splits         4
;  :decisions               8
;  :final-checks            15
;  :max-generation          1
;  :max-memory              3.53
;  :memory                  3.29
;  :mk-bool-var             118
;  :mk-clause               1
;  :num-allocs              55840
;  :num-checks              12
;  :propagations            37
;  :quant-instantiations    2
;  :rlimit-count            15260)
(push) ; 3
(assert (not (= sys__exc@23@01 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               76
;  :binary-propagations     37
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   28
;  :datatype-splits         6
;  :decisions               11
;  :final-checks            17
;  :max-generation          1
;  :max-memory              3.53
;  :memory                  3.29
;  :mk-bool-var             121
;  :mk-clause               1
;  :num-allocs              56351
;  :num-checks              13
;  :propagations            37
;  :quant-instantiations    2
;  :rlimit-count            15448)
; [then-branch: 0 | sys__exc@23@01 == Null | live]
; [else-branch: 0 | sys__exc@23@01 != Null | live]
(push) ; 3
; [then-branch: 0 | sys__exc@23@01 == Null]
(assert (= sys__exc@23@01 $Ref.null))
(assert (=
  ($Snap.first $t@25@01)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@25@01))
    ($Snap.second ($Snap.first $t@25@01)))))
(assert (= ($Snap.second ($Snap.first $t@25@01)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@25@01))) 5))
(assert (=
  ($Snap.second $t@25@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@25@01))
    ($Snap.second ($Snap.second $t@25@01)))))
(assert (= ($Snap.first ($Snap.second $t@25@01)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 1 | sys__exc@23@01 != Null | live]
; [else-branch: 1 | sys__exc@23@01 == Null | live]
(push) ; 5
; [then-branch: 1 | sys__exc@23@01 != Null]
(assert (not (= sys__exc@23@01 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 1 | sys__exc@23@01 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@23@01 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               91
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   28
;  :datatype-splits         6
;  :decisions               11
;  :final-checks            17
;  :max-generation          1
;  :max-memory              3.53
;  :memory                  3.30
;  :mk-bool-var             128
;  :mk-clause               1
;  :num-allocs              56582
;  :num-checks              14
;  :propagations            37
;  :quant-instantiations    3
;  :rlimit-count            15892)
; [then-branch: 2 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@01 != Null | dead]
; [else-branch: 2 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@01 != Null) | live]
(push) ; 5
; [else-branch: 2 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@01 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@23@01 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@25@01)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 3 | sys__exc@23@01 != Null | dead]
; [else-branch: 3 | sys__exc@23@01 == Null | live]
(push) ; 5
; [else-branch: 3 | sys__exc@23@01 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 0 | sys__exc@23@01 != Null]
(assert (not (= sys__exc@23@01 $Ref.null)))
(assert (= ($Snap.first $t@25@01) $Snap.unit))
(assert (=
  ($Snap.second $t@25@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@25@01))
    ($Snap.second ($Snap.second $t@25@01)))))
(assert (= ($Snap.first ($Snap.second $t@25@01)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 4 | sys__exc@23@01 != Null | live]
; [else-branch: 4 | sys__exc@23@01 == Null | live]
(push) ; 5
; [then-branch: 4 | sys__exc@23@01 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 4 | sys__exc@23@01 == Null]
(assert (= sys__exc@23@01 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@23@01 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               108
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   32
;  :datatype-splits         7
;  :decisions               14
;  :del-clause              7
;  :final-checks            19
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             142
;  :mk-clause               8
;  :num-allocs              57361
;  :num-checks              15
;  :propagations            39
;  :quant-instantiations    6
;  :rlimit-count            16502)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@23@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               114
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   36
;  :datatype-splits         8
;  :decisions               16
;  :del-clause              14
;  :final-checks            21
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             151
;  :mk-clause               15
;  :num-allocs              57922
;  :num-checks              16
;  :propagations            43
;  :quant-instantiations    9
;  :rlimit-count            16757)
; [then-branch: 5 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@01 != Null | live]
; [else-branch: 5 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@01 != Null) | live]
(push) ; 5
; [then-branch: 5 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@01 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@23@01 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 5 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@01), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@01 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@23@01 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@25@01)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@23@01 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               119
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   37
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              14
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             152
;  :mk-clause               15
;  :num-allocs              58457
;  :num-checks              17
;  :propagations            43
;  :quant-instantiations    9
;  :rlimit-count            16953)
(push) ; 5
(assert (not (not (= sys__exc@23@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               119
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   37
;  :datatype-splits         8
;  :decisions               17
;  :del-clause              14
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             152
;  :mk-clause               15
;  :num-allocs              58471
;  :num-checks              18
;  :propagations            43
;  :quant-instantiations    9
;  :rlimit-count            16964)
; [then-branch: 6 | sys__exc@23@01 != Null | live]
; [else-branch: 6 | sys__exc@23@01 == Null | dead]
(push) ; 5
; [then-branch: 6 | sys__exc@23@01 != Null]
(assert (not (= sys__exc@23@01 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 7 | sys__exc@23@01 != Null | live]
; [else-branch: 7 | sys__exc@23@01 == Null | live]
(push) ; 7
; [then-branch: 7 | sys__exc@23@01 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 7 | sys__exc@23@01 == Null]
(assert (= sys__exc@23@01 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@23@01 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@01) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@23@01 $Ref.null)))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; sys__exc := null
; [exec]
; diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state := 5
; [exec]
; sys__result := 0
; [exec]
; // assert
; assert (sys__exc == null ==> acc(diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state, write) && diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5) && (sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true) && (sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()))
; [eval] sys__exc == null
(push) ; 3
(assert (not false))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               121
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   38
;  :datatype-splits         8
;  :decisions               18
;  :del-clause              14
;  :final-checks            23
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             152
;  :mk-clause               15
;  :num-allocs              58915
;  :num-checks              19
;  :propagations            43
;  :quant-instantiations    9
;  :rlimit-count            17106)
; [then-branch: 8 | True | live]
; [else-branch: 8 | False | dead]
(push) ; 3
; [then-branch: 8 | True]
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
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
; [exec]
; inhale false
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- java_DOT_lang_DOT_Throwable_internal_printStackTrace_EncodedGlobalVariables ----------
(declare-const diz@26@01 $Ref)
(declare-const globals@27@01 $Ref)
(declare-const diz@28@01 $Ref)
(declare-const globals@29@01 $Ref)
(push) ; 1
(declare-const $t@30@01 $Snap)
(assert (= $t@30@01 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@28@01 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- java_DOT_lang_DOT_Exception_internal_Exception_EncodedGlobalVariables ----------
(declare-const globals@31@01 $Ref)
(declare-const sys__result@32@01 $Ref)
(declare-const globals@33@01 $Ref)
(declare-const sys__result@34@01 $Ref)
(push) ; 1
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@35@01 $Snap)
(assert (= $t@35@01 ($Snap.combine ($Snap.first $t@35@01) ($Snap.second $t@35@01))))
(assert (= ($Snap.first $t@35@01) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@34@01 $Ref.null)))
(assert (= ($Snap.second $t@35@01) $Snap.unit))
; [eval] type_of(sys__result) == class_java_DOT_lang_DOT_Exception()
; [eval] type_of(sys__result)
; [eval] class_java_DOT_lang_DOT_Exception()
(assert (=
  (type_of<TYPE> sys__result@34@01)
  (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE)))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
