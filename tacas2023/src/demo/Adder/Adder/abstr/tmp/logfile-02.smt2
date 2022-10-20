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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_AdderC_EncodedGlobalVariables_java_DOT_lang_DOT_String_Integer ----------
(declare-const globals@0@02 $Ref)
(declare-const hostS@1@02 $Ref)
(declare-const portS@2@02 Int)
(declare-const sys__result@3@02 $Ref)
(declare-const globals@4@02 $Ref)
(declare-const hostS@5@02 $Ref)
(declare-const portS@6@02 Int)
(declare-const sys__result@7@02 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@8@02 $Snap)
(assert (= $t@8@02 ($Snap.combine ($Snap.first $t@8@02) ($Snap.second $t@8@02))))
(assert (= ($Snap.first $t@8@02) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@7@02 $Ref.null)))
(assert (=
  ($Snap.second $t@8@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@8@02))
    ($Snap.second ($Snap.second $t@8@02)))))
(assert (= ($Snap.first ($Snap.second $t@8@02)) $Snap.unit))
; [eval] type_of(sys__result) == class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
; [eval] type_of(sys__result)
; [eval] class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
(assert (=
  (type_of<TYPE> sys__result@7@02)
  (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@8@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@8@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@8@02))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@8@02))) $Snap.unit))
; [eval] sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@8@02))))
  5))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_resFromS_java_DOT_lang_DOT_Object_EncodedGlobalVariables ----------
(declare-const diz@9@02 $Ref)
(declare-const globals@10@02 $Ref)
(declare-const sys__result@11@02 Int)
(declare-const sys__exc@12@02 $Ref)
(declare-const diz@13@02 $Ref)
(declare-const globals@14@02 $Ref)
(declare-const sys__result@15@02 Int)
(declare-const sys__exc@16@02 $Ref)
(push) ; 1
(declare-const $t@17@02 $Snap)
(assert (= $t@17@02 ($Snap.combine ($Snap.first $t@17@02) ($Snap.second $t@17@02))))
(assert (= ($Snap.first $t@17@02) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@13@02 $Ref.null)))
(assert (=
  ($Snap.second $t@17@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@17@02))
    ($Snap.second ($Snap.second $t@17@02)))))
(assert (= ($Snap.second ($Snap.second $t@17@02)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 7
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second $t@17@02))) 7))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@18@02 $Snap)
(assert (= $t@18@02 ($Snap.combine ($Snap.first $t@18@02) ($Snap.second $t@18@02))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@16@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               38
;  :binary-propagations     37
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   5
;  :datatype-splits         3
;  :decisions               4
;  :final-checks            5
;  :max-generation          1
;  :max-memory              3.53
;  :memory                  3.29
;  :mk-bool-var             104
;  :mk-clause               1
;  :num-allocs              51599
;  :num-checks              3
;  :propagations            37
;  :quant-instantiations    1
;  :rlimit-count            13897)
(push) ; 3
(assert (not (= sys__exc@16@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45
;  :binary-propagations     37
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   8
;  :datatype-splits         5
;  :decisions               7
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.53
;  :memory                  3.29
;  :mk-bool-var             107
;  :mk-clause               1
;  :num-allocs              52110
;  :num-checks              4
;  :propagations            37
;  :quant-instantiations    1
;  :rlimit-count            14085)
; [then-branch: 0 | sys__exc@16@02 == Null | live]
; [else-branch: 0 | sys__exc@16@02 != Null | live]
(push) ; 3
; [then-branch: 0 | sys__exc@16@02 == Null]
(assert (= sys__exc@16@02 $Ref.null))
(assert (=
  ($Snap.first $t@18@02)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@18@02))
    ($Snap.second ($Snap.first $t@18@02)))))
(assert (= ($Snap.second ($Snap.first $t@18@02)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@18@02))) 5))
(assert (=
  ($Snap.second $t@18@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@18@02))
    ($Snap.second ($Snap.second $t@18@02)))))
(assert (= ($Snap.first ($Snap.second $t@18@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 1 | sys__exc@16@02 != Null | live]
; [else-branch: 1 | sys__exc@16@02 == Null | live]
(push) ; 5
; [then-branch: 1 | sys__exc@16@02 != Null]
(assert (not (= sys__exc@16@02 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 1 | sys__exc@16@02 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@16@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@16@02 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               60
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   8
;  :datatype-splits         5
;  :decisions               7
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.53
;  :memory                  3.30
;  :mk-bool-var             114
;  :mk-clause               1
;  :num-allocs              52335
;  :num-checks              5
;  :propagations            37
;  :quant-instantiations    2
;  :rlimit-count            14529)
; [then-branch: 2 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@16@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@16@02 != Null | dead]
; [else-branch: 2 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@16@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@16@02 != Null) | live]
(push) ; 5
; [else-branch: 2 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@16@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@16@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@16@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@16@02 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@18@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 3 | sys__exc@16@02 != Null | dead]
; [else-branch: 3 | sys__exc@16@02 == Null | live]
(push) ; 5
; [else-branch: 3 | sys__exc@16@02 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 0 | sys__exc@16@02 != Null]
(assert (not (= sys__exc@16@02 $Ref.null)))
(assert (= ($Snap.first $t@18@02) $Snap.unit))
(assert (=
  ($Snap.second $t@18@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@18@02))
    ($Snap.second ($Snap.second $t@18@02)))))
(assert (= ($Snap.first ($Snap.second $t@18@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 4 | sys__exc@16@02 != Null | live]
; [else-branch: 4 | sys__exc@16@02 == Null | live]
(push) ; 5
; [then-branch: 4 | sys__exc@16@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 4 | sys__exc@16@02 == Null]
(assert (= sys__exc@16@02 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@16@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@16@02 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               77
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   12
;  :datatype-splits         6
;  :decisions               10
;  :del-clause              7
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             128
;  :mk-clause               8
;  :num-allocs              53115
;  :num-checks              6
;  :propagations            39
;  :quant-instantiations    5
;  :rlimit-count            15139)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@16@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@16@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               83
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   16
;  :datatype-splits         7
;  :decisions               12
;  :del-clause              14
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             137
;  :mk-clause               15
;  :num-allocs              53679
;  :num-checks              7
;  :propagations            43
;  :quant-instantiations    8
;  :rlimit-count            15394)
; [then-branch: 5 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@16@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@16@02 != Null | live]
; [else-branch: 5 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@16@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@16@02 != Null) | live]
(push) ; 5
; [then-branch: 5 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@16@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@16@02 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@16@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@16@02 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 5 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@16@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@16@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@16@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@16@02 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@18@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@16@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               88
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   17
;  :datatype-splits         7
;  :decisions               13
;  :del-clause              14
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             138
;  :mk-clause               15
;  :num-allocs              54214
;  :num-checks              8
;  :propagations            43
;  :quant-instantiations    8
;  :rlimit-count            15590)
(push) ; 5
(assert (not (not (= sys__exc@16@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               88
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   17
;  :datatype-splits         7
;  :decisions               13
;  :del-clause              14
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             138
;  :mk-clause               15
;  :num-allocs              54228
;  :num-checks              9
;  :propagations            43
;  :quant-instantiations    8
;  :rlimit-count            15601)
; [then-branch: 6 | sys__exc@16@02 != Null | live]
; [else-branch: 6 | sys__exc@16@02 == Null | dead]
(push) ; 5
; [then-branch: 6 | sys__exc@16@02 != Null]
(assert (not (= sys__exc@16@02 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 7 | sys__exc@16@02 != Null | live]
; [else-branch: 7 | sys__exc@16@02 == Null | live]
(push) ; 7
; [then-branch: 7 | sys__exc@16@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 7 | sys__exc@16@02 == Null]
(assert (= sys__exc@16@02 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@16@02 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@16@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@16@02 $Ref.null)))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Client_client_java_DOT_lang_DOT_Object_EncodedGlobalVariables_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC ----------
(declare-const globals@19@02 $Ref)
(declare-const a@20@02 $Ref)
(declare-const sys__exc@21@02 $Ref)
(declare-const globals@22@02 $Ref)
(declare-const a@23@02 $Ref)
(declare-const sys__exc@24@02 $Ref)
(push) ; 1
(declare-const $t@25@02 $Snap)
(assert (= $t@25@02 ($Snap.combine ($Snap.first $t@25@02) ($Snap.second $t@25@02))))
(assert (not (= a@23@02 $Ref.null)))
(assert (= ($Snap.second $t@25@02) $Snap.unit))
; [eval] a.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@25@02)) 5))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@26@02 $Snap)
(assert (= $t@26@02 ($Snap.combine ($Snap.first $t@26@02) ($Snap.second $t@26@02))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@24@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               111
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   23
;  :datatype-splits         10
;  :decisions               17
;  :del-clause              14
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             148
;  :mk-clause               15
;  :num-allocs              55390
;  :num-checks              11
;  :propagations            43
;  :quant-instantiations    9
;  :rlimit-count            16288)
(push) ; 3
(assert (not (= sys__exc@24@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               118
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   27
;  :datatype-splits         12
;  :decisions               20
;  :del-clause              14
;  :final-checks            18
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             151
;  :mk-clause               15
;  :num-allocs              55896
;  :num-checks              12
;  :propagations            43
;  :quant-instantiations    9
;  :rlimit-count            16474)
; [then-branch: 8 | sys__exc@24@02 == Null | live]
; [else-branch: 8 | sys__exc@24@02 != Null | live]
(push) ; 3
; [then-branch: 8 | sys__exc@24@02 == Null]
(assert (= sys__exc@24@02 $Ref.null))
(assert (=
  ($Snap.first $t@26@02)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@26@02))
    ($Snap.second ($Snap.first $t@26@02)))))
(assert (= ($Snap.second ($Snap.first $t@26@02)) $Snap.unit))
; [eval] a.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 6
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@26@02))) 6))
(assert (=
  ($Snap.second $t@26@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@26@02))
    ($Snap.second ($Snap.second $t@26@02)))))
(assert (= ($Snap.first ($Snap.second $t@26@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 9 | sys__exc@24@02 != Null | live]
; [else-branch: 9 | sys__exc@24@02 == Null | live]
(push) ; 5
; [then-branch: 9 | sys__exc@24@02 != Null]
(assert (not (= sys__exc@24@02 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 9 | sys__exc@24@02 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@24@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@24@02 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               133
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   27
;  :datatype-splits         12
;  :decisions               20
;  :del-clause              14
;  :final-checks            18
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             158
;  :mk-clause               15
;  :num-allocs              56094
;  :num-checks              13
;  :propagations            43
;  :quant-instantiations    10
;  :rlimit-count            16918)
; [then-branch: 10 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@24@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@24@02 != Null | dead]
; [else-branch: 10 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@24@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@24@02 != Null) | live]
(push) ; 5
; [else-branch: 10 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@24@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@24@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@24@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@24@02 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@26@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 11 | sys__exc@24@02 != Null | dead]
; [else-branch: 11 | sys__exc@24@02 == Null | live]
(push) ; 5
; [else-branch: 11 | sys__exc@24@02 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 8 | sys__exc@24@02 != Null]
(assert (not (= sys__exc@24@02 $Ref.null)))
(assert (= ($Snap.first $t@26@02) $Snap.unit))
(assert (=
  ($Snap.second $t@26@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@26@02))
    ($Snap.second ($Snap.second $t@26@02)))))
(assert (= ($Snap.first ($Snap.second $t@26@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 12 | sys__exc@24@02 != Null | live]
; [else-branch: 12 | sys__exc@24@02 == Null | live]
(push) ; 5
; [then-branch: 12 | sys__exc@24@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 12 | sys__exc@24@02 == Null]
(assert (= sys__exc@24@02 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@24@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@24@02 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               149
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   31
;  :datatype-splits         13
;  :decisions               23
;  :del-clause              21
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             172
;  :mk-clause               22
;  :num-allocs              56819
;  :num-checks              14
;  :propagations            45
;  :quant-instantiations    13
;  :rlimit-count            17525)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@24@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@24@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               154
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   35
;  :datatype-splits         14
;  :decisions               25
;  :del-clause              28
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             181
;  :mk-clause               29
;  :num-allocs              57378
;  :num-checks              15
;  :propagations            49
;  :quant-instantiations    16
;  :rlimit-count            17777)
; [then-branch: 13 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@24@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@24@02 != Null | live]
; [else-branch: 13 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@24@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@24@02 != Null) | live]
(push) ; 5
; [then-branch: 13 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@24@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@24@02 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@24@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@24@02 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 13 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@24@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@24@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@24@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@24@02 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@26@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@24@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               158
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   37
;  :datatype-splits         14
;  :decisions               26
;  :del-clause              28
;  :final-checks            23
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             182
;  :mk-clause               29
;  :num-allocs              57910
;  :num-checks              16
;  :propagations            49
;  :quant-instantiations    16
;  :rlimit-count            17970)
(push) ; 5
(assert (not (not (= sys__exc@24@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               158
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   37
;  :datatype-splits         14
;  :decisions               26
;  :del-clause              28
;  :final-checks            23
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             182
;  :mk-clause               29
;  :num-allocs              57924
;  :num-checks              17
;  :propagations            49
;  :quant-instantiations    16
;  :rlimit-count            17981)
; [then-branch: 14 | sys__exc@24@02 != Null | live]
; [else-branch: 14 | sys__exc@24@02 == Null | dead]
(push) ; 5
; [then-branch: 14 | sys__exc@24@02 != Null]
(assert (not (= sys__exc@24@02 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 15 | sys__exc@24@02 != Null | live]
; [else-branch: 15 | sys__exc@24@02 == Null | live]
(push) ; 7
; [then-branch: 15 | sys__exc@24@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 15 | sys__exc@24@02 == Null]
(assert (= sys__exc@24@02 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@24@02 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@24@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@24@02 $Ref.null)))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var temp_y_16__9: Int
(declare-const temp_y_16__9@27@02 Int)
; [exec]
; var x__6: Int
(declare-const x__6@28@02 Int)
; [exec]
; var y__7: Int
(declare-const y__7@29@02 Int)
; [exec]
; var _old_sys__exc_0__8: Ref
(declare-const _old_sys__exc_0__8@30@02 $Ref)
; [exec]
; sys__exc := null
; [exec]
; x__6 := 1
; [exec]
; y__7 := 2
; [exec]
; _old_sys__exc_0__8 := sys__exc
(declare-const sys__exc@31@02 $Ref)
(declare-const x__6@32@02 Int)
(declare-const temp_y_16__9@33@02 Int)
(declare-const y__7@34@02 Int)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@35@02 $Snap)
(assert (= $t@35@02 ($Snap.combine ($Snap.first $t@35@02) ($Snap.second $t@35@02))))
(assert (=
  ($Snap.second $t@35@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@35@02))
    ($Snap.second ($Snap.second $t@35@02)))))
(assert (= ($Snap.first ($Snap.second $t@35@02)) $Snap.unit))
; [eval] a.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@35@02)) 5))
(assert (= ($Snap.second ($Snap.second $t@35@02)) $Snap.unit))
; [eval] _old_sys__exc_0__8 == sys__exc
(assert (= $Ref.null sys__exc@31@02))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
; [eval] x__6 + y__7 < 100
; [eval] x__6 + y__7
(pop) ; 4
(push) ; 4
; [eval] !(x__6 + y__7 < 100)
; [eval] x__6 + y__7 < 100
; [eval] x__6 + y__7
(pop) ; 4
(pop) ; 3
(push) ; 3
; Loop head block: Establish invariant
; [eval] a.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
; [eval] _old_sys__exc_0__8 == sys__exc
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert (= $t@35@02 ($Snap.combine ($Snap.first $t@35@02) ($Snap.second $t@35@02))))
(assert (=
  ($Snap.second $t@35@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@35@02))
    ($Snap.second ($Snap.second $t@35@02)))))
(assert (= ($Snap.first ($Snap.second $t@35@02)) $Snap.unit))
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@35@02)) 5))
(assert (= ($Snap.second ($Snap.second $t@35@02)) $Snap.unit))
(assert (= $Ref.null sys__exc@31@02))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
; [eval] x__6 + y__7 < 100
; [eval] x__6 + y__7
(push) ; 5
(assert (not (not (< (+ x__6@32@02 y__7@34@02) 100))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               199
;  :arith-assert-upper      1
;  :arith-pivots            2
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 27
;  :datatype-occurs-check   43
;  :datatype-splits         14
;  :decisions               29
;  :del-clause              28
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.32
;  :mk-bool-var             197
;  :mk-clause               29
;  :num-allocs              59764
;  :num-checks              20
;  :propagations            49
;  :quant-instantiations    18
;  :rlimit-count            19095)
(push) ; 5
(assert (not (< (+ x__6@32@02 y__7@34@02) 100)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               202
;  :arith-assert-lower      1
;  :arith-assert-upper      1
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   45
;  :datatype-splits         14
;  :decisions               30
;  :del-clause              28
;  :final-checks            27
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.32
;  :mk-bool-var             198
;  :mk-clause               29
;  :num-allocs              60328
;  :num-checks              21
;  :propagations            49
;  :quant-instantiations    18
;  :rlimit-count            19264)
; [then-branch: 16 | x__6@32@02 + y__7@34@02 < 100 | live]
; [else-branch: 16 | !(x__6@32@02 + y__7@34@02 < 100) | live]
(push) ; 5
; [then-branch: 16 | x__6@32@02 + y__7@34@02 < 100]
(assert (< (+ x__6@32@02 y__7@34@02) 100))
; [exec]
; sys__exc := demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_addToS_java_DOT_lang_DOT_Object_EncodedGlobalVariables_Integer_Integer(a, globals, x__6, y__7)
; [eval] diz != null
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(declare-const sys__exc@36@02 $Ref)
(declare-const $t@37@02 $Snap)
(assert (= $t@37@02 ($Snap.combine ($Snap.first $t@37@02) ($Snap.second $t@37@02))))
; [eval] sys__exc == null
(push) ; 6
(assert (not (not (= sys__exc@36@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               216
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   50
;  :datatype-splits         16
;  :decisions               33
;  :del-clause              28
;  :final-checks            29
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.32
;  :mk-bool-var             203
;  :mk-clause               29
;  :num-allocs              61042
;  :num-checks              22
;  :propagations            49
;  :quant-instantiations    18
;  :rlimit-count            19612)
(push) ; 6
(assert (not (= sys__exc@36@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               224
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   55
;  :datatype-splits         18
;  :decisions               36
;  :del-clause              28
;  :final-checks            31
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.32
;  :mk-bool-var             206
;  :mk-clause               29
;  :num-allocs              61584
;  :num-checks              23
;  :propagations            49
;  :quant-instantiations    18
;  :rlimit-count            19806)
; [then-branch: 17 | sys__exc@36@02 == Null | live]
; [else-branch: 17 | sys__exc@36@02 != Null | live]
(push) ; 6
; [then-branch: 17 | sys__exc@36@02 == Null]
(assert (= sys__exc@36@02 $Ref.null))
(assert (=
  ($Snap.first $t@37@02)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@37@02))
    ($Snap.second ($Snap.first $t@37@02)))))
(assert (= ($Snap.second ($Snap.first $t@37@02)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 7
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@37@02))) 7))
(assert (=
  ($Snap.second $t@37@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@37@02))
    ($Snap.second ($Snap.second $t@37@02)))))
(assert (= ($Snap.first ($Snap.second $t@37@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
; [then-branch: 18 | sys__exc@36@02 != Null | live]
; [else-branch: 18 | sys__exc@36@02 == Null | live]
(push) ; 8
; [then-branch: 18 | sys__exc@36@02 != Null]
(assert (not (= sys__exc@36@02 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 9
(pop) ; 9
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 18 | sys__exc@36@02 == Null]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(push) ; 8
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@36@02 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               239
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   55
;  :datatype-splits         18
;  :decisions               36
;  :del-clause              28
;  :final-checks            31
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.33
;  :mk-bool-var             213
;  :mk-clause               29
;  :num-allocs              61791
;  :num-checks              24
;  :propagations            49
;  :quant-instantiations    19
;  :rlimit-count            20250)
; [then-branch: 19 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null | dead]
; [else-branch: 19 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null) | live]
(push) ; 8
; [else-branch: 19 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@36@02 $Ref.null)))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@37@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
; [then-branch: 20 | sys__exc@36@02 != Null | dead]
; [else-branch: 20 | sys__exc@36@02 == Null | live]
(push) ; 8
; [else-branch: 20 | sys__exc@36@02 == Null]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] sys__exc != null
; [then-branch: 21 | sys__exc@36@02 != Null | dead]
; [else-branch: 21 | sys__exc@36@02 == Null | live]
(push) ; 7
; [else-branch: 21 | sys__exc@36@02 == Null]
(pop) ; 7
; [eval] !(sys__exc != null)
; [eval] sys__exc != null
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= sys__exc@36@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               271
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               4
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   73
;  :datatype-splits         24
;  :decisions               43
;  :del-clause              28
;  :final-checks            37
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.34
;  :mk-bool-var             222
;  :mk-clause               30
;  :num-allocs              62925
;  :num-checks              26
;  :propagations            50
;  :quant-instantiations    19
;  :rlimit-count            20694)
; [then-branch: 22 | sys__exc@36@02 == Null | live]
; [else-branch: 22 | sys__exc@36@02 != Null | dead]
(push) ; 7
; [then-branch: 22 | sys__exc@36@02 == Null]
; [exec]
; x__6 := y__7
; [exec]
; temp_y_16__9, sys__exc := demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_resFromS_java_DOT_lang_DOT_Object_EncodedGlobalVariables(a, globals)
; [eval] diz != null
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 7
(declare-const sys__result@38@02 Int)
(declare-const sys__exc@39@02 $Ref)
(declare-const $t@40@02 $Snap)
(assert (= $t@40@02 ($Snap.combine ($Snap.first $t@40@02) ($Snap.second $t@40@02))))
; [eval] sys__exc == null
(push) ; 8
(assert (not (not (= sys__exc@39@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               295
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               4
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   83
;  :datatype-splits         29
;  :decisions               48
;  :del-clause              28
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.34
;  :mk-bool-var             229
;  :mk-clause               30
;  :num-allocs              63643
;  :num-checks              27
;  :propagations            51
;  :quant-instantiations    19
;  :rlimit-count            21027)
(push) ; 8
(assert (not (= sys__exc@39@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               313
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               4
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 55
;  :datatype-occurs-check   93
;  :datatype-splits         34
;  :decisions               53
;  :del-clause              28
;  :final-checks            43
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.34
;  :mk-bool-var             235
;  :mk-clause               30
;  :num-allocs              64224
;  :num-checks              28
;  :propagations            52
;  :quant-instantiations    19
;  :rlimit-count            21274)
; [then-branch: 23 | sys__exc@39@02 == Null | live]
; [else-branch: 23 | sys__exc@39@02 != Null | live]
(push) ; 8
; [then-branch: 23 | sys__exc@39@02 == Null]
(assert (= sys__exc@39@02 $Ref.null))
(assert (=
  ($Snap.first $t@40@02)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@40@02))
    ($Snap.second ($Snap.first $t@40@02)))))
(assert (= ($Snap.second ($Snap.first $t@40@02)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@40@02))) 5))
(assert (=
  ($Snap.second $t@40@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@40@02))
    ($Snap.second ($Snap.second $t@40@02)))))
(assert (= ($Snap.first ($Snap.second $t@40@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 24 | sys__exc@39@02 != Null | live]
; [else-branch: 24 | sys__exc@39@02 == Null | live]
(push) ; 10
; [then-branch: 24 | sys__exc@39@02 != Null]
(assert (not (= sys__exc@39@02 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 11
(pop) ; 11
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 24 | sys__exc@39@02 == Null]
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
(push) ; 10
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@39@02 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               330
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 55
;  :datatype-occurs-check   93
;  :datatype-splits         34
;  :decisions               53
;  :del-clause              28
;  :final-checks            43
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.35
;  :mk-bool-var             242
;  :mk-clause               30
;  :num-allocs              64423
;  :num-checks              29
;  :propagations            52
;  :quant-instantiations    20
;  :rlimit-count            21718)
; [then-branch: 25 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null | dead]
; [else-branch: 25 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null) | live]
(push) ; 10
; [else-branch: 25 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@39@02 $Ref.null)))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@40@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 26 | sys__exc@39@02 != Null | dead]
; [else-branch: 26 | sys__exc@39@02 == Null | live]
(push) ; 10
; [else-branch: 26 | sys__exc@39@02 == Null]
(pop) ; 10
(pop) ; 9
; Joined path conditions
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] sys__exc != null
; [then-branch: 27 | sys__exc@39@02 != Null | dead]
; [else-branch: 27 | sys__exc@39@02 == Null | live]
(push) ; 9
; [else-branch: 27 | sys__exc@39@02 == Null]
(pop) ; 9
; [eval] !(sys__exc != null)
; [eval] sys__exc != null
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= sys__exc@39@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               358
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 63
;  :datatype-occurs-check   117
;  :datatype-splits         40
;  :decisions               59
;  :del-clause              28
;  :final-checks            49
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.35
;  :mk-bool-var             249
;  :mk-clause               30
;  :num-allocs              65558
;  :num-checks              31
;  :propagations            54
;  :quant-instantiations    20
;  :rlimit-count            22157)
; [then-branch: 28 | sys__exc@39@02 == Null | live]
; [else-branch: 28 | sys__exc@39@02 != Null | dead]
(push) ; 9
; [then-branch: 28 | sys__exc@39@02 == Null]
; [exec]
; y__7 := temp_y_16__9
; Loop head block: Re-establish invariant
; [eval] a.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
; [eval] _old_sys__exc_0__8 == sys__exc
(set-option :timeout 0)
(push) ; 10
(assert (not (= $Ref.null sys__exc@39@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               358
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 63
;  :datatype-occurs-check   117
;  :datatype-splits         40
;  :decisions               59
;  :del-clause              28
;  :final-checks            49
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.35
;  :mk-bool-var             249
;  :mk-clause               30
;  :num-allocs              65579
;  :num-checks              32
;  :propagations            54
;  :quant-instantiations    20
;  :rlimit-count            22173)
(assert (= $Ref.null sys__exc@39@02))
(pop) ; 9
(pop) ; 8
(push) ; 8
; [else-branch: 23 | sys__exc@39@02 != Null]
(assert (not (= sys__exc@39@02 $Ref.null)))
(assert (= ($Snap.first $t@40@02) $Snap.unit))
(assert (=
  ($Snap.second $t@40@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@40@02))
    ($Snap.second ($Snap.second $t@40@02)))))
(assert (= ($Snap.first ($Snap.second $t@40@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 29 | sys__exc@39@02 != Null | live]
; [else-branch: 29 | sys__exc@39@02 == Null | live]
(push) ; 10
; [then-branch: 29 | sys__exc@39@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 11
(pop) ; 11
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 29 | sys__exc@39@02 == Null]
(assert (= sys__exc@39@02 $Ref.null))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
(set-option :timeout 10)
(push) ; 10
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@39@02 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               385
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   127
;  :datatype-splits         44
;  :decisions               64
;  :del-clause              35
;  :final-checks            52
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             265
;  :mk-clause               37
;  :num-allocs              66319
;  :num-checks              33
;  :propagations            57
;  :quant-instantiations    23
;  :rlimit-count            22760)
(push) ; 10
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@39@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   137
;  :datatype-splits         48
;  :decisions               68
;  :del-clause              42
;  :final-checks            55
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             277
;  :mk-clause               44
;  :num-allocs              66951
;  :num-checks              34
;  :propagations            62
;  :quant-instantiations    26
;  :rlimit-count            23074)
; [then-branch: 30 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null | live]
; [else-branch: 30 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null) | live]
(push) ; 10
; [then-branch: 30 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@39@02 $Ref.null))))
(pop) ; 10
(push) ; 10
; [else-branch: 30 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@39@02 $Ref.null)))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@40@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
(push) ; 10
(assert (not (= sys__exc@39@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               418
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   146
;  :datatype-splits         51
;  :decisions               71
;  :del-clause              42
;  :final-checks            58
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             281
;  :mk-clause               44
;  :num-allocs              67558
;  :num-checks              35
;  :propagations            63
;  :quant-instantiations    26
;  :rlimit-count            23342)
(push) ; 10
(assert (not (not (= sys__exc@39@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               418
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   146
;  :datatype-splits         51
;  :decisions               71
;  :del-clause              42
;  :final-checks            58
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             281
;  :mk-clause               44
;  :num-allocs              67573
;  :num-checks              36
;  :propagations            63
;  :quant-instantiations    26
;  :rlimit-count            23353)
; [then-branch: 31 | sys__exc@39@02 != Null | live]
; [else-branch: 31 | sys__exc@39@02 == Null | dead]
(push) ; 10
; [then-branch: 31 | sys__exc@39@02 != Null]
(assert (not (= sys__exc@39@02 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 11
; [then-branch: 32 | sys__exc@39@02 != Null | live]
; [else-branch: 32 | sys__exc@39@02 == Null | live]
(push) ; 12
; [then-branch: 32 | sys__exc@39@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 13
(pop) ; 13
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 32 | sys__exc@39@02 == Null]
(assert (= sys__exc@39@02 $Ref.null))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (not (= sys__exc@39@02 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@39@02 $Ref.null)))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] sys__exc != null
(set-option :timeout 10)
(push) ; 9
(assert (not (= sys__exc@39@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               452
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 85
;  :datatype-occurs-check   164
;  :datatype-splits         57
;  :decisions               79
;  :del-clause              48
;  :final-checks            64
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             295
;  :mk-clause               51
;  :num-allocs              68754
;  :num-checks              38
;  :propagations            67
;  :quant-instantiations    29
;  :rlimit-count            23874)
(push) ; 9
(assert (not (not (= sys__exc@39@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               452
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 85
;  :datatype-occurs-check   164
;  :datatype-splits         57
;  :decisions               79
;  :del-clause              48
;  :final-checks            64
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             295
;  :mk-clause               51
;  :num-allocs              68769
;  :num-checks              39
;  :propagations            67
;  :quant-instantiations    29
;  :rlimit-count            23885)
; [then-branch: 33 | sys__exc@39@02 != Null | live]
; [else-branch: 33 | sys__exc@39@02 == Null | dead]
(push) ; 9
; [then-branch: 33 | sys__exc@39@02 != Null]
(assert (not (= sys__exc@39@02 $Ref.null)))
; [exec]
; label method_end_client_15
; [eval] sys__exc == null
; [then-branch: 34 | sys__exc@39@02 == Null | dead]
; [else-branch: 34 | sys__exc@39@02 != Null | live]
(push) ; 10
; [else-branch: 34 | sys__exc@39@02 != Null]
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 11
; [then-branch: 35 | sys__exc@39@02 != Null | live]
; [else-branch: 35 | sys__exc@39@02 == Null | live]
(push) ; 12
; [then-branch: 35 | sys__exc@39@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 13
(pop) ; 13
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 35 | sys__exc@39@02 == Null]
(assert (= sys__exc@39@02 $Ref.null))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
(push) ; 12
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@39@02 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               469
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 89
;  :datatype-occurs-check   173
;  :datatype-splits         60
;  :decisions               83
;  :del-clause              48
;  :final-checks            67
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             298
;  :mk-clause               51
;  :num-allocs              69327
;  :num-checks              40
;  :propagations            68
;  :quant-instantiations    29
;  :rlimit-count            24126)
(push) ; 12
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@39@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               469
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 89
;  :datatype-occurs-check   173
;  :datatype-splits         60
;  :decisions               83
;  :del-clause              48
;  :final-checks            67
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             298
;  :mk-clause               51
;  :num-allocs              69342
;  :num-checks              41
;  :propagations            68
;  :quant-instantiations    29
;  :rlimit-count            24139)
; [then-branch: 36 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null | live]
; [else-branch: 36 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null) | dead]
(push) ; 12
; [then-branch: 36 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@39@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@39@02 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@39@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@39@02 $Ref.null))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 11
(push) ; 12
(assert (not (= sys__exc@39@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               486
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 93
;  :datatype-occurs-check   182
;  :datatype-splits         63
;  :decisions               87
;  :del-clause              48
;  :final-checks            70
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             301
;  :mk-clause               51
;  :num-allocs              69900
;  :num-checks              42
;  :propagations            69
;  :quant-instantiations    29
;  :rlimit-count            24349)
(push) ; 12
(assert (not (not (= sys__exc@39@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               486
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 93
;  :datatype-occurs-check   182
;  :datatype-splits         63
;  :decisions               87
;  :del-clause              48
;  :final-checks            70
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             301
;  :mk-clause               51
;  :num-allocs              69915
;  :num-checks              43
;  :propagations            69
;  :quant-instantiations    29
;  :rlimit-count            24360)
; [then-branch: 37 | sys__exc@39@02 != Null | live]
; [else-branch: 37 | sys__exc@39@02 == Null | dead]
(push) ; 12
; [then-branch: 37 | sys__exc@39@02 != Null]
(assert (not (= sys__exc@39@02 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 13
; [then-branch: 38 | sys__exc@39@02 != Null | live]
; [else-branch: 38 | sys__exc@39@02 == Null | live]
(push) ; 14
; [then-branch: 38 | sys__exc@39@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 15
(pop) ; 15
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 38 | sys__exc@39@02 == Null]
(assert (= sys__exc@39@02 $Ref.null))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
(pop) ; 10
(pop) ; 9
; [eval] !(sys__exc != null)
; [eval] sys__exc != null
(push) ; 9
(assert (not (not (= sys__exc@39@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               486
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 93
;  :datatype-occurs-check   182
;  :datatype-splits         63
;  :decisions               87
;  :del-clause              48
;  :final-checks            70
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             301
;  :mk-clause               51
;  :num-allocs              69930
;  :num-checks              44
;  :propagations            69
;  :quant-instantiations    29
;  :rlimit-count            24401)
; [then-branch: 39 | sys__exc@39@02 == Null | dead]
; [else-branch: 39 | sys__exc@39@02 != Null | live]
(push) ; 9
; [else-branch: 39 | sys__exc@39@02 != Null]
(assert (not (= sys__exc@39@02 $Ref.null)))
(pop) ; 9
(pop) ; 8
(pop) ; 7
(pop) ; 6
(push) ; 6
; [else-branch: 17 | sys__exc@36@02 != Null]
(assert (not (= sys__exc@36@02 $Ref.null)))
(assert (= ($Snap.first $t@37@02) $Snap.unit))
(assert (=
  ($Snap.second $t@37@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@37@02))
    ($Snap.second ($Snap.second $t@37@02)))))
(assert (= ($Snap.first ($Snap.second $t@37@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
; [then-branch: 40 | sys__exc@36@02 != Null | live]
; [else-branch: 40 | sys__exc@36@02 == Null | live]
(push) ; 8
; [then-branch: 40 | sys__exc@36@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 9
(pop) ; 9
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 40 | sys__exc@36@02 == Null]
(assert (= sys__exc@36@02 $Ref.null))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(push) ; 8
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@36@02 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               503
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   188
;  :datatype-splits         64
;  :decisions               90
;  :del-clause              57
;  :final-checks            72
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             314
;  :mk-clause               58
;  :num-allocs              70617
;  :num-checks              45
;  :propagations            71
;  :quant-instantiations    32
;  :rlimit-count            24940)
(push) ; 8
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@36@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               510
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 97
;  :datatype-occurs-check   194
;  :datatype-splits         65
;  :decisions               92
;  :del-clause              64
;  :final-checks            74
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             323
;  :mk-clause               65
;  :num-allocs              71205
;  :num-checks              46
;  :propagations            75
;  :quant-instantiations    35
;  :rlimit-count            25201)
; [then-branch: 41 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null | live]
; [else-branch: 41 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null) | live]
(push) ; 8
; [then-branch: 41 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@36@02 $Ref.null))))
(pop) ; 8
(push) ; 8
; [else-branch: 41 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@36@02 $Ref.null)))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@37@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
(push) ; 8
(assert (not (= sys__exc@36@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               516
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   196
;  :datatype-splits         65
;  :decisions               93
;  :del-clause              64
;  :final-checks            75
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             324
;  :mk-clause               65
;  :num-allocs              71770
;  :num-checks              47
;  :propagations            75
;  :quant-instantiations    35
;  :rlimit-count            25403)
(push) ; 8
(assert (not (not (= sys__exc@36@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               516
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   196
;  :datatype-splits         65
;  :decisions               93
;  :del-clause              64
;  :final-checks            75
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             324
;  :mk-clause               65
;  :num-allocs              71785
;  :num-checks              48
;  :propagations            75
;  :quant-instantiations    35
;  :rlimit-count            25414)
; [then-branch: 42 | sys__exc@36@02 != Null | live]
; [else-branch: 42 | sys__exc@36@02 == Null | dead]
(push) ; 8
; [then-branch: 42 | sys__exc@36@02 != Null]
(assert (not (= sys__exc@36@02 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 43 | sys__exc@36@02 != Null | live]
; [else-branch: 43 | sys__exc@36@02 == Null | live]
(push) ; 10
; [then-branch: 43 | sys__exc@36@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 11
(pop) ; 11
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 43 | sys__exc@36@02 == Null]
(assert (= sys__exc@36@02 $Ref.null))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (not (= sys__exc@36@02 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@36@02 $Ref.null)))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] sys__exc != null
(set-option :timeout 10)
(push) ; 7
(assert (not (= sys__exc@36@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               530
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   200
;  :datatype-splits         65
;  :decisions               97
;  :del-clause              70
;  :final-checks            77
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             332
;  :mk-clause               72
;  :num-allocs              72871
;  :num-checks              50
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            25803)
(push) ; 7
(assert (not (not (= sys__exc@36@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               530
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   200
;  :datatype-splits         65
;  :decisions               97
;  :del-clause              70
;  :final-checks            77
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             332
;  :mk-clause               72
;  :num-allocs              72886
;  :num-checks              51
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            25814)
; [then-branch: 44 | sys__exc@36@02 != Null | live]
; [else-branch: 44 | sys__exc@36@02 == Null | dead]
(push) ; 7
; [then-branch: 44 | sys__exc@36@02 != Null]
(assert (not (= sys__exc@36@02 $Ref.null)))
; [exec]
; label method_end_client_15
; [eval] sys__exc == null
; [then-branch: 45 | sys__exc@36@02 == Null | dead]
; [else-branch: 45 | sys__exc@36@02 != Null | live]
(push) ; 8
; [else-branch: 45 | sys__exc@36@02 != Null]
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 46 | sys__exc@36@02 != Null | live]
; [else-branch: 46 | sys__exc@36@02 == Null | live]
(push) ; 10
; [then-branch: 46 | sys__exc@36@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 11
(pop) ; 11
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 46 | sys__exc@36@02 == Null]
(assert (= sys__exc@36@02 $Ref.null))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
(push) ; 10
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@36@02 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               537
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 101
;  :datatype-occurs-check   202
;  :datatype-splits         65
;  :decisions               99
;  :del-clause              70
;  :final-checks            78
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             332
;  :mk-clause               72
;  :num-allocs              73400
;  :num-checks              52
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            25989)
(push) ; 10
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@36@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               537
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 101
;  :datatype-occurs-check   202
;  :datatype-splits         65
;  :decisions               99
;  :del-clause              70
;  :final-checks            78
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             332
;  :mk-clause               72
;  :num-allocs              73415
;  :num-checks              53
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            26002)
; [then-branch: 47 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null | live]
; [else-branch: 47 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null) | dead]
(push) ; 10
; [then-branch: 47 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@36@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@36@02 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@36@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@36@02 $Ref.null))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
(push) ; 10
(assert (not (= sys__exc@36@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               544
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 102
;  :datatype-occurs-check   204
;  :datatype-splits         65
;  :decisions               101
;  :del-clause              70
;  :final-checks            79
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             332
;  :mk-clause               72
;  :num-allocs              73929
;  :num-checks              54
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            26146)
(push) ; 10
(assert (not (not (= sys__exc@36@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               544
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 102
;  :datatype-occurs-check   204
;  :datatype-splits         65
;  :decisions               101
;  :del-clause              70
;  :final-checks            79
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             332
;  :mk-clause               72
;  :num-allocs              73944
;  :num-checks              55
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            26157)
; [then-branch: 48 | sys__exc@36@02 != Null | live]
; [else-branch: 48 | sys__exc@36@02 == Null | dead]
(push) ; 10
; [then-branch: 48 | sys__exc@36@02 != Null]
(assert (not (= sys__exc@36@02 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 11
; [then-branch: 49 | sys__exc@36@02 != Null | live]
; [else-branch: 49 | sys__exc@36@02 == Null | live]
(push) ; 12
; [then-branch: 49 | sys__exc@36@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 13
(pop) ; 13
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 49 | sys__exc@36@02 == Null]
(assert (= sys__exc@36@02 $Ref.null))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
(pop) ; 8
(pop) ; 7
; [eval] !(sys__exc != null)
; [eval] sys__exc != null
(push) ; 7
(assert (not (not (= sys__exc@36@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               544
;  :arith-assert-lower      1
;  :arith-assert-upper      2
;  :arith-pivots            4
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 102
;  :datatype-occurs-check   204
;  :datatype-splits         65
;  :decisions               101
;  :del-clause              70
;  :final-checks            79
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             332
;  :mk-clause               72
;  :num-allocs              73959
;  :num-checks              56
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            26198)
; [then-branch: 50 | sys__exc@36@02 == Null | dead]
; [else-branch: 50 | sys__exc@36@02 != Null | live]
(push) ; 7
; [else-branch: 50 | sys__exc@36@02 != Null]
(assert (not (= sys__exc@36@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
(pop) ; 5
(push) ; 5
; [else-branch: 16 | !(x__6@32@02 + y__7@34@02 < 100)]
(assert (not (< (+ x__6@32@02 y__7@34@02) 100)))
(pop) ; 5
; [eval] !(x__6 + y__7 < 100)
; [eval] x__6 + y__7 < 100
; [eval] x__6 + y__7
(push) ; 5
(assert (not (< (+ x__6@32@02 y__7@34@02) 100)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               547
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-pivots            6
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 103
;  :datatype-occurs-check   206
;  :datatype-splits         65
;  :decisions               102
;  :del-clause              71
;  :final-checks            80
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             333
;  :mk-clause               72
;  :num-allocs              74546
;  :num-checks              57
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            26387)
(push) ; 5
(assert (not (not (< (+ x__6@32@02 y__7@34@02) 100))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               550
;  :arith-assert-lower      2
;  :arith-assert-upper      3
;  :arith-pivots            8
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 104
;  :datatype-occurs-check   208
;  :datatype-splits         65
;  :decisions               103
;  :del-clause              71
;  :final-checks            81
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             334
;  :mk-clause               72
;  :num-allocs              75114
;  :num-checks              58
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            26566)
; [then-branch: 51 | !(x__6@32@02 + y__7@34@02 < 100) | live]
; [else-branch: 51 | x__6@32@02 + y__7@34@02 < 100 | live]
(push) ; 5
; [then-branch: 51 | !(x__6@32@02 + y__7@34@02 < 100)]
(assert (not (< (+ x__6@32@02 y__7@34@02) 100)))
; [exec]
; sys__exc := demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_byeToS_java_DOT_lang_DOT_Object_EncodedGlobalVariables(a, globals)
; [eval] diz != null
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(declare-const sys__exc@41@02 $Ref)
(declare-const $t@42@02 $Snap)
(assert (= $t@42@02 ($Snap.combine ($Snap.first $t@42@02) ($Snap.second $t@42@02))))
; [eval] sys__exc == null
(push) ; 6
(assert (not (not (= sys__exc@41@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               564
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 107
;  :datatype-occurs-check   213
;  :datatype-splits         67
;  :decisions               106
;  :del-clause              71
;  :final-checks            83
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             339
;  :mk-clause               72
;  :num-allocs              75783
;  :num-checks              59
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            26898)
(push) ; 6
(assert (not (= sys__exc@41@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               572
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               5
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   218
;  :datatype-splits         69
;  :decisions               109
;  :del-clause              71
;  :final-checks            85
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             342
;  :mk-clause               72
;  :num-allocs              76322
;  :num-checks              60
;  :propagations            77
;  :quant-instantiations    38
;  :rlimit-count            27092)
; [then-branch: 52 | sys__exc@41@02 == Null | live]
; [else-branch: 52 | sys__exc@41@02 != Null | live]
(push) ; 6
; [then-branch: 52 | sys__exc@41@02 == Null]
(assert (= sys__exc@41@02 $Ref.null))
(assert (=
  ($Snap.first $t@42@02)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@42@02))
    ($Snap.second ($Snap.first $t@42@02)))))
(assert (= ($Snap.second ($Snap.first $t@42@02)) $Snap.unit))
; [eval] diz.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 6
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@42@02))) 6))
(assert (=
  ($Snap.second $t@42@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@42@02))
    ($Snap.second ($Snap.second $t@42@02)))))
(assert (= ($Snap.first ($Snap.second $t@42@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
; [then-branch: 53 | sys__exc@41@02 != Null | live]
; [else-branch: 53 | sys__exc@41@02 == Null | live]
(push) ; 8
; [then-branch: 53 | sys__exc@41@02 != Null]
(assert (not (= sys__exc@41@02 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 9
(pop) ; 9
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 53 | sys__exc@41@02 == Null]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(push) ; 8
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@41@02 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               587
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               6
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   218
;  :datatype-splits         69
;  :decisions               109
;  :del-clause              71
;  :final-checks            85
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             349
;  :mk-clause               72
;  :num-allocs              76513
;  :num-checks              61
;  :propagations            77
;  :quant-instantiations    39
;  :rlimit-count            27536)
; [then-branch: 54 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null | dead]
; [else-branch: 54 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null) | live]
(push) ; 8
; [else-branch: 54 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@41@02 $Ref.null)))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@42@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
; [then-branch: 55 | sys__exc@41@02 != Null | dead]
; [else-branch: 55 | sys__exc@41@02 == Null | live]
(push) ; 8
; [else-branch: 55 | sys__exc@41@02 == Null]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] sys__exc != null
; [then-branch: 56 | sys__exc@41@02 != Null | dead]
; [else-branch: 56 | sys__exc@41@02 == Null | live]
(push) ; 7
; [else-branch: 56 | sys__exc@41@02 == Null]
(pop) ; 7
; [eval] !(sys__exc != null)
; [eval] sys__exc != null
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= sys__exc@41@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               619
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               7
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 119
;  :datatype-occurs-check   236
;  :datatype-splits         75
;  :decisions               116
;  :del-clause              71
;  :final-checks            91
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             358
;  :mk-clause               73
;  :num-allocs              77603
;  :num-checks              63
;  :propagations            78
;  :quant-instantiations    39
;  :rlimit-count            27980)
; [then-branch: 57 | sys__exc@41@02 == Null | live]
; [else-branch: 57 | sys__exc@41@02 != Null | dead]
(push) ; 7
; [then-branch: 57 | sys__exc@41@02 == Null]
; [exec]
; label method_end_client_15
; [eval] sys__exc == null
(push) ; 8
(assert (not (not (= sys__exc@41@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               632
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               7
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 123
;  :datatype-occurs-check   245
;  :datatype-splits         78
;  :decisions               119
;  :del-clause              71
;  :final-checks            94
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             361
;  :mk-clause               73
;  :num-allocs              78116
;  :num-checks              64
;  :propagations            79
;  :quant-instantiations    39
;  :rlimit-count            28157)
; [then-branch: 58 | sys__exc@41@02 == Null | live]
; [else-branch: 58 | sys__exc@41@02 != Null | dead]
(push) ; 8
; [then-branch: 58 | sys__exc@41@02 == Null]
; [eval] a.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 6
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 59 | sys__exc@41@02 != Null | live]
; [else-branch: 59 | sys__exc@41@02 == Null | live]
(push) ; 10
; [then-branch: 59 | sys__exc@41@02 != Null]
(assert (not (= sys__exc@41@02 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 11
(pop) ; 11
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 59 | sys__exc@41@02 == Null]
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
(push) ; 10
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@41@02 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               632
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 123
;  :datatype-occurs-check   245
;  :datatype-splits         78
;  :decisions               119
;  :del-clause              71
;  :final-checks            94
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             361
;  :mk-clause               73
;  :num-allocs              78133
;  :num-checks              65
;  :propagations            79
;  :quant-instantiations    39
;  :rlimit-count            28209)
; [then-branch: 60 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null | dead]
; [else-branch: 60 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null) | live]
(push) ; 10
; [else-branch: 60 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@41@02 $Ref.null)))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 61 | sys__exc@41@02 != Null | dead]
; [else-branch: 61 | sys__exc@41@02 == Null | live]
(push) ; 10
; [else-branch: 61 | sys__exc@41@02 == Null]
(pop) ; 10
(pop) ; 9
; Joined path conditions
(pop) ; 8
(pop) ; 7
(pop) ; 6
(push) ; 6
; [else-branch: 52 | sys__exc@41@02 != Null]
(assert (not (= sys__exc@41@02 $Ref.null)))
(assert (= ($Snap.first $t@42@02) $Snap.unit))
(assert (=
  ($Snap.second $t@42@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@42@02))
    ($Snap.second ($Snap.second $t@42@02)))))
(assert (= ($Snap.first ($Snap.second $t@42@02)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
; [then-branch: 62 | sys__exc@41@02 != Null | live]
; [else-branch: 62 | sys__exc@41@02 == Null | live]
(push) ; 8
; [then-branch: 62 | sys__exc@41@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 9
(pop) ; 9
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 62 | sys__exc@41@02 == Null]
(assert (= sys__exc@41@02 $Ref.null))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(push) ; 8
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@41@02 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               649
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 125
;  :datatype-occurs-check   251
;  :datatype-splits         79
;  :decisions               122
;  :del-clause              79
;  :final-checks            96
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             374
;  :mk-clause               80
;  :num-allocs              78809
;  :num-checks              66
;  :propagations            81
;  :quant-instantiations    42
;  :rlimit-count            28768)
(push) ; 8
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@41@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               656
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 127
;  :datatype-occurs-check   257
;  :datatype-splits         80
;  :decisions               124
;  :del-clause              86
;  :final-checks            98
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             383
;  :mk-clause               87
;  :num-allocs              79394
;  :num-checks              67
;  :propagations            85
;  :quant-instantiations    45
;  :rlimit-count            29029)
; [then-branch: 63 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null | live]
; [else-branch: 63 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null) | live]
(push) ; 8
; [then-branch: 63 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@41@02 $Ref.null))))
(pop) ; 8
(push) ; 8
; [else-branch: 63 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@41@02 $Ref.null)))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@42@02)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
(push) ; 8
(assert (not (= sys__exc@41@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               662
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 128
;  :datatype-occurs-check   259
;  :datatype-splits         80
;  :decisions               125
;  :del-clause              86
;  :final-checks            99
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             384
;  :mk-clause               87
;  :num-allocs              79956
;  :num-checks              68
;  :propagations            85
;  :quant-instantiations    45
;  :rlimit-count            29231)
(push) ; 8
(assert (not (not (= sys__exc@41@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               662
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 128
;  :datatype-occurs-check   259
;  :datatype-splits         80
;  :decisions               125
;  :del-clause              86
;  :final-checks            99
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             384
;  :mk-clause               87
;  :num-allocs              79971
;  :num-checks              69
;  :propagations            85
;  :quant-instantiations    45
;  :rlimit-count            29242)
; [then-branch: 64 | sys__exc@41@02 != Null | live]
; [else-branch: 64 | sys__exc@41@02 == Null | dead]
(push) ; 8
; [then-branch: 64 | sys__exc@41@02 != Null]
(assert (not (= sys__exc@41@02 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 65 | sys__exc@41@02 != Null | live]
; [else-branch: 65 | sys__exc@41@02 == Null | live]
(push) ; 10
; [then-branch: 65 | sys__exc@41@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 11
(pop) ; 11
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 65 | sys__exc@41@02 == Null]
(assert (= sys__exc@41@02 $Ref.null))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (not (= sys__exc@41@02 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@41@02 $Ref.null)))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] sys__exc != null
(set-option :timeout 10)
(push) ; 7
(assert (not (= sys__exc@41@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               676
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 130
;  :datatype-occurs-check   263
;  :datatype-splits         80
;  :decisions               129
;  :del-clause              92
;  :final-checks            101
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             392
;  :mk-clause               94
;  :num-allocs              81047
;  :num-checks              71
;  :propagations            87
;  :quant-instantiations    48
;  :rlimit-count            29631)
(push) ; 7
(assert (not (not (= sys__exc@41@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               676
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 130
;  :datatype-occurs-check   263
;  :datatype-splits         80
;  :decisions               129
;  :del-clause              92
;  :final-checks            101
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             392
;  :mk-clause               94
;  :num-allocs              81062
;  :num-checks              72
;  :propagations            87
;  :quant-instantiations    48
;  :rlimit-count            29642)
; [then-branch: 66 | sys__exc@41@02 != Null | live]
; [else-branch: 66 | sys__exc@41@02 == Null | dead]
(push) ; 7
; [then-branch: 66 | sys__exc@41@02 != Null]
(assert (not (= sys__exc@41@02 $Ref.null)))
; [exec]
; label method_end_client_15
; [eval] sys__exc == null
; [then-branch: 67 | sys__exc@41@02 == Null | dead]
; [else-branch: 67 | sys__exc@41@02 != Null | live]
(push) ; 8
; [else-branch: 67 | sys__exc@41@02 != Null]
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
; [then-branch: 68 | sys__exc@41@02 != Null | live]
; [else-branch: 68 | sys__exc@41@02 == Null | live]
(push) ; 10
; [then-branch: 68 | sys__exc@41@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 11
(pop) ; 11
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 68 | sys__exc@41@02 == Null]
(assert (= sys__exc@41@02 $Ref.null))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
(push) ; 10
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@41@02 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               683
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 131
;  :datatype-occurs-check   265
;  :datatype-splits         80
;  :decisions               131
;  :del-clause              92
;  :final-checks            102
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             392
;  :mk-clause               94
;  :num-allocs              81573
;  :num-checks              73
;  :propagations            87
;  :quant-instantiations    48
;  :rlimit-count            29817)
(push) ; 10
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@41@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               683
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 131
;  :datatype-occurs-check   265
;  :datatype-splits         80
;  :decisions               131
;  :del-clause              92
;  :final-checks            102
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             392
;  :mk-clause               94
;  :num-allocs              81588
;  :num-checks              74
;  :propagations            87
;  :quant-instantiations    48
;  :rlimit-count            29830)
; [then-branch: 69 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null | live]
; [else-branch: 69 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null) | dead]
(push) ; 10
; [then-branch: 69 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@41@02), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@41@02 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@41@02) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@41@02 $Ref.null))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 9
(push) ; 10
(assert (not (= sys__exc@41@02 $Ref.null)))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               690
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   267
;  :datatype-splits         80
;  :decisions               133
;  :del-clause              92
;  :final-checks            103
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             392
;  :mk-clause               94
;  :num-allocs              82099
;  :num-checks              75
;  :propagations            87
;  :quant-instantiations    48
;  :rlimit-count            29974)
(push) ; 10
(assert (not (not (= sys__exc@41@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               690
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   267
;  :datatype-splits         80
;  :decisions               133
;  :del-clause              92
;  :final-checks            103
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             392
;  :mk-clause               94
;  :num-allocs              82114
;  :num-checks              76
;  :propagations            87
;  :quant-instantiations    48
;  :rlimit-count            29985)
; [then-branch: 70 | sys__exc@41@02 != Null | live]
; [else-branch: 70 | sys__exc@41@02 == Null | dead]
(push) ; 10
; [then-branch: 70 | sys__exc@41@02 != Null]
(assert (not (= sys__exc@41@02 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 11
; [then-branch: 71 | sys__exc@41@02 != Null | live]
; [else-branch: 71 | sys__exc@41@02 == Null | live]
(push) ; 12
; [then-branch: 71 | sys__exc@41@02 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 13
(pop) ; 13
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 71 | sys__exc@41@02 == Null]
(assert (= sys__exc@41@02 $Ref.null))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
(pop) ; 8
(pop) ; 7
; [eval] !(sys__exc != null)
; [eval] sys__exc != null
(push) ; 7
(assert (not (not (= sys__exc@41@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               690
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-pivots            9
;  :binary-propagations     37
;  :conflicts               8
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   267
;  :datatype-splits         80
;  :decisions               133
;  :del-clause              92
;  :final-checks            103
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             392
;  :mk-clause               94
;  :num-allocs              82129
;  :num-checks              77
;  :propagations            87
;  :quant-instantiations    48
;  :rlimit-count            30026)
; [then-branch: 72 | sys__exc@41@02 == Null | dead]
; [else-branch: 72 | sys__exc@41@02 != Null | live]
(push) ; 7
; [else-branch: 72 | sys__exc@41@02 != Null]
(assert (not (= sys__exc@41@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
(pop) ; 5
(push) ; 5
; [else-branch: 51 | x__6@32@02 + y__7@34@02 < 100]
(assert (< (+ x__6@32@02 y__7@34@02) 100))
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
