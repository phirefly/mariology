module MailerHelper
  def status_icon_tag(status, last_approver = false)
    base_url = root_url.gsub(/\?.*$/, "").chomp("/")
    bg_linear_image = base_url + image_path("bg_#{status}_status.gif")

    image_tag(
      base_url + image_path("icon-#{status}.png"),
      class: "status-icon #{status} linear",
      style: ("background-image: url('#{bg_linear_image}');" unless last_approver)
    )
  end

  def generate_bookend_class(index, count)
    case index
    when count - 1
      "class=last"
    when 0
      "class=first"
    else
      ""
    end
  end

  def generate_approve_url(approval)
    proposal = approval.proposal
    opts = { version: proposal.version, cch: approval.api_token.access_token }
    complete_proposal_url(proposal, opts)
  end

  def observer_text(observation, reason = nil)
    text = t("mailer.observer_mailer.on_observer_added.body")
    add_author(text, observation.created_by)
    add_reason(text, reason)
    text + "."
  end

  def add_author(text, user)
    if user
      text << " by #{user.full_name}"
    end
  end

  def add_reason(text, reason)
    if reason.present?
      text << t("mailer.reason", reason: reason)
    end
  end

  def complete_text(step)
    if step.is_a?(Steps::Purchase)
      t("mailer.step_mailer.step_reply_received.purchased")
    else
      t("mailer.step_mailer.step_reply_received.approved")
    end
  end
end
