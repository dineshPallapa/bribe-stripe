class UsersController < ApplicationController
  before_action :authenticate_user!
  def info
    @subscription = current_user.subscription
    if @subscription.active
      @stripe_customer = Stripe::Customer.retrieve(
        @subscription.stripe_user_id
      )
      @stripe_subscription = @stripe_customer.subscriptions.first
    end
  end

  def cancel_subscription
    @stripe_customer = Stripe::Customer.retrieve(
      current_user.subscription.stripe_user_id
    )
    @stripe_subscription = @stripe_customer.subscriptions.first
    @stripe_subscription.delete(at_period_end: true)

    current_user.subscription.active = false
    expires_at = Time.zone.at(@stripe_subscription.current_period_end)
    current_user.subscription.expires_at = expires_at
    current_user.subscription.stripe_user_id = nil
    current_user.subscription.save

    redirect_to users_info_path, notice: "your subscription is no longer avaliable"
  end

  def charge
    token = params['stripeToken']
    begin
      customer = Stripe::Customer.create(
        source: token,
        plan: 'plan_CtLZIHLppDpPLR',
        email: current_user.email
      )
      current_user.subscription.stripe_user_id = customer.id
      if params[:card_last4]
        current_user.subscription.card_brand = params[:card_brand]
        current_user.subscription.card_last4 = params[:card_last4]
        current_user.subscription.card_exp_month = params[:card_exp_month]
        current_user.subscription.card_exp_year = params[:card_exp_year]
      end
      current_user.subscription.active = true
      current_user.subscription.save

      redirect_to users_info_path
    rescue Stripe::CardError => e
      flash.alert = e.message
      redirect_to users_info_path
    end
  end
end
