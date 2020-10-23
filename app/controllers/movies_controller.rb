class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
    
    puts params
    # handle sessions
    used_session = false
    if !params.has_key?(:sort_title) && session[:sort_title]
      params[:sort_title] = session[:sort_title]
      used_session = true
    end
    if !params.has_key?(:sort_release_date) && session[:sort_release_date]
      params[:sort_release_date] = session[:sort_release_date]
      used_session = true
    end
    if !params.has_key?(:ratings) && session[:ratings]
      params[:ratings] = session[:ratings]
      used_session = true
    end
    puts used_session

    if used_session
      redirect_to movies_path(ratings: params[:ratings], sort_release_date: params[:sort_release_date], sort_title: params[:sort_title])
      return
    end

    # check for ratings box
    @all_ratings = Movie.possible_ratings
    checked_ratings = @all_ratings
    if params[:ratings]
      checked_ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
    end
    @ratings_to_show = checked_ratings
    @ratings_hash = Hash[@ratings_to_show.map {|x| [x, 1]}]
    @movies = Movie.with_ratings(checked_ratings)
    

    # check for sort title
    if params[:sort_title]
      @movies = @movies.sorted_titles()
      @sort_title = true
      session[:sort_title] = params[:sort_title]
    end

    # check for sort release date
    if params[:sort_release_date]
      @movies = @movies.sorted_release_date()
      @sort_release_date = true
      session[:sort_release_date] = params[:sort_release_date]
    end


  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
