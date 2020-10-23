class Movie < ActiveRecord::Base
    def self.with_ratings(ratings_list)
         # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
        #  movies with those ratings
        # if ratings_list is nil, retrieve ALL movies
        if ratings_list.length == 0
            puts "wtf dude"
            return Movie.all()
        end
        # https://stackoverflow.com/questions/28954500/activerecord-where-field-array-of-possible-values
        return Movie.where('rating IN (?)', ratings_list)
    end

    def self.sorted_titles()
        return Movie.order(:title)
    end

    def self.sorted_release_date()
        return Movie.order(:release_date)
    end
    
    def self.possible_ratings()
        return ['G', 'R', 'PG-13', 'PG']
    end

end
