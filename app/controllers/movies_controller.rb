class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
   def movie_ratings
  Movie.select(:rating).uniq.map(&:rating)
#Movie.select('distinct rating').map(&:ratng)
  end
   def index
    @movies = Movie.all
   
	@changes_made = 0   
@ratings_to_show = []
  if(@checked != nil)
	@ratings_to_show = @checked		
	@movies= @movies.find_all{ |movie| @checked.hs_key?(movie.rating) and @checked[movie.rating]==true}
    end 

	if(params[:sort].to_s == 'title')
	session[:sort] = params[:sort]
	@movies = @movies.sort_by{|movie| movie.title }
	elsif(params[:sort].to_s == 'release_date')
	session[:sort] = params[:sort]
	@movies= @movies.sort_by{|movie| movie.release_date.to_s }
	elsif(session.has_key?(:sort) )
	params[:sort] = session[:sort]
       
	@changes_made = @changes_made +1
	end

	if(params[:ratings] != nil)
	session[:ratings] = params[:ratings]
	@movies = @movies.find_all{ |movie| params[:ratings].has_key?(movie.rating) }
	elsif(session.has_key?(:ratings) )
      	params[:ratings] = session[:ratings]
      	@changes_made = @changes_made +1
	end

	if(@changes_made >=1)
    	redirect_to movies_path(:sort=>params[:sort], :ratings =>params[:ratings] )
    	end

	@checked = {}
	@all_ratings = ['G','PG','PG-13','R']
	
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

end



=begin
class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end





def index
    @all_ratings = Movie.all_ratings
    @saved_ratings = {}
    
    if params[:ratings] != nil
      @selected_ratings = params[:ratings]
      @movies = Movie.where(:rating => @selected_ratings.keys)
      
      @all_ratings.each do |rating|
        if @selected_ratings != nil && @selected_ratings[rating] != nil
          @saved_ratings[rating] = true
        else
          @saved_ratings[rating] = false
        end
      end
      session[:ratings] = params[:ratings]
    else
       @all_ratings.each do |rating|
         @saved_ratings[rating] = true
       end
       @movies = Movie.all
    end 
    
    @sort = ""
    if params[:sort] != nil 
      field = params[:sort]
      @movies = Movie.order(field)
      @sort = field
      session[:sort] = params[:sort]
    else
      #redirect_to controller: "movies", action: "index", sort: session[:sort]
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
=end
