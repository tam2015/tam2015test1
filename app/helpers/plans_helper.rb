module PlansHelper

  def middle_plan(plan)
    plan.name == "prata"
  end

  def full_plan(plan)
    plan.name == "ouro"
  end

end
