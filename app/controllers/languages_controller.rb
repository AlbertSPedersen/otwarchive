class LanguagesController < ApplicationController

  def index
    @languages = Language.default_order
    @works_counts = Rails.cache.fetch("/v1/languages/work_counts", expires_in: 1.day) do
      WorkQuery.new.works_per_language(@languages.count)
    end
  end

  def new
    @language = Language.new
    authorize @language
  end

  def create
    @language = Language.new(language_params)
    authorize @language
    if @language.save
      flash[:notice] = t('successfully_added', default: 'Language was successfully added.')
      redirect_to languages_path
    else
      render action: "new"
    end
  end

  def edit
    @language = Language.find_by(short: params[:id])
    authorize @language
  end

  def update
    @language = Language.find_by(short: params[:id])
    authorize @language
    if @language.update(language_params)
      flash[:notice] = t('successfully_updated', default: 'Language was successfully updated.')
      redirect_to languages_path
    else
      render action: "new"
    end
  end

  private
  def language_params
    params.require(:language).permit(
      :name, :short, :support_available, :abuse_support_available, :sortable_name
    )
  end
end
