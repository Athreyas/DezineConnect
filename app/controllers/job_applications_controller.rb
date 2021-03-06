

class JobApplicationsController < ApplicationController
  # GET /job_applications
  # GET /job_applications.xml
  def index
    @job_applications = JobApplication.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @job_applications }
    end
  end

  # GET /job_applications/1
  # GET /job_applications/1.xml
  def show
    @job_application = JobApplication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job_application }
    end
  end

  # GET /job_applications/new
  # GET /job_applications/new.xml
  def new
    @job_application = JobApplication.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job_application }
    end
  end

  # GET /job_applications/1/edit
  def edit
    @job_application = JobApplication.find(params[:id])
  end

  # POST /job_applications
  # POST /job_applications.xml
  def create
    @job_application = JobApplication.new(params[:job_application])
    @job_application.activation_key = ActiveSupport::SecureRandom.hex(4)
  
    respond_to do |format|
      if @job_application.save
        JobApplicationMailer.deliver_job_application_confirmation(@job_application)
        flash[:notice] = 'You have successfully applied for teh job.'
        format.html { render :action => "job_application_success" }
        format.xml  { render :xml => @job_application, :status => :created, :location => @job_application }
      else
        format.html { render :action => "error" }
        format.xml  { render :xml => @job_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /job_applications/1
  # PUT /job_applications/1.xml
  def update
    @job_application = JobApplication.find(params[:id])

    respond_to do |format|
      if @job_application.update_attributes(params[:job_application])
        flash[:notice] = 'JobApplication was successfully updated.'
        format.html { redirect_to(@job_application) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /job_applications/1
  # DELETE /job_applications/1.xml
  def destroy
    @job_application = JobApplication.find(params[:id])
    @job_application.destroy

    respond_to do |format|
      format.html { redirect_to(job_applications_url) }
      format.xml  { head :ok }
    end
  end

  def activate
    @job_application = JobApplication.find_by_activation_key(params[:id])
    @job_application.update_attribute(:activate, 1)
    JobApplicationMailer.deliver_job_application_sent_to_company(@job_application)
    #    session[:user_activated_to_show_page] = true
    #    session[:loggedin_user] = @user.id
    unless @job_application.nil? or @job_application.blank? then
      flash[:notice_job_appliction_before_login] = 'You have successfully applied for this job.'
      redirect_to "/jobs"
    else
      redirect_to "/jobs"
    end
  end

  def create_after_login
    logger.info "params in create_after_login : #{params.inspect}"
    @job_application = JobApplication.new(params[:job_application])
    unless session[:registered_user_id].nil? then
      @user = User.find_by_id(session[:registered_user_id])
      @job_application.user_id = @user.id
    end

    respond_to do |format|
      if @job_application.save
        JobApplicationMailer.deliver_job_application_sent_to_company(@job_application)
        flash[:notice_job_appliction_after_login] = 'You have successfully applied for this job.'
        format.html { redirect_to("/jobs") }
        format.xml  { render :xml => @job_application, :status => :created, :location => @job_application }
      else
        format.html { render :action => "error" }
        format.xml  { render :xml => @job_application.errors, :status => :unprocessable_entity }
      end
    end
  end


  
end
