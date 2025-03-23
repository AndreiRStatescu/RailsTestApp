class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [ :join, :leave ]

  def index
    @accounts = Account.order(:id)
    @user_accounts = current_user.accounts
  end

  def join
    unless current_user.accounts.include?(@account)
      current_user.accounts << @account
      flash[:notice] = "You have joined the #{@account.name} account"
    end
    redirect_to accounts_path
  end

  def leave
    if current_user.accounts.include?(@account)
      current_user.accounts.delete(@account)
      flash[:notice] = "You have left the #{@account.name} account"
    end
    redirect_to accounts_path
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end
end
