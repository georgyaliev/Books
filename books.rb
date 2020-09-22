require 'date'

def to_date(date)
    if date.length>4
        Date.parse(date)
    else
        Date.parse("01-01"+date)
    end
end

def make_book_hash(book_array)
  {
    link: book_array[0],
    title: book_array[1],
    author: book_array[2],
    pages: book_array[3].to_i,
    date: to_date(book_array[4]),
    rating: book_array[5].to_f,
    genres: book_array[6]
  }
end

books = File.read('books.txt')
            .split("\n")
            .map { |book_str| book_str.split('|') }
            .map { |book_array| make_book_hash(book_array) }


def cool_print(array_of_books)
    array_of_books.map{|book| "The book #{book[:title]} was written by #{book[:author]} at #{book[:date]} in #{book[:genres]} has #{book[:pages]} pages and #{book[:rating]} rating"}
end

def array_sorted_by_pages(book_array)
    book_array.sort_by { |book| book[:pages] }.reverse 
end

def books_in_year (book_array, year)
    book_array.select {|book| book[:date].year==year}
end

def novels(book_array)
    book_array.select {|book| book[:genres].include?("Novels")}
              .sort_by{ |book| book[:date] }
end

def author_list_print(book_array)
    book_array.map{ |book| book[:author].split(' ') }
              .sort_by{ |name| name.last }
              .uniq
end

def without_rating(book_array)
    book_array.select { |book| book[:rating]==0 }
end

puts "5 longest books are #{ cool_print(array_sorted_by_pages(books).first(5)) }"

puts "This books were written at 1847: #{ cool_print(books_in_year(books, 1847)) }"

puts "This is 10 the oldes novels #{cool_print(novels(books).first(10))}"

puts "Authors list #{author_list_print(books)}"

puts "There are #{cool_print(without_rating(books))} books without rating"
