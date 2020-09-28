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

def cool_print(book)
  "The book #{book.title} was written by #{book.author} at #{book.date} in #{book.genres} has #{book.pages} pages and #{book.rating} rating"
end

def array_sorted_by_pages(book_array)
  book_array.sort_by { |book| book.pages }.reverse 
end

def books_in_year (book_array, year)
  book_array.select {|book| book.date.year==year}
end

def find_all_novels(book_array)
  book_array.select {|book| book.genres.include?("Novels")}
end

def author_list_print(book_array)
  book_array.map{ |book| book.author.split(' ') }
            .sort_by{ |name| name.last }
            .uniq
end

def without_rating(book_array)
  book_array.select { |book| book.rating==0 }
end

def month_statistics(books)
  books.sort_by {|book| book.date.month}
       .map {|book| (book.date.strftime('%B'))}.uniq
       .map do |m|
        [m, books.select { |book| book.date.strftime('%B') == m}.size]
       end
end

puts "5 longest books are #{ array_sorted_by_pages(books).first(5).map{ |book| cool_print(book)} }"

puts "This books were written at 1847: #{ books_in_year(books, 1847).map {|book| cool_print(book) } }"

puts "This is 10 the oldes novels #{find_all_novels(books).sort_by{ |book| book.date }.first(10).map{|book| cool_print(book)}}"

puts "Authors list #{ author_list_print(books) }"

puts "This books haven't rating #{ without_rating(books).map{|book| cool_print(book)} } "

puts "This is month statistic: #{month_statistics(books)}"
