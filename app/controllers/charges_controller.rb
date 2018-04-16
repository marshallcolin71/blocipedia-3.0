class ChargesController < ApplicationController
  def create
    customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
   )

   # Where the real magic happens
   charge = Stripe::Charge.create(
     customer: customer.id, # Note -- this is NOT the user_id in your app
     amount: Amount.default,
     description: "Account Upgrade - #{current_user.email}",
     currency: 'usd'
   )

   current_user.update_attribute(:standard, false)
   current_user.update_attribute(:premium, true)

   flash[:notice] = "Thanks for updating your account, #{current_user.email}! You will now have access to premium content."
   redirect_to root_path

   # Stripe will send back CardErrors, with friendly messages
   # when something goes wrong.
   rescue Stripe::CardError => e
     flash[:alert] = e.message
     redirect_to new_charge_path
  end

  def new
    @stripe_btn_data = {
      key: "#{Rails.configuration.stripe[:publishable_key]}",
      description: "Blocipedia Membership - #{current_user.email}",
      amount: 15_00
    }
  end
  
end
