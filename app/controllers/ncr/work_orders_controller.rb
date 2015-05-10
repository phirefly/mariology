module Ncr
  class WorkOrdersController < ApplicationController
    before_filter :authenticate_user!
    before_filter ->{authorize self.work_order}, only: [:edit, :update]
    rescue_from Pundit::NotAuthorizedError, with: :auth_errors
    helper_method :approver_email_frozen?

    def new
      @work_order = Ncr::WorkOrder.new
      @approver_email = self.suggested_approver_email
      render 'form'
    end

    def create
      @approver_email = params[:approver_email]
      @work_order = Ncr::WorkOrder.new(permitted_params)

      if self.errors.empty?
        @work_order.requester = current_user
        @work_order.save
        @work_order.add_approvals(@approver_email)
        Dispatcher.deliver_new_proposal_emails(@work_order)
        flash[:success] = "Proposal submitted!"
        redirect_to proposal_path(@work_order)
      else
        flash[:error] = errors
        render 'form'
      end
    end

    def edit
      @work_order = self.work_order
      @approver_email = @work_order.approvals.first.user_email_address
      render 'form'
    end

    def update
      @work_order = self.work_order
      @work_order.assign_attributes(permitted_params)   # don't hit db yet
      @approver_email = params[:approver_email]

      if self.errors.empty?
        @work_order.save
        if !self.approver_email_frozen?
          @work_order.update_approver(@approver_email)
        end
        flash[:success] = "Proposal resubmitted!"
        redirect_to proposal_path(@work_order)
      else
        flash[:error] = errors
        render 'form'
      end
    end

    protected

    def suggested_approver_email
      last_cart = current_user.last_requested_cart
      last_cart.try(:approvers).try(:first).try(:email_address) || ""
    end

    def work_order
      @work_order ||= Ncr::WorkOrder.find(params[:id])
    end

    def approver_email_frozen?
      if self.work_order && self.work_order.approvals.first
        !self.work_order.approvals.first.pending?
      else
        false
      end
    end

    def permitted_params
      fields = Ncr::WorkOrder.relevant_fields(
        params[:ncr_work_order][:expense_type])
      params.require(:ncr_work_order).permit(:project_title, *fields)
    end

    def errors
      errors = []
      if @approver_email.blank? && !self.approver_email_frozen?
        errors = errors << "Approver email is required"
      end
      if !@work_order.valid?
        errors = errors + @work_order.errors.full_messages
      end
      errors
    end

    def auth_errors(exception)
      redirect_to new_ncr_work_order_path, :alert => exception.message
    end

  end
end
