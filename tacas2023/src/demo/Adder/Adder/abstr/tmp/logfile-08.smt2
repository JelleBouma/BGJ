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
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_internal_AdderC_EncodedGlobalVariables_java_DOT_lang_DOT_String_Integer ----------
(declare-const globals@5@08 $Ref)
(declare-const hostS@6@08 $Ref)
(declare-const portS@7@08 Int)
(declare-const sys__result@8@08 $Ref)
(declare-const globals@9@08 $Ref)
(declare-const hostS@10@08 $Ref)
(declare-const portS@11@08 Int)
(declare-const sys__result@12@08 $Ref)
(push) ; 1
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@13@08 $Snap)
(assert (= $t@13@08 ($Snap.combine ($Snap.first $t@13@08) ($Snap.second $t@13@08))))
(assert (= ($Snap.first $t@13@08) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@12@08 $Ref.null)))
(assert (=
  ($Snap.second $t@13@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@13@08))
    ($Snap.second ($Snap.second $t@13@08)))))
(assert (= ($Snap.first ($Snap.second $t@13@08)) $Snap.unit))
; [eval] type_of(sys__result) == class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
; [eval] type_of(sys__result)
; [eval] class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
(assert (=
  (type_of<TYPE> sys__result@12@08)
  (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@13@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@13@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@13@08))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@13@08))) $Snap.unit))
; [eval] sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@13@08))))
  5))
(pop) ; 2
(push) ; 2
; [exec]
; var diz__1: Ref
(declare-const diz__1@14@08 $Ref)
; [exec]
; diz__1 := new(demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state)
(declare-const diz__1@15@08 $Ref)
(assert (not (= diz__1@15@08 $Ref.null)))
(declare-const demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state@16@08 Int)
(assert (not (= diz__1@15@08 sys__result@12@08)))
(assert (not (= diz__1@15@08 globals@9@08)))
(assert (not (= diz__1@15@08 hostS@10@08)))
(assert (not (= diz__1@15@08 diz__1@14@08)))
; [exec]
; inhale type_of(diz__1) == class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
(declare-const $t@17@08 $Snap)
(assert (= $t@17@08 $Snap.unit))
; [eval] type_of(diz__1) == class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
; [eval] type_of(diz__1)
; [eval] class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
(assert (=
  (type_of<TYPE> diz__1@15@08)
  (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz__1.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state := 5
; [exec]
; label method_end_internal_AdderC_5
; [exec]
; sys__result := diz__1
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC() && acc(sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state, write) && sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
; [eval] type_of(sys__result)
; [eval] class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
; [eval] sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Client_main_java_DOT_lang_DOT_Object_EncodedGlobalVariables_Option$Array$Cell$java_DOT_lang_DOT_String$$$ ----------
(declare-const globals@18@08 $Ref)
(declare-const args@19@08 VCTOption<VCTArray<Ref>>)
(declare-const sys__exc@20@08 $Ref)
(declare-const globals@21@08 $Ref)
(declare-const args@22@08 VCTOption<VCTArray<Ref>>)
(declare-const sys__exc@23@08 $Ref)
(push) ; 1
(declare-const $t@24@08 $Snap)
(assert (= $t@24@08 ($Snap.combine ($Snap.first $t@24@08) ($Snap.second $t@24@08))))
(assert (= ($Snap.first $t@24@08) $Snap.unit))
; [eval] args != (VCTNone(): VCTOption[VCTArray[Ref]])
; [eval] (VCTNone(): VCTOption[VCTArray[Ref]])
(assert (not
  (= args@22@08 (as VCTNone<VCTOption<VCTArray<Ref>>>  VCTOption<VCTArray<Ref>>))))
(assert (=
  ($Snap.second $t@24@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@08))
    ($Snap.second ($Snap.second $t@24@08)))))
(assert (= ($Snap.first ($Snap.second $t@24@08)) $Snap.unit))
; [eval] (alen(getVCTOption1(args)): Int) == 2
; [eval] (alen(getVCTOption1(args)): Int)
; [eval] getVCTOption1(args)
(push) ; 2
; [eval] x != (VCTNone(): VCTOption[VCTArray[Ref]])
; [eval] (VCTNone(): VCTOption[VCTArray[Ref]])
(pop) ; 2
; Joined path conditions
(assert (= (alen<Int> (getVCTOption1 $Snap.unit args@22@08)) 2))
(assert (=
  ($Snap.second ($Snap.second $t@24@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))
; [eval] (loc(getVCTOption1(args), 0): Ref)
; [eval] getVCTOption1(args)
(push) ; 2
; [eval] x != (VCTNone(): VCTOption[VCTArray[Ref]])
; [eval] (VCTNone(): VCTOption[VCTArray[Ref]])
(pop) ; 2
; Joined path conditions
(assert (not (= (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 0) $Ref.null)))
; [eval] (loc(getVCTOption1(args), 1): Ref)
; [eval] getVCTOption1(args)
(push) ; 2
; [eval] x != (VCTNone(): VCTOption[VCTArray[Ref]])
; [eval] (VCTNone(): VCTOption[VCTArray[Ref]])
(pop) ; 2
; Joined path conditions
(set-option :timeout 10)
(push) ; 2
(assert (not (=
  (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 0)
  (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 1))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              3
;  :final-checks            5
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.31
;  :mk-bool-var             122
;  :mk-clause               7
;  :num-allocs              52343
;  :num-checks              4
;  :propagations            41
;  :quant-instantiations    6
;  :rlimit-count            14615)
(assert (not (= (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 1) $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@25@08 $Snap)
(assert (= $t@25@08 ($Snap.combine ($Snap.first $t@25@08) ($Snap.second $t@25@08))))
(assert (= ($Snap.first $t@25@08) $Snap.unit))
; [eval] sys__exc == null ==> true
; [eval] sys__exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= sys__exc@23@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               59
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   8
;  :datatype-splits         5
;  :decisions               7
;  :del-clause              9
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.32
;  :mk-bool-var             132
;  :mk-clause               10
;  :num-allocs              53695
;  :num-checks              6
;  :propagations            43
;  :quant-instantiations    7
;  :rlimit-count            15163)
(push) ; 4
(assert (not (= sys__exc@23@08 $Ref.null)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               66
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   11
;  :datatype-splits         6
;  :decisions               10
;  :del-clause              9
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.32
;  :mk-bool-var             134
;  :mk-clause               10
;  :num-allocs              54289
;  :num-checks              7
;  :propagations            43
;  :quant-instantiations    7
;  :rlimit-count            15355)
; [then-branch: 0 | sys__exc@23@08 == Null | live]
; [else-branch: 0 | sys__exc@23@08 != Null | live]
(push) ; 4
; [then-branch: 0 | sys__exc@23@08 == Null]
(assert (= sys__exc@23@08 $Ref.null))
(pop) ; 4
(push) ; 4
; [else-branch: 0 | sys__exc@23@08 != Null]
(assert (not (= sys__exc@23@08 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (=
  ($Snap.second $t@25@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@25@08))
    ($Snap.second ($Snap.second $t@25@08)))))
(assert (= ($Snap.first ($Snap.second $t@25@08)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 3
; [then-branch: 1 | sys__exc@23@08 != Null | live]
; [else-branch: 1 | sys__exc@23@08 == Null | live]
(push) ; 4
; [then-branch: 1 | sys__exc@23@08 != Null]
(assert (not (= sys__exc@23@08 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 5
(pop) ; 5
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 1 | sys__exc@23@08 == Null]
(assert (= sys__exc@23@08 $Ref.null))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@23@08 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               83
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   14
;  :datatype-splits         7
;  :decisions               14
;  :del-clause              16
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.33
;  :mk-bool-var             147
;  :mk-clause               17
;  :num-allocs              55119
;  :num-checks              8
;  :propagations            45
;  :quant-instantiations    10
;  :rlimit-count            15923
;  :time                    0.00)
(push) ; 4
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@23@08 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               91
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               18
;  :del-clause              24
;  :final-checks            15
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.33
;  :mk-bool-var             157
;  :mk-clause               25
;  :num-allocs              55769
;  :num-checks              9
;  :propagations            49
;  :quant-instantiations    13
;  :rlimit-count            16241)
; [then-branch: 2 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@08 != Null | live]
; [else-branch: 2 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@08 != Null) | live]
(push) ; 4
; [then-branch: 2 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@08 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@23@08 $Ref.null))))
(pop) ; 4
(push) ; 4
; [else-branch: 2 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@23@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@23@08 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@23@08 $Ref.null)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@25@08)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 3
(push) ; 4
(assert (not (= sys__exc@23@08 $Ref.null)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               98
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   18
;  :datatype-splits         8
;  :decisions               20
;  :del-clause              24
;  :final-checks            16
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.33
;  :mk-bool-var             159
;  :mk-clause               25
;  :num-allocs              56440
;  :num-checks              10
;  :propagations            49
;  :quant-instantiations    13
;  :rlimit-count            16500)
(push) ; 4
(assert (not (not (= sys__exc@23@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               105
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   19
;  :datatype-splits         8
;  :decisions               22
;  :del-clause              24
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.33
;  :mk-bool-var             160
;  :mk-clause               25
;  :num-allocs              57038
;  :num-checks              11
;  :propagations            49
;  :quant-instantiations    13
;  :rlimit-count            16657)
; [then-branch: 3 | sys__exc@23@08 != Null | live]
; [else-branch: 3 | sys__exc@23@08 == Null | live]
(push) ; 4
; [then-branch: 3 | sys__exc@23@08 != Null]
(assert (not (= sys__exc@23@08 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 5
; [then-branch: 4 | sys__exc@23@08 != Null | live]
; [else-branch: 4 | sys__exc@23@08 == Null | live]
(push) ; 6
; [then-branch: 4 | sys__exc@23@08 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 7
(pop) ; 7
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 4 | sys__exc@23@08 == Null]
(assert (= sys__exc@23@08 $Ref.null))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 3 | sys__exc@23@08 == Null]
(assert (= sys__exc@23@08 $Ref.null))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not (= sys__exc@23@08 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@23@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@23@08 $Ref.null)))))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_1__2: Ref
(declare-const __flatten_1__2@26@08 $Ref)
; [exec]
; var __flatten_2__3: Ref
(declare-const __flatten_2__3@27@08 $Ref)
; [exec]
; var __flatten_3__4: Int
(declare-const __flatten_3__4@28@08 Int)
; [exec]
; var __flatten_4__5: Ref
(declare-const __flatten_4__5@29@08 $Ref)
; [exec]
; sys__exc := null
; [exec]
; __flatten_1__2 := (loc(getVCTOption1(args), 0): Ref)
; [eval] (loc(getVCTOption1(args), 0): Ref)
; [eval] getVCTOption1(args)
(push) ; 3
; [eval] x != (VCTNone(): VCTOption[VCTArray[Ref]])
; [eval] (VCTNone(): VCTOption[VCTArray[Ref]])
(pop) ; 3
; Joined path conditions
(declare-const __flatten_1__2@30@08 $Ref)
(assert (= __flatten_1__2@30@08 (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 0)))
; [exec]
; __flatten_2__3 := (loc(getVCTOption1(args), 1): Ref)
; [eval] (loc(getVCTOption1(args), 1): Ref)
; [eval] getVCTOption1(args)
(push) ; 3
; [eval] x != (VCTNone(): VCTOption[VCTArray[Ref]])
; [eval] (VCTNone(): VCTOption[VCTArray[Ref]])
(pop) ; 3
; Joined path conditions
(declare-const __flatten_2__3@31@08 $Ref)
(assert (= __flatten_2__3@31@08 (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 1)))
; [exec]
; __flatten_3__4 := demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Utilities_parseInt_EncodedGlobalVariables_java_DOT_lang_DOT_String(globals, __flatten_2__3.Ref__item)
(push) ; 3
(assert (not (= (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 1) __flatten_2__3@31@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               107
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   19
;  :datatype-splits         8
;  :decisions               22
;  :del-clause              24
;  :final-checks            17
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.33
;  :mk-bool-var             163
;  :mk-clause               25
;  :num-allocs              57270
;  :num-checks              12
;  :propagations            49
;  :quant-instantiations    13
;  :rlimit-count            16892)
(declare-const sys__result@32@08 Int)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; __flatten_4__5 := demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_AdderC_EncodedGlobalVariables_java_DOT_lang_DOT_String_Integer(globals, __flatten_1__2.Ref__item, __flatten_3__4)
(set-option :timeout 10)
(push) ; 3
(assert (not (= (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 1) __flatten_1__2@30@08)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               115
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   21
;  :datatype-splits         8
;  :decisions               26
;  :del-clause              24
;  :final-checks            19
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.33
;  :mk-bool-var             164
;  :mk-clause               25
;  :num-allocs              58374
;  :num-checks              14
;  :propagations            49
;  :quant-instantiations    13
;  :rlimit-count            17163)
(push) ; 3
(assert (not (= (loc<Ref> (getVCTOption1 $Snap.unit args@22@08) 0) __flatten_1__2@30@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               115
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   21
;  :datatype-splits         8
;  :decisions               26
;  :del-clause              24
;  :final-checks            19
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.33
;  :mk-bool-var             164
;  :mk-clause               25
;  :num-allocs              58394
;  :num-checks              15
;  :propagations            49
;  :quant-instantiations    13
;  :rlimit-count            17174)
(declare-const sys__result@33@08 $Ref)
(declare-const $t@34@08 $Snap)
(assert (= $t@34@08 ($Snap.combine ($Snap.first $t@34@08) ($Snap.second $t@34@08))))
(assert (= ($Snap.first $t@34@08) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@33@08 $Ref.null)))
(assert (=
  ($Snap.second $t@34@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@34@08))
    ($Snap.second ($Snap.second $t@34@08)))))
(assert (= ($Snap.first ($Snap.second $t@34@08)) $Snap.unit))
; [eval] type_of(sys__result) == class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
; [eval] type_of(sys__result)
; [eval] class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC()
(assert (=
  (type_of<TYPE> sys__result@33@08)
  (as class_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@34@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@34@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@34@08))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@34@08))) $Snap.unit))
; [eval] sys__result.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@34@08))))
  5))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; sys__exc := demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_Client_client_java_DOT_lang_DOT_Object_EncodedGlobalVariables_demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC(globals, __flatten_4__5)
; [eval] a.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 5
(declare-const sys__exc@35@08 $Ref)
(declare-const $t@36@08 $Snap)
(assert (= $t@36@08 ($Snap.combine ($Snap.first $t@36@08) ($Snap.second $t@36@08))))
; [eval] sys__exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= sys__exc@35@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               165
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 32
;  :datatype-occurs-check   30
;  :datatype-splits         12
;  :decisions               34
;  :del-clause              24
;  :final-checks            23
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.34
;  :mk-bool-var             180
;  :mk-clause               25
;  :num-allocs              59931
;  :num-checks              17
;  :propagations            49
;  :quant-instantiations    14
;  :rlimit-count            18192)
(push) ; 3
(assert (not (= sys__exc@35@08 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 37
;  :datatype-occurs-check   35
;  :datatype-splits         15
;  :decisions               39
;  :del-clause              24
;  :final-checks            25
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.34
;  :mk-bool-var             184
;  :mk-clause               25
;  :num-allocs              60565
;  :num-checks              18
;  :propagations            49
;  :quant-instantiations    14
;  :rlimit-count            18421)
; [then-branch: 5 | sys__exc@35@08 == Null | live]
; [else-branch: 5 | sys__exc@35@08 != Null | live]
(push) ; 3
; [then-branch: 5 | sys__exc@35@08 == Null]
(assert (= sys__exc@35@08 $Ref.null))
(assert (=
  ($Snap.first $t@36@08)
  ($Snap.combine
    ($Snap.first ($Snap.first $t@36@08))
    ($Snap.second ($Snap.first $t@36@08)))))
(assert (= ($Snap.second ($Snap.first $t@36@08)) $Snap.unit))
; [eval] a.demo_DOT_Adder_DOT_Adder_DOT_abstr_DOT_AdderC_state == 6
(assert (= ($SortWrappers.$SnapToInt ($Snap.first ($Snap.first $t@36@08))) 6))
(assert (=
  ($Snap.second $t@36@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@36@08))
    ($Snap.second ($Snap.second $t@36@08)))))
(assert (= ($Snap.first ($Snap.second $t@36@08)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 6 | sys__exc@35@08 != Null | live]
; [else-branch: 6 | sys__exc@35@08 == Null | live]
(push) ; 5
; [then-branch: 6 | sys__exc@35@08 != Null]
(assert (not (= sys__exc@35@08 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 6 | sys__exc@35@08 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@35@08 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               194
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               1
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 37
;  :datatype-occurs-check   35
;  :datatype-splits         15
;  :decisions               39
;  :del-clause              24
;  :final-checks            25
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.35
;  :mk-bool-var             191
;  :mk-clause               25
;  :num-allocs              60788
;  :num-checks              19
;  :propagations            49
;  :quant-instantiations    15
;  :rlimit-count            18865)
; [then-branch: 7 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null | dead]
; [else-branch: 7 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null) | live]
(push) ; 5
; [else-branch: 7 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@35@08 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@36@08)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 8 | sys__exc@35@08 != Null | dead]
; [else-branch: 8 | sys__exc@35@08 == Null | live]
(push) ; 5
; [else-branch: 8 | sys__exc@35@08 == Null]
(pop) ; 5
(pop) ; 4
; Joined path conditions
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] sys__exc != null
; [then-branch: 9 | sys__exc@35@08 != Null | dead]
; [else-branch: 9 | sys__exc@35@08 == Null | live]
(push) ; 4
; [else-branch: 9 | sys__exc@35@08 == Null]
(pop) ; 4
; [eval] !(sys__exc != null)
; [eval] sys__exc != null
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= sys__exc@35@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               239
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   57
;  :datatype-splits         23
;  :decisions               50
;  :del-clause              24
;  :final-checks            31
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             202
;  :mk-clause               26
;  :num-allocs              62155
;  :num-checks              21
;  :propagations            50
;  :quant-instantiations    15
;  :rlimit-count            19384)
; [then-branch: 10 | sys__exc@35@08 == Null | live]
; [else-branch: 10 | sys__exc@35@08 != Null | dead]
(push) ; 4
; [then-branch: 10 | sys__exc@35@08 == Null]
; [exec]
; label method_end_main_13
; [eval] sys__exc == null ==> true
; [eval] sys__exc == null
(push) ; 5
(push) ; 6
(assert (not (not (= sys__exc@35@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               259
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               2
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 56
;  :datatype-occurs-check   68
;  :datatype-splits         27
;  :decisions               55
;  :del-clause              24
;  :final-checks            34
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             205
;  :mk-clause               26
;  :num-allocs              62763
;  :num-checks              22
;  :propagations            51
;  :quant-instantiations    15
;  :rlimit-count            19606)
; [then-branch: 11 | sys__exc@35@08 == Null | live]
; [else-branch: 11 | sys__exc@35@08 != Null | dead]
(push) ; 6
; [then-branch: 11 | sys__exc@35@08 == Null]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 5
; [then-branch: 12 | sys__exc@35@08 != Null | live]
; [else-branch: 12 | sys__exc@35@08 == Null | live]
(push) ; 6
; [then-branch: 12 | sys__exc@35@08 != Null]
(assert (not (= sys__exc@35@08 $Ref.null)))
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 7
(pop) ; 7
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 12 | sys__exc@35@08 == Null]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@35@08 $Ref.null))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               259
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 56
;  :datatype-occurs-check   68
;  :datatype-splits         27
;  :decisions               55
;  :del-clause              24
;  :final-checks            34
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             205
;  :mk-clause               26
;  :num-allocs              62780
;  :num-checks              23
;  :propagations            51
;  :quant-instantiations    15
;  :rlimit-count            19658)
; [then-branch: 13 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null | dead]
; [else-branch: 13 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null) | live]
(push) ; 6
; [else-branch: 13 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@35@08 $Ref.null)))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 5
; [then-branch: 14 | sys__exc@35@08 != Null | dead]
; [else-branch: 14 | sys__exc@35@08 == Null | live]
(push) ; 6
; [else-branch: 14 | sys__exc@35@08 == Null]
(pop) ; 6
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
(push) ; 3
; [else-branch: 5 | sys__exc@35@08 != Null]
(assert (not (= sys__exc@35@08 $Ref.null)))
(assert (= ($Snap.first $t@36@08) $Snap.unit))
(assert (=
  ($Snap.second $t@36@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@36@08))
    ($Snap.second ($Snap.second $t@36@08)))))
(assert (= ($Snap.first ($Snap.second $t@36@08)) $Snap.unit))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
; [then-branch: 15 | sys__exc@35@08 != Null | live]
; [else-branch: 15 | sys__exc@35@08 == Null | live]
(push) ; 5
; [then-branch: 15 | sys__exc@35@08 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 6
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 15 | sys__exc@35@08 == Null]
(assert (= sys__exc@35@08 $Ref.null))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(push) ; 5
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@35@08 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               282
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   73
;  :datatype-splits         29
;  :decisions               60
;  :del-clause              32
;  :final-checks            36
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             219
;  :mk-clause               33
;  :num-allocs              63564
;  :num-checks              24
;  :propagations            53
;  :quant-instantiations    18
;  :rlimit-count            20252)
(push) ; 5
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@35@08 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               295
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   78
;  :datatype-splits         31
;  :decisions               64
;  :del-clause              39
;  :final-checks            38
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             229
;  :mk-clause               40
;  :num-allocs              64240
;  :num-checks              25
;  :propagations            57
;  :quant-instantiations    21
;  :rlimit-count            20548)
; [then-branch: 16 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null | live]
; [else-branch: 16 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null) | live]
(push) ; 5
; [then-branch: 16 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@35@08 $Ref.null))))
(pop) ; 5
(push) ; 5
; [else-branch: 16 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null)]
(assert (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@35@08 $Ref.null)))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (= ($Snap.second ($Snap.second $t@36@08)) $Snap.unit))
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 4
(push) ; 5
(assert (not (= sys__exc@35@08 $Ref.null)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 67
;  :datatype-occurs-check   82
;  :datatype-splits         32
;  :decisions               67
;  :del-clause              39
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             231
;  :mk-clause               40
;  :num-allocs              64898
;  :num-checks              26
;  :propagations            57
;  :quant-instantiations    21
;  :rlimit-count            20798)
(push) ; 5
(assert (not (not (= sys__exc@35@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 67
;  :datatype-occurs-check   82
;  :datatype-splits         32
;  :decisions               67
;  :del-clause              39
;  :final-checks            40
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             231
;  :mk-clause               40
;  :num-allocs              64913
;  :num-checks              27
;  :propagations            57
;  :quant-instantiations    21
;  :rlimit-count            20809)
; [then-branch: 17 | sys__exc@35@08 != Null | live]
; [else-branch: 17 | sys__exc@35@08 == Null | dead]
(push) ; 5
; [then-branch: 17 | sys__exc@35@08 != Null]
(assert (not (= sys__exc@35@08 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 6
; [then-branch: 18 | sys__exc@35@08 != Null | live]
; [else-branch: 18 | sys__exc@35@08 == Null | live]
(push) ; 7
; [then-branch: 18 | sys__exc@35@08 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 8
(pop) ; 8
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 18 | sys__exc@35@08 == Null]
(assert (= sys__exc@35@08 $Ref.null))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (not (= sys__exc@35@08 $Ref.null))
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@35@08 $Ref.null)))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] sys__exc != null
(set-option :timeout 10)
(push) ; 4
(assert (not (= sys__exc@35@08 $Ref.null)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               335
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   90
;  :datatype-splits         34
;  :decisions               75
;  :del-clause              45
;  :final-checks            44
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             241
;  :mk-clause               47
;  :num-allocs              66175
;  :num-checks              29
;  :propagations            59
;  :quant-instantiations    24
;  :rlimit-count            21296)
(push) ; 4
(assert (not (not (= sys__exc@35@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               335
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   90
;  :datatype-splits         34
;  :decisions               75
;  :del-clause              45
;  :final-checks            44
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             241
;  :mk-clause               47
;  :num-allocs              66190
;  :num-checks              30
;  :propagations            59
;  :quant-instantiations    24
;  :rlimit-count            21307)
; [then-branch: 19 | sys__exc@35@08 != Null | live]
; [else-branch: 19 | sys__exc@35@08 == Null | dead]
(push) ; 4
; [then-branch: 19 | sys__exc@35@08 != Null]
(assert (not (= sys__exc@35@08 $Ref.null)))
; [exec]
; label method_end_main_13
; [eval] sys__exc == null ==> true
; [eval] sys__exc == null
(push) ; 5
; [then-branch: 20 | sys__exc@35@08 == Null | dead]
; [else-branch: 20 | sys__exc@35@08 != Null | live]
(push) ; 6
; [else-branch: 20 | sys__exc@35@08 != Null]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception()) ==> true
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 5
; [then-branch: 21 | sys__exc@35@08 != Null | live]
; [else-branch: 21 | sys__exc@35@08 == Null | live]
(push) ; 6
; [then-branch: 21 | sys__exc@35@08 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 7
(pop) ; 7
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 21 | sys__exc@35@08 == Null]
(assert (= sys__exc@35@08 $Ref.null))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not
  (and
    (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
    (not (= sys__exc@35@08 $Ref.null))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               349
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   94
;  :datatype-splits         35
;  :decisions               79
;  :del-clause              45
;  :final-checks            46
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             242
;  :mk-clause               47
;  :num-allocs              66792
;  :num-checks              31
;  :propagations            59
;  :quant-instantiations    24
;  :rlimit-count            21536)
(push) ; 6
(assert (not (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@35@08 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               349
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   94
;  :datatype-splits         35
;  :decisions               79
;  :del-clause              45
;  :final-checks            46
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             242
;  :mk-clause               47
;  :num-allocs              66807
;  :num-checks              32
;  :propagations            59
;  :quant-instantiations    24
;  :rlimit-count            21549)
; [then-branch: 22 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null | live]
; [else-branch: 22 | !(instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null) | dead]
(push) ; 6
; [then-branch: 22 | instanceof_TYPE_TYPE(_, type_of[TYPE](sys__exc@35@08), class_java_DOT_lang_DOT_Exception[TYPE]) && sys__exc@35@08 != Null]
(assert (and
  (instanceof_TYPE_TYPE $Snap.unit (type_of<TYPE> sys__exc@35@08) (as class_java_DOT_lang_DOT_Exception<TYPE>  TYPE))
  (not (= sys__exc@35@08 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] sys__exc != null ==> sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 5
(push) ; 6
(assert (not (= sys__exc@35@08 $Ref.null)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               363
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 79
;  :datatype-occurs-check   98
;  :datatype-splits         36
;  :decisions               83
;  :del-clause              45
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             243
;  :mk-clause               47
;  :num-allocs              67409
;  :num-checks              33
;  :propagations            59
;  :quant-instantiations    24
;  :rlimit-count            21742)
(push) ; 6
(assert (not (not (= sys__exc@35@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               363
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 79
;  :datatype-occurs-check   98
;  :datatype-splits         36
;  :decisions               83
;  :del-clause              45
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             243
;  :mk-clause               47
;  :num-allocs              67424
;  :num-checks              34
;  :propagations            59
;  :quant-instantiations    24
;  :rlimit-count            21753)
; [then-branch: 23 | sys__exc@35@08 != Null | live]
; [else-branch: 23 | sys__exc@35@08 == Null | dead]
(push) ; 6
; [then-branch: 23 | sys__exc@35@08 != Null]
(assert (not (= sys__exc@35@08 $Ref.null)))
; [eval] sys__exc != null && instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] sys__exc != null
(push) ; 7
; [then-branch: 24 | sys__exc@35@08 != Null | live]
; [else-branch: 24 | sys__exc@35@08 == Null | live]
(push) ; 8
; [then-branch: 24 | sys__exc@35@08 != Null]
; [eval] instanceof_TYPE_TYPE(type_of(sys__exc), class_java_DOT_lang_DOT_Exception())
; [eval] type_of(sys__exc)
; [eval] class_java_DOT_lang_DOT_Exception()
(push) ; 9
(pop) ; 9
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 24 | sys__exc@35@08 == Null]
(assert (= sys__exc@35@08 $Ref.null))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(pop) ; 5
; Joined path conditions
(pop) ; 4
; [eval] !(sys__exc != null)
; [eval] sys__exc != null
(push) ; 4
(assert (not (not (= sys__exc@35@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               363
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :binary-propagations     37
;  :conflicts               3
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 79
;  :datatype-occurs-check   98
;  :datatype-splits         36
;  :decisions               83
;  :del-clause              45
;  :final-checks            48
;  :max-generation          2
;  :max-memory              3.53
;  :memory                  3.36
;  :mk-bool-var             243
;  :mk-clause               47
;  :num-allocs              67445
;  :num-checks              35
;  :propagations            59
;  :quant-instantiations    24
;  :rlimit-count            21794)
; [then-branch: 25 | sys__exc@35@08 == Null | dead]
; [else-branch: 25 | sys__exc@35@08 != Null | live]
(push) ; 4
; [else-branch: 25 | sys__exc@35@08 != Null]
(assert (not (= sys__exc@35@08 $Ref.null)))
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
