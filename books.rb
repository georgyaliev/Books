require 'csv'
require 'ostruct'
require 'date'

def make_date(date)
  if (date.size>4) 
    Date.parse(date)
  else (date.size<5)
    Date.parse( "01-01" + date ) 
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

def search(book_array, parameter, *y)
    case parameter
    when "month_statistics"
      book_array.sort_by { |book| book.date.month }
             .map { |book| (book.date.strftime('%B')) }.uniq
             .map do |m|
              [m, book_array.select { |book| book.date.strftime('%B') == m }.size]
             end
             
    when "without_rating"
      book_array.select { |book| book.rating==0 }

    when "author_list"
      book_array.map{ |book| book.author.split(' ') }
                .sort_by{ |name| name.last }
                .uniq

    when "find_all_novels"
      book_array.select { |book| book.genres.include?("Novels")}

    when "books_in_year"
      book_array.select { |book| book.date.year == y[0]}

    when "sort_by_pages"
      book_array.sort_by { |book| book.pages }.reverse

  end
end

puts "5 longest books are #{ search(books, "sort_by_pages").first(5).map{ |book| cool_print(book)} }"

puts "This books were written at 1847: #{ search(books, "books_in_year", 1847).map {|book| cool_print(book) } }"

puts "This is 10 the oldes novels #{ search(books, "find_all_novels").sort_by{ |book| book.date }.first(10).map{|book| cool_print(book)}}"

puts "Authors list #{ search(books, "author_list") }"

puts "This books haven't rating #{search(books, "without_rating").map{|book| cool_print(book)}}"

puts "This is month statistic: #{search(books, "month_statistics")}"