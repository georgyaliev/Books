require 'csv'
require 'ostruct'
require 'date'

def make_date(date)
		if (date.size>4) 
			Date.parse(date)
		else (date.size<5)
			Date.parse("01-01"+date) 
		end
end

def make_openstruct(book_array)
	{
					link: book_array[0],
					title: book_array[1], 
					author: book_array[2], 
					pages: book_array[3].to_i, 
					date: make_date(book_array[4]), 
					rating: book_array[5].to_f, 
					genres: book_array[6]
	}
end

books = CSV.parse(File.read("books.txt"), row_sep: "\n", col_sep: "|")
			.map { |book| OpenStruct.new(make_openstruct(book))}

def month_statistics(books)
    books.sort_by {|book| book.date.month}
		 .map {|book| (book.date.strftime('%B'))}.uniq
    	 .map do |m|
    		puts "There are #{books.select { |book| book.date.strftime('%B') == m}.size} books were written in #{m} "
    end
end
month_statistics(books)
