#ifdef REFACTORINGSTART
__REFACTORINGSTART = DIAG_START_REFACTORING,
#undef REFACTORINGSTART
#endif

DIAG(err_refactor_no_selection, CLASS_ERROR, (unsigned)diag::Severity::Error, "refactoring action can't be initiated without a selection", 0, SFINAE_SubstitutionFailure, false, true, 22)
DIAG(err_refactor_selection_no_symbol, CLASS_ERROR, (unsigned)diag::Severity::Error, "there is no symbol at the given location", 0, SFINAE_SubstitutionFailure, false, true, 22)
