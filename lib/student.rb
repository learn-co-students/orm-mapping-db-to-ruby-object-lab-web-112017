require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    req_row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    self.new_from_db(req_row)
  end

  def self.count_all_students_in_grade_9
    grade_nine_array = DB[:conn].execute("SELECT * FROM students WHERE grade = 9")

    grade_nine_array.map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    below_12 = DB[:conn].execute("SELECT * FROM students WHERE grade <12")

    below_12.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    first_x = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x)

    first_x.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    first_10 = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1").flatten

    self.new_from_db(first_10)
  end

  def self.all_students_in_grade_X(x)
    all_in_x = DB[:conn].execute("SELECT * FROM students WHERE grade =?", x)

    all_in_x.map do |row|
      self.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
