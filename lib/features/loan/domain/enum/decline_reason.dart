enum DeclineReason {
  randomCaseDecline('random_case_decline'),
  noSufficientBalance('no_sufficient_balance'),
  insufficientSalary('insufficient_salary'),
  expensesTooHigh('expenses_too_high'),
  creditCostTooHigh('credit_cost_too_high');

  final String trKey;

  const DeclineReason(this.trKey);
}
