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
  @flipped = false
  @all_ratings = ['G','PG','PG-13','R']	 
  @allM = Movie.all
  @ps = params[:sort]

	puts case @ps
	when 'title', 'release_date'
	       session[:sort] = @ps
		@allM = @ps == 'title' ? @allM.sort_by{|movie| movie.title } : @allM.sort_by{|movie| movie.release_date.to_s }
 	else
		if(session.has_key?(:sort) )
			params[:sort] = session[:sort] 
	     		@flipped = true
		end 
	end 		

=begin       if(@ps == 'title')
		session[:sort] = @ps
		@allM = @allM.sort_by{|movie| movie.title }
	elsif(@ps == 'release_date')
		session[:sort] = @ps
		@allM = @allM.sort_by{|movie| movie.release_date.to_s }
	elsif(session.has_key?(:sort) )
		params[:sort] = session[:sort]
		@flipped = true
	end
=end
	if(params[:ratings] != nil)
		session[:ratings] = params[:ratings]
		@ratings_to_show = params[:ratings]
		@allM = @allM.find_all{ |movie| params[:ratings].has_key?(movie.rating) }
	elsif(session.has_key?(:ratings) )
      		params[:ratings] = session[:ratings]
		@ratings_to_show = params[:ratings]
		@flipped = true
	end

	if(@flipped)
    		redirect_to movies_path(:sort=>params[:sort], :ratings =>params[:ratings] )
    	end
i
end
		

  def new
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



