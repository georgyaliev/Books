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

books = CSV.parse(File.read("books.txt"), row_sep: "\n", col_sep: "|")
           .map do |book|
				OpenStruct.new(
					link: book[0],
					title: book[1], 
					author: book[2], 
					pages: book[3].to_i, 
					date: make_date(book[4]), 
					rating: book[5].to_f, 
					genres: book[6]
				)
			end

month = books.sort_by {|book| book.date.month}
			 .map {|book| (book.date.strftime('%B'))}.uniq

def month_statistics(books, month)
    month.map do |m|
    		puts "There are #{books.select { |book| book.date.strftime('%B') == m}.size} books were written in #{m} "
    end
end
month_statistics(books, month)