module Enterprise::Captain::BaseTaskService
  def perform
    unless captain_tasks_enabled?
      return { error: I18n.t('captain.disabled') }
    end

    super
  end

  private

  def responses_available?
    return true unless ChatwootApp.chatwoot_cloud?

    account.usage_limits[:captain][:responses][:current_available].positive?
  end

  def successful_result?(result)
    result.is_a?(Hash) && result[:message].present? && !result[:error]
  end

  def increment_usage
    Rails.logger.info("[CAPTAIN][#{self.class.name}] Incrementing response usage for account #{account.id}")
    account.increment_response_usage
  end
end
