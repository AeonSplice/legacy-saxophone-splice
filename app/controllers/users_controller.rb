class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = policy_scope(User.all)
  end

  # GET /users/:token/activate
  def activate
    if @user = User.load_from_activation_token(params[:token])
      @user.activate!
      redirect_to login_path, success: 'Successfully activated!'
    else
      redirect_to root_path, error: 'Invalid activation token.'
    end
  end

  # GET /users/:id
  # GET /users/:id.json
  def show
    authorize @user, :show?
  end

  # GET /users/new
  def new
    # TODO: Change to authorize begin/rescue
    redirect_back fallback_location: root_path, error: 'Already logged in.' and return if current_user
    @user = User.new
  end

  # GET /users/:id/edit
  def edit
    authorize @user, :edit?
  end

  # POST /users
  # POST /users.json
  def create
    # Limit user creation for testing (don't let bots fuck with me TOO hard).
    redirect_to users_path, error: 'Too many users. Stahp.' and return if User.count >= 20

    @user = User.new(user_params)

    respond_to do |format|
      if recaptcha_passed(@user) && @user.save
        format.html { redirect_to root_path, success: 'Account created, check your email for your activation link.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/:id
  # PATCH/PUT /users/:id.json
  def update
    authorize @user, :update?
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, success: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:id
  # DELETE /users/:id.json
  def destroy
    authorize @user, :destroy?
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, success: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Override record not found defaults
    def record_not_found
      skip_auth
      redirect_to users_path, error: 'Could not find that user.'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
